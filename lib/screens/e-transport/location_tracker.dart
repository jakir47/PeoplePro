import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:peoplepro/models/e-transport/tracker_data_model.dart';
import 'package:peoplepro/providers/hub_provider.dart';
import 'package:peoplepro/utils/colors.dart';

import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:provider/provider.dart';

class LocationTrackerScreen extends StatefulWidget {
  const LocationTrackerScreen({Key? key}) : super(key: key);

  @override
  State<LocationTrackerScreen> createState() => _LocationTrackerScreenState();
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {
  final Location _location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  final _controller = Completer<GoogleMapController>();
  final _markers = <MarkerId, Marker>{};
  var _trackerMakerIcon = BitmapDescriptor.defaultMarker;
  bool _serviceEnabled = false;
  int trackerMode = 0;
  bool trackerIsMe = false;
  bool isTrackerFound = false;

  @override
  void initState() {
    super.initState();
    _location.changeSettings(distanceFilter: 10.0);
    context
        .read<HubProvider>()
        .getHubInstance
        .on("onGetTrackerData", onGetTrackerData);
    WidgetsBinding.instance.addPostFrameCallback((_) => onLoad());
  }

  @override
  void dispose() {
    context.read<HubProvider>().getHubInstance.off("onGetTrackerData");
    if (locationSubscription != null) {
      locationSubscription!.cancel();
    }

    super.dispose();
  }

  void onGetTrackerData(data) {
    var trackerData = TrackerDataModel.fromJson(jsonDecode(data[0]));
    updateTrackerMarker(trackerData);
  }

  void onNewUserConnected(data) {
    var markerId = MarkerId(data[0]);
    _markers[markerId];
    setState(() {});
  }

  void onDisconnected(data) {
    var markerId = MarkerId(data[0]);
    _markers.removeWhere((key, value) => key == markerId);
    setState(() {});
  }

  Future<bool> checkLocationService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> onLoad() async {
    var byteData =
        await DefaultAssetBundle.of(context).load("assets/images/tracker.png");
    var trackerBytes = byteData.buffer.asUint8List();
    _trackerMakerIcon = BitmapDescriptor.fromBytes(trackerBytes);
  }

  onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    setState(() {});
  }

  void onLocationChanged(LocationData locationData) {
    var data = TrackerDataModel();
    data.latitude = locationData.latitude;
    data.longitude = locationData.longitude;
    data.heading = locationData.heading;
    data.empCode = Session.empCode;
    data.name = Session.empName;
    data.designation = Session.designation;
    data.image = base64Encode(Session.empImage);
    data.editionId = Settings.editionId;
    data.isTracker = trackerIsMe;
    context
        .read<HubProvider>()
        .getHubInstance
        .invoke("SendTrackerData", args: [jsonEncode(data)]);
  }

  Future<void> updateTrackerMarker(TrackerDataModel trackerData) async {
    var latLng = LatLng(trackerData.latitude!, trackerData.longitude!);
    var markerId = MarkerId(trackerData.empCode!);

    if (trackerData.isTracker!) {
      isTrackerFound = true;
      var controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 17.0,
          ),
        ),
      );
    }

    var markerIcon = _trackerMakerIcon;

    if ((trackerIsMe && trackerData.isTracker!) || !trackerData.isTracker!) {
      var imgBytes = base64.decode(trackerData.image!);
      markerIcon = await Utils.circleMarkerIcon(imgBytes);
    }

    var marker = Marker(
        markerId: markerId,
        position: latLng,
        rotation:
            trackerData.isTracker! && !trackerIsMe ? trackerData.heading! : 0.0,
        infoWindow: InfoWindow(
            title: trackerData.name, snippet: trackerData.designation),
        anchor: const Offset(0.5, 0.5),
        icon: markerIcon);
    _markers[markerId] = marker;
    setState(() {});
  }

  Future<void> startStopTracker() async {
    if (trackerMode != 0) {
      locationSubscription!.cancel();
      locationSubscription = null;
      trackerIsMe = false;
      trackerMode = 0;
    } else {
      var ok = await checkLocationService();
      if (ok) {
        locationSubscription =
            _location.onLocationChanged.listen(onLocationChanged);
        trackerIsMe = true;
        trackerMode = 1;
      }
    }
    setState(() {});
  }

  Future<void> startStopPassenger() async {
    if (trackerMode != 0) {
      locationSubscription!.cancel();
      locationSubscription = null;
      trackerIsMe = false;
      trackerMode = 0;
    } else {
      var ok = await checkLocationService();
      if (ok) {
        locationSubscription =
            _location.onLocationChanged.listen(onLocationChanged);
        trackerIsMe = false;
        trackerMode = 2;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Location Tracker",
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              markers: _markers.values.toSet(),
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                  target: LatLng(23.78513399, 90.41647485), zoom: 17.0),
              onMapCreated: onMapCreated,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              mapToolbarEnabled: false,
              onLongPress: (latLng) {
                //
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (!isTrackerFound)
                      if (trackerMode == 0 || trackerMode == 1)
                        ElevatedButton(
                          onPressed: () async {
                            startStopTracker();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UserColors.green,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: Text(locationSubscription == null
                              ? "I'm Tracker"
                              : "Stop Tracker"),
                        ),
                    if (trackerMode == 0 || trackerMode == 2)
                      ElevatedButton(
                        onPressed: () async {
                          startStopPassenger();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(locationSubscription == null
                            ? "I'm Passenger "
                            : "Stop Passenger"),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
