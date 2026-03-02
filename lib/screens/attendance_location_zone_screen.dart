import 'dart:async';
import 'package:peoplepro/models/attendance_location_model.dart';
import 'package:peoplepro/models/attendance_zone_model.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/dropdown_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceLocationZoneScreen extends StatefulWidget {
  const AttendanceLocationZoneScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceLocationZoneScreen> createState() =>
      _AttendanceLocationZoneScreenState();
}

class _AttendanceLocationZoneScreenState
    extends State<AttendanceLocationZoneScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final _circles = <CircleId, Circle>{};
  List<AttendanceZoneModel> _zones = <AttendanceZoneModel>[];
  List<DropdownItem> _attendanceLocations = [];
  String? _selectedAttendanceLocationId;
  List<AttendanceLocationModel> _locations = [];
  final TextEditingController _textController = TextEditingController();
  var _zoneId = 1;

  @override
  void initState() {
    super.initState();
    loadAttendanceLocations();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  loadAttendanceLocations() async {
    _locations = await UserService.getAttendanceLocations();
    _attendanceLocations = _locations
        .map((l) => DropdownItem(l.name!, l.attendanceLocationId!))
        .toList();
    setState(() {});
  }

  _loadZones() async {
    _circles.clear();
    _zones.clear();

    _zones =
        await UserService.getAttendanceZones(_selectedAttendanceLocationId!);

    for (var zone in _zones) {
      var color = UserColors.primaryColor;
      zone.color = color;
      var zoneId = _zoneId++;
      var circleId = CircleId('zone$zoneId');
      var circle = Circle(
        circleId: circleId,
        center: LatLng(zone.latitude!, zone.longitude!),
        radius: 50.0,
        strokeWidth: 1,
        fillColor: color.withOpacity(0.1),
        strokeColor: color.withOpacity(0.1),
      );
      _circles[circleId] = circle;
    }

    setState(() {});
  }

  createZone(LatLng latLng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          title: const Text(
            'Enter Zone Title',
            style: TextStyle(fontSize: 14),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 0.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: UserColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: UserColors.primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    controller: _textController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(_textController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: UserColors.primaryColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((name) {
      if (name != null && name.toString().isNotEmpty) {
        _textController.clear();
        var color = UserColors.primaryColor;
        var zoneId = _zoneId++;
        var circleId = CircleId('zone$zoneId');
        var circle = Circle(
          circleId: circleId,
          center: latLng,
          radius: 50.0,
          strokeWidth: 1,
          fillColor: color.withOpacity(0.1),
          strokeColor: color.withOpacity(0.1),
        );
        _circles[circleId] = circle;

        var zone = AttendanceZoneModel();
        zone.zoneId = zoneId;
        zone.name = name;
        zone.latitude = latLng.latitude;
        zone.longitude = latLng.longitude;
        zone.color = color;
        _zones.add(zone);
        setState(() {});
      }
    });
  }

  generateZoneBox() {
    return Column(
        children: _zones
            .map((e) => InkWell(
                onTap: () {
                  var circleId = CircleId("zone${e.zoneId}");
                  _circles.removeWhere((key, value) => key == circleId);
                  _zones.remove(e);
                  setState(() {});
                },
                child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: e.color,
                        borderRadius: BorderRadiusDirectional.circular(4.0)),
                    child: Text(
                      e.name!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ))))
            .toList());
  }

  _goToLocation(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Zone Setup",
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 17.0,
                tilt: 0.0,
              ),
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
              },
              circles: Set<Circle>.of(_circles.values),
              zoomControlsEnabled: true,
              compassEnabled: false,
              indoorViewEnabled: false,
              buildingsEnabled: false,
              padding: const EdgeInsets.all(50),
              onTap: (LatLng latLng) {
                createZone(latLng);
              },
              // liteModeEnabled: true,
            ),
            Positioned(right: 0, child: generateZoneBox()),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonWidget(
                    hint: '',
                    items: _attendanceLocations,
                    borderColor: UserColors.primaryColor,
                    selectedValue: _selectedAttendanceLocationId,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    selectedValueChanged: (value) async {
                      _selectedAttendanceLocationId = value;
                      var location = _locations
                          .where((l) => l.attendanceLocationId == value)
                          .first;
                      var latLng =
                          LatLng(location.latitude!, location.longitude!);
                      _goToLocation(latLng);
                      _loadZones();
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              child: ElevatedButton(
                onPressed: () async {
                  _zones
                      .map((e) => {
                            e.color = null,
                            e.attendanceLocationId =
                                _selectedAttendanceLocationId
                          })
                      .toList();
                  var sucess = await UserService.saveAttendanceZone(_zones);
                  if (sucess) {
                    MessageBox.success(
                        context, "Attendance Zone", "Saved successfully");
                  } else {
                    MessageBox.error(context, "Attendance Zone",
                        "Oops! something went wrong!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: UserColors.primaryColor),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
