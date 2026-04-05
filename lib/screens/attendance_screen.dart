import 'dart:async';
import 'package:peoplepro/models/attendance_zone_model.dart';
import 'package:peoplepro/models/attendnace_data_model.dart';
import 'package:peoplepro/services/attendance_service.dart';
import 'package:peoplepro/services/security_service.dart';
import 'package:peoplepro/utils/log.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final _markers = <MarkerId, Marker>{};
  final _markerId = MarkerId(Session.empCode);
  final _circles = <CircleId, Circle>{};
  BitmapDescriptor _userMakerIcon = BitmapDescriptor.defaultMarker;
  bool _isTrafficEnabled = false;

  bool _isValidLocation = false;

  double _distance = 0.0;
  String _distanceAway = "0";
  String _distanceUnitName = "meter";
  String _attendanceZone = "zone";

  String _deviceStatus = "Please activate your device to access this feature!";
  bool _isBusLateEnabled = false;
  Timer? _timer;
  bool _isReady = false;

  DateTime? _inTime;

  @override
  void initState() {
    super.initState();

    onLoad();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }

    if (_timer != null) {
      _timer!.cancel();
    }

    super.dispose();
  }

  void onLoad() async {
    if (Settings.deviceStatus == "Request") {
      var requested = await SecurityService.createDeviceRequest();
      if (requested) {
        _deviceStatus = "Please exit and run the app again.";
        setState(() {});
        Log.createDeviceActivation();
      }

      return;
    }

    if (!Settings.isActivated) return;

    if (Session.userData.attendanceBaseLatLng == null) {
      _deviceStatus = "Invalid operating location!";
      return;
    }

    var enabled = await checkLocationService();
    if (!enabled) return;

    createAttendaceCirles();

    var inTimeData = await Utils.storage.read(key: "inTime");
    if (inTimeData != null) {
      _inTime = DateTime.parse(inTimeData.toString());
      setState(() {});
      Utils.log(_inTime, "In time ");
    }

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData location) {
      updateMapOnMove(location);
    });
  }

  Future<void> saveInTimeOnStorage(DateTime inTime) async {
    await Utils.storage.write(key: "inTime", value: inTime.toIso8601String());
    _inTime = inTime;
  }

  void onMapCreated(GoogleMapController controller) async {
    if (Settings.userAccess.timeout! > 0) {
      await Future.delayed(
          Duration(milliseconds: Settings.userAccess.timeout! * 5), () async {
        _controller.complete(controller);
        _userMakerIcon = await Utils.circleMarkerIcon(Session.empImage);
        _isReady = true;
        setState(() {});
      });
    } else {
      _controller.complete(controller);
      _userMakerIcon = await Utils.circleMarkerIcon(Session.empImage);
      _isReady = true;
      setState(() {});
    }
  }

  void updateMapOnMove(LocationData location) async {
    var latLng = LatLng(location.latitude!, location.longitude!);
    var nearestZone =
        Utils.getNearestZone(Session.userData.attendanceZones!, latLng);
    var nearestLatLng = LatLng(nearestZone.latitude!, nearestZone.longitude!);

    calculateDistance(nearestLatLng, latLng);
    var controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude!, location.longitude!),
          zoom: 17.0,
          bearing: 0.0,
          tilt: 0.0,
        ),
      ),
    );
    _attendanceZone = nearestZone.zoneId == 9999
        ? "${Settings.edition.replaceFirst("Edition", "")}Zone"
        : nearestZone.name!;
    updateLocationMarker(location);
    setState(() {});
  }

  void createAttendaceCirles() async {
    for (var loc in Session.userData.attendanceZones!) {
      var isLate = loc.zoneId == 9999;

      var color = isLate ? Colors.transparent : Colors.green.withOpacity(0.1);
      if (Session.empCode == "047785") {
        color = Colors.green.withOpacity(0.1);
      }

      var circleId = CircleId('zone${loc.zoneId}');
      var circle = Circle(
        circleId: circleId,
        center: LatLng(loc.latitude!, loc.longitude!),
        radius: 50.0,
        strokeWidth: 1,
        fillColor: color,
        strokeColor: color,
      );
      _circles[circleId] = circle;
    }
  }

  void updateLocationMarker(LocationData location) {
    var marker = Marker(
        markerId: _markerId,
        rotation: 0.0, // location.heading!,
        position: LatLng(location.latitude!, location.longitude!),
        infoWindow:
            InfoWindow(title: Session.empName, snippet: Session.designation),
        anchor: const Offset(0.5, 0.5),
        icon: _userMakerIcon);
    setState(() => _markers[_markerId] = marker);
  }

  void calculateDistance(LatLng nearestLocation, LatLng userLatLng) {
    var distanceInMeters = Utils.calculateDistance(
      userLatLng,
      nearestLocation,
    );

    if (distanceInMeters > 1000) {
      _isValidLocation = false;
      _distance = (distanceInMeters / 1000).roundToDouble();
      _distanceUnitName = _distance > 1.0 ? "kilometers" : "kilometer";
      _distanceAway = ((distanceInMeters - 50.0) / 1000.0).toStringAsFixed(1);
    } else {
      _isValidLocation = distanceInMeters <= 50;
      _distance = distanceInMeters.roundToDouble();
      _distanceAway = (_distance - 50).toString();
      _distanceUnitName = _distance > 1.0 ? "meters" : "meter";
    }
    setState(() {});
  }

  Future<bool> checkLocationService() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    var permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void showMockMessage() {
    MessageBox.withWidget(
      context,
      "Mock Detected!",
      const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "You are trying to provide attendance illegally by using mock GPS. Your activity has been recorded as evidence.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 12.0),
          Text(
            "Attendance feature has been locked.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
        ],
      ),
      OkColor: Colors.red,
      headerColor: Colors.red,
    );
  }

  void showDeveloperModeMessage() {
    MessageBox.withWidget(
      context,
      "Suspicious Activity!",
      const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Attendance not allowed in developer mode.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      OkColor: Colors.red,
      headerColor: Colors.red,
    );
  }

  void showInvalidLocationMessage() {
    MessageBox.error(context, "Attendance", "Invalid attendance location.");
  }

  Future<AttendanceDataModel> validateLocation() async {
    var data = AttendanceDataModel(isValid: false);

    data.service = await checkLocationService();
    if (!data.service!) return data;

    var locationData = await _location.getLocation();
    data.latitude = locationData.latitude;
    data.longitude = locationData.longitude;
    data.isMocked = locationData.isMock;
    if (data.isMocked!) return data;

    var latLng = LatLng(locationData.latitude!, locationData.longitude!);
    var nearestZone =
        Utils.getNearestZone(Session.userData.attendanceZones!, latLng);
    var zoneLatLng = LatLng(nearestZone.latitude!, nearestZone.longitude!);
    var distanceInMeters = Utils.calculateDistance(latLng, zoneLatLng);
    data.outOfZone = distanceInMeters > 50.0;
    if (data.outOfZone!) return data;

    data.zoneId = nearestZone.zoneId!;
    data.isValid = true;
    return data;
  }

  void showWaitMessage(int minutes) {
    var waitMinutes = 3 - minutes;
    MessageBox.error(context, "Attendance",
        "Please wait ${waitMinutes.toString()} minutes and try again.");
  }

  Future<void> submitAttendace() async {
    if (Settings.lastSuccessAttendanceAt != null) {
      var minutes = DateTime.now()
          .difference(Settings.lastSuccessAttendanceAt!)
          .inMinutes;

      if (minutes < 3) {
        showWaitMessage(minutes);
        return;
      }
    }

    Utils.showLoadingIndicator(context);

    var data = await validateLocation();
    if (data.isValid!) {
      var latLng = "${data.latitude},${data.longitude}";
      var clientTime = DateTime.now();
      var attendTime =
          await AttendanceService.take(latLng, data.zoneId!, clientTime);
      Utils.hideLoadingIndicator(context);
      if (attendTime != null) {
        Utils.storage.write(
            key: "lastSuccessAttendanceAt", value: DateTime.now().toString());
        Settings.lastSuccessAttendanceAt = DateTime.now();

        saveInTimeOnStorage(attendTime);
        MessageBox.successWidget(
            context,
            "Attendance",
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Attendance taken successfully"),
                const SizedBox(height: 4.0),
                Text(
                  Utils.formatDate(attendTime, format: "hh:mm:ss a"),
                  style: TextStyle(
                      color: UserColors.primaryColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ));
      } else {
        MessageBox.error(context, "Attendance", "An error occurred");
      }
    } else {
      Utils.hideLoadingIndicator(context);
      if (!data.service!) {
        MessageBox.error(
            context, "Attendance", "Location service not enabled.");
      } else if (data.isMocked!) {
        await Log.createMock(LatLng(data.latitude!, data.longitude!));
        showMockMessage();
      } else if (data.outOfZone!) {
        MessageBox.error(context, "Attendance", "You're out of zone.");
      } else {
        MessageBox.error(context, "Attendance", "An unknown error occurred.");
      }
    }
  }

  void _handleTap(LatLng loc) {
    var zoneId = _circles.length + 1;
    var circleId = CircleId('zone$zoneId');
    var circle = Circle(
      circleId: circleId,
      center: LatLng(loc.latitude, loc.longitude),
      radius: 50.0,
      strokeWidth: 1,
      fillColor: Colors.lightGreen.withOpacity(0.1),
      strokeColor: Colors.lightGreen.withOpacity(0.1),
    );
    _circles[circleId] = circle;

    var zone = AttendanceZoneModel();
    zone.zoneId = zoneId;
    zone.name = "Devzone";
    zone.latitude = loc.latitude;
    zone.longitude = loc.longitude;
    Session.userData.attendanceZones!.add(zone);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Attendance",
        child: Settings.isActivated
            ? Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          Session.userData.attendanceBaseLatLng!.latitude!,
                          Session.userData.attendanceBaseLatLng!.longitude!),
                      zoom: 17.0,
                      tilt: 0.0,
                    ),
                    onMapCreated: onMapCreated,
                    markers: Set<Marker>.of(_markers.values),
                    circles: Set<Circle>.of(_circles.values),
                    trafficEnabled: _isTrafficEnabled,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: false,
                    buildingsEnabled: false,
                    mapToolbarEnabled: false,
                    padding: const EdgeInsets.all(50),
                    onTap: Session.empCode == "047785" ? _handleTap : null,
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (_inTime != null)
                                  Visibility(
                                    visible: Utils.isSameDate(
                                        _inTime!, Settings.serverToday),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: "",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87),
                                            children: [
                                              WidgetSpan(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0),
                                                child: Icon(Icons.check_circle,
                                                    size: 16.0,
                                                    color: UserColors
                                                        .primaryColor),
                                              )),
                                              TextSpan(
                                                  text: Utils.formatDate(
                                                      _inTime!,
                                                      format: "hh:mm:ss a"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: UserColors.green)),
                                            ],
                                          )),
                                    ),
                                  ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (Session.empCode == "047785")
                                        ClipOval(
                                          child: Material(
                                            color: _isBusLateEnabled
                                                ? UserColors.primaryColor
                                                : UserColors.primaryColor
                                                    .withOpacity(0.5),
                                            child: InkWell(
                                              splashColor:
                                                  UserColors.primaryColor,
                                              child: const SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: Icon(
                                                  Icons.location_pin,
                                                  color: Colors.white,
                                                  size: 24.0,
                                                ),
                                              ),
                                              onTap: () {
                                                _isBusLateEnabled =
                                                    !_isBusLateEnabled;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      ClipOval(
                                        child: Material(
                                          color: _isTrafficEnabled
                                              ? UserColors.primaryColor
                                              : UserColors.primaryColor
                                                  .withOpacity(0.5),
                                          child: InkWell(
                                            splashColor:
                                                UserColors.primaryColor,
                                            child: const SizedBox(
                                              width: 32,
                                              height: 32,
                                              child: Icon(
                                                Icons.traffic,
                                                color: Colors.white,
                                                size: 24.0,
                                              ),
                                            ),
                                            onTap: () {
                                              _isTrafficEnabled =
                                                  !_isTrafficEnabled;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ])
                              ]))),
                  if (_isReady)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Column(
                          children: [
                            Visibility(
                              visible: _isValidLocation,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: InkWell(
                                  onTap: () => submitAttendace(),
                                  child: Icon(
                                    Icons.fingerprint_outlined,
                                    color: UserColors.primaryColor,
                                    size: 60.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            SizedBox(
                              width: double.infinity,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: _isValidLocation
                                    ? TextSpan(
                                        text: "You are in ",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                        children: [
                                          TextSpan(
                                              text: _attendanceZone,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      UserColors.primaryColor)),
                                        ],
                                      )
                                    : TextSpan(
                                        text: "You are ",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                        children: [
                                          TextSpan(
                                            text: _distanceAway,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _isValidLocation
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                          TextSpan(
                                              text:
                                                  " $_distanceUnitName away from ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                              )),
                                          TextSpan(
                                              text: _attendanceZone,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: _isValidLocation
                                                      ? Colors.red
                                                      : UserColors
                                                          .primaryColor)),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: UserColors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _deviceStatus,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
