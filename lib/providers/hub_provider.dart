import 'dart:async';
import 'dart:convert';

import 'package:peoplepro/models/attendance_zone_model.dart';
import 'package:peoplepro/models/e-transport/tracker_data_model.dart';
import 'package:peoplepro/models/e-transport/tracker_model.dart';
import 'package:peoplepro/models/hub_user_model.dart';

import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:signalr_core/signalr_core.dart';

class HubProvider with ChangeNotifier {
  late HubConnection _hubConnection;
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  bool _isButLate = false;
  bool get isBusLate => _isButLate;
  List<HubUserModel> _hubUsers = [];
  final List<int> _notificationIds = [];
  int _lastNotificationId = 0;
  List<int> get notificationIds => _notificationIds;
  int get lastNotificationId => _lastNotificationId;

  DateTime _trackerLastTime = DateTime.now();

  bool _isTrackerAlive = false;
  bool get isTrackerAlive => _isTrackerAlive && isAlive();

  HubConnection get getHubInstance => _hubConnection;

  String _trackerId = "";
  bool get trackerIsMe => _trackerId == Session.empCode;

  String _hideMeFromTrackerId = "";
  String get getHideMeFromTrackerId => _hideMeFromTrackerId;

  TrackerModel _trackerData = TrackerModel();
  TrackerModel get onTrackerMove => _trackerData;

  TrackerDataModel? _trackerData2;
  TrackerDataModel? get onTrackerDataReceived => _trackerData2;

  String get getTrackerId => _trackerId;

  List<HubUserModel> get hubUsers {
    _hubUsers.sort((a, b) {
      if (a.isConnected && !b.isConnected) {
        return -1;
      } else if (!a.isConnected && b.isConnected) {
        return 1;
      } else {
        return b.lastSeen.millisecondsSinceEpoch
            .compareTo(a.lastSeen.millisecondsSinceEpoch);
      }
    });

    return _hubUsers;
  }

  bool isAlive() {
    Duration difference = DateTime.now().difference(_trackerLastTime);
    return difference.inSeconds < 10;
  }

  void setLastNotificationId(int notificationId) {
    _lastNotificationId = notificationId;
    notifyListeners();
  }

  void setUnseenNotificationIds(List<int> notificationIds) {
    _notificationIds.addAll(notificationIds);
    notifyListeners();
  }

  void removeNotificationId(int notificationId) {
    _notificationIds.remove(notificationId);
    notifyListeners();
  }

  void removeNotificationIds() {
    _notificationIds.clear();
    notifyListeners();
  }

  Future<void> buildConnection() async {
    var hubUrl = "${Settings.apiUrl}/hub?token=${Settings.jwtToken}";
    _hubConnection = HubConnectionBuilder().withUrl(hubUrl).build();
    _hubConnection.on("onConnected", onConnected);

    _hubConnection.on("onDisconnected", onDisconnected);
    _hubConnection.on("onUserConnected", onUserConnected);
    _hubConnection.on("onUserDisconnected", onUserDisconnected);
    _hubConnection.on("onSubscribers", onSubscribers);
    _hubConnection.on("onBusLateCircle", onBusLateCircle);
    _hubConnection.on("onTrackerStarted", onTrackerStarted);
    _hubConnection.on("onTrackerStopped", onTrackerStopped);
    _hubConnection.on("onGetLocation", onGetLocation);
    _hubConnection.on("onHideMeFromTracker", onHideMeFromTracker);
    _hubConnection.on("onGetTrackerData", onGetTrackerData);

    _hubConnection.onclose(onClosed);
    _hubConnection.onreconnected(onReconnected);
    await _hubConnection.start();
  }

  onClosed(exception) {
    _isConnected = false;
    notifyListeners();
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _hubConnection.start();
      if (_hubConnection.state == HubConnectionState.connected) {
        timer.cancel();
        _isConnected = true;
        notifyListeners();
      }
    });
  }

