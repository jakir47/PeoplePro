import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:peoplepro/models/e-transport/tracker_user_model.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:signalr_core/signalr_core.dart';

class TrackerHub with ChangeNotifier {
  HubConnection? _hubConnection;
  bool get isNotInitialized => _hubConnection == null;
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  final List<TrackerUserModel> _users = [];
  List<TrackerUserModel> get users => _users;

  void initialize(bool isTracker) {
    var hubUrl =
        "${Settings.apiUrl}/tracker?empCode=${Session.empCode}&name=${Session.empName}&designation=${Session.designation}&department=${Session.department}&isTracker=$isTracker&token=${Settings.jwtToken}";
    _hubConnection = HubConnectionBuilder().withUrl(hubUrl).build();
    _hubConnection!.on("onConnected", onConnected);
    _hubConnection!.on("onDisconnected", onDisconnected);
    _hubConnection!.on("onUserConnected", onUserConnected);
    _hubConnection!.on("onUserDisconnected", onUserDisconnected);
    _hubConnection!.on("onGetTrackerUsers", onGetTrackerUsers);
    _hubConnection!.on("onTrackerConnected", onTrackerConnected);
    _hubConnection!.on("onTrackerDisconnected", onTrackerDisconnected);
    _hubConnection!.onclose(onClosed);
  }

  Future<void> start() async {
    if (_hubConnection != null) {
      if (_hubConnection!.state == HubConnectionState.disconnected) {
        await _hubConnection!.start();
      }
    }
  }

  Future<void> stop() async {
    if (_hubConnection != null) {
      if (_hubConnection!.state == HubConnectionState.connected) {
        await _hubConnection!.stop();
      }
    }
  }

  onClosed(exception) {
    _isConnected = false;
    notifyListeners();
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await _hubConnection!.start();
      if (_hubConnection!.state == HubConnectionState.connected) {
        timer.cancel();
        _isConnected = true;
        notifyListeners();
      }
    });
  }

  Future<void> onConnected(connectionId) async {
    _isConnected = true;

    await _hubConnection!.invoke("GetTrackerUsers", args: []);
    notifyListeners();
  }

  void onDisconnected(connectionId) {
    _isConnected = false;
    notifyListeners();
  }

  void onUserConnected(data) {
    var json = jsonDecode(data[0]);
    var user = TrackerUserModel.fromJson(json);
    var exists = _users.where((u) => u.username == user.username);
    if (exists.isNotEmpty) {
      exists.first.connectionId = user.connectionId;
      exists.first.activityTime = user.activityTime;
    } else {
      _users.add(user);
    }
    notifyListeners();
  }

  void onUserDisconnected(data) {
    var user = TrackerUserModel.fromJson(data[0]);
    print(user.name);

    notifyListeners();
  }

  void onGetTrackerUsers(data) {
    print(data);
  }

  void onTrackerConnected(data) {
    print("Tracker connected");
    print(data);
  }

  void onTrackerDisconnected(data) {
    print("Tracker disconnected");
    print(data);
  }
}