// e-Transport =================== BEGIN
  Future<void> startTracker() async {
    var data = "${Session.empCode}|${Settings.editionId}";
    await _hubConnection.invoke("StartTracker", args: [data]);
  }

  void onTrackerStarted(data) {
    var pieces = data[0].toString().split('|');
    var empCode = pieces[0];
    var editionId = int.parse(pieces[1]);
    if (editionId == Settings.editionId) {
      _trackerId = empCode;
      _isTrackerAlive = true;
      notifyListeners();
    }
  }

  Future<void> stopTracker() async {
    await _hubConnection
        .invoke("StopTracker", args: [Settings.editionId.toString()]);
  }

  void onTrackerStopped(data) {
    var editionId = data[0];
    if (editionId == 1) {
      editionId = Settings.editionId.toString();
    }
    if (editionId == Settings.editionId.toString()) {
      _trackerId = "";
      _isTrackerAlive = false;
      notifyListeners();
    }
  }

  Future<void> sendTrackerData(TrackerDataModel trackerData) async {
    var data = jsonEncode(trackerData);
    await _hubConnection.invoke("SendTrackerData", args: [data]);
  }

  void onGetTrackerData(data) {
    var trackerData = TrackerDataModel.fromJson(jsonDecode(data[0]));
    _trackerData2 = trackerData;
    notifyListeners();
  }

  Future<void> sendMyLocation(TrackerModel trackerData) async {
    var data = jsonEncode(trackerData);

    await _hubConnection.invoke("SendMyLocation", args: [data]);
  }

  Future<void> hideMeFromTracker() async {
    await _hubConnection.invoke("HideMeFromTracker", args: [Session.empCode]);
  }

  void onHideMeFromTracker(data) {
    _hideMeFromTrackerId = data[0];

    notifyListeners();
  }

  void onGetLocation(data) {
    var trackerData = TrackerModel.fromJson(jsonDecode(data[0]));
    if (trackerData.editionId == 1 || trackerData.editionId == 7) {
      trackerData.editionId = Settings.editionId;
    }

    if (trackerData.editionId == Settings.editionId) {
      _trackerData = trackerData;

      if (trackerData.empCode == _hideMeFromTrackerId) {
        _hideMeFromTrackerId = "";
      }

      if (trackerData.isTracker!) {
        _trackerId = trackerData.empCode!;
        _isTrackerAlive = true;
        _trackerLastTime = DateTime.now();
      }

      notifyListeners();
    }
  }

  void onBusLateCircle(data) {
    if (Settings.editionId == 1 || Settings.editionId == 7) {
      var lateLng = data[0].toString().split(',');
      var zone = AttendanceZoneModel();
      zone.zoneId = 9999;
      zone.name = "Late Zone";
      zone.latitude = double.parse(lateLng[0]);
      zone.longitude = double.parse(lateLng[1]);
      Session.userData.attendanceZones!.add(zone);
      _isButLate = true;
      notifyListeners();
    }
  }

// e-Transport =================== END
  void onUserConnected(data) {
    var json = data[0];
    var user = HubUserModel.fromJson(json);
    var exists = _hubUsers.where((u) => u.empCode == user.empCode);
    if (exists.isNotEmpty) {
      exists.first.isConnected = user.isConnected;
      exists.first.lastSeen = user.lastSeen;
    } else {
      _hubUsers.add(user);
    }
    _isConnected = true;
    notifyListeners();
  }

  void onUserDisconnected(data) {
    var json = data[0];
    var user = HubUserModel.fromJson(json);
    var exists = _hubUsers.where((u) => u.empCode == user.empCode);
    if (exists.isNotEmpty) {
      exists.first.isConnected = user.isConnected;
      exists.first.lastSeen = user.lastSeen;
    }
    _isConnected = true;
    notifyListeners();
  }

  void onSubscribers(data) {
    final parsed = data[0].cast<Map<String, dynamic>>();
    _hubUsers = parsed
        .map<HubUserModel>((json) => HubUserModel.fromJson(json))
        .toList();
    notifyListeners();
  }

  void onUserListUpdated(data) {
    final parsed = data[0].cast<Map<String, dynamic>>();
    _hubUsers = parsed
        .map<HubUserModel>((json) => HubUserModel.fromJson(json))
        .toList();
    notifyListeners();
  }

  void onReconnected(connectionId) {
    _isConnected = true;
    notifyListeners();
  }

  Future<void> onConnected(connectionId) async {
    final user = {
      "empCode": Session.empCode,
      "name": Session.empName,
      "designation": Session.designation,
      "department": Session.department,
    };

    var json = jsonEncode(user);
    await _hubConnection.invoke("onSubscribe", args: [json]);

    _isConnected = true;
    notifyListeners();
  }

  void onDisconnected(connectionId) {
    _isConnected = false;
    notifyListeners();
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
    _isConnected = false;
    notifyListeners();
  }

  Future<void> setBusLateLocation(String latLng) async {
    await _hubConnection.invoke("onBusLateLocationSet", args: [latLng]);
  }

  Future<void> setBusLateCircle(String latLng) async {
    await _hubConnection.invoke("onBusLateCircleSet", args: [latLng]);
  }
}
