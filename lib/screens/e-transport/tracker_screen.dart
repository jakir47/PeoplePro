import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:peoplepro/models/e-transport/tracker_model.dart';
import 'package:peoplepro/providers/hub_provider.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:provider/provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final Location _location = Location();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final _markers = <MarkerId, Marker>{};

  BitmapDescriptor _trackerMakerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _userMakerIcon = BitmapDescriptor.defaultMarker;

  late bool wakelockEnabled;

  bool geocodingAddressEnabled = false;

  bool isTrackerAlive = false;
  bool trackerIsMe = false;
  late StreamSubscription trackerLocationSubscription;
  late StreamSubscription<LocationData> myLocationSubscription;

  @override
  void initState() {
    super.initState();

    onLoad();
  }

  @override
  void dispose() {
    trackerLocationSubscription.cancel();
    myLocationSubscription.cancel();
    super.dispose();
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

  void onLoad() async {
    var byteData =
        await DefaultAssetBundle.of(context).load("assets/images/tracker.png");
    var trackerBytes = byteData.buffer.asUint8List();
    _trackerMakerIcon = BitmapDescriptor.fromBytes(trackerBytes);
    var userByteData =
        await DefaultAssetBundle.of(context).load("assets/images/tracker.png");
    var userBytes = userByteData.buffer.asUint8List();
    _userMakerIcon = BitmapDescriptor.fromBytes(userBytes);

    isTrackerAlive = context.read<HubProvider>().isTrackerAlive;
    trackerIsMe = context.read<HubProvider>().trackerIsMe;
    setState(() {});
    trackerLocationSubscription = Stream.periodic(const Duration(seconds: 1))
        .listen((_) => trackerUpdater());

    var serviceEnabled = await checkLocationService();
    if (serviceEnabled) {
      myLocationSubscription =
          _location.onLocationChanged.listen(onMyLocationChanged);
    }
  }

  void onMyLocationChanged(LocationData locationData) {
    var data = TrackerModel();
    data.latitude = locationData.latitude;
    data.longitude = locationData.longitude;
    data.heading = locationData.heading;
    data.editionId = Settings.editionId;
    data.empCode = Session.empCode;
    data.name = Session.empName;
    data.designation = Session.designation;
    data.image = "";

    // base64Encode(Session.empImage);
    data.isTracker = context.read<HubProvider>().trackerIsMe;
    context.read<HubProvider>().sendMyLocation(data);
  }

  trackerUpdater() async {
    var hideMarkerId = context.read<HubProvider>().getHideMeFromTrackerId;
    var markerId = MarkerId(hideMarkerId);
    _markers.removeWhere((key, value) => key == markerId);
    isTrackerAlive = context.read<HubProvider>().isTrackerAlive;
    trackerIsMe = context.read<HubProvider>().trackerIsMe;

    setState(() {});

    var trackerData = context.read<HubProvider>().onTrackerMove;

    if (trackerData.isTracker!) {
      updateTrackerMarker(trackerData);
    } else {
      updateUserTracker(trackerData);
    }
  }

  Future<void> updateUserTracker(TrackerModel trackerData) async {
    var markerId = MarkerId(trackerData.empCode!);
    var marker = Marker(
        markerId: markerId,
        rotation: 0.0,
        position: LatLng(trackerData.latitude!, trackerData.longitude!),
        infoWindow: InfoWindow(
            title: trackerData.name, snippet: trackerData.designation),
        anchor: const Offset(0.5, 0.5),
        icon: _userMakerIcon);
    _markers[markerId] = marker;

    setState(() {});
  }

  Future<void> updateTrackerMarker(TrackerModel trackerData) async {
    var latLng = LatLng(trackerData.latitude!, trackerData.longitude!);
    var markerId = MarkerId(trackerData.empCode!);
    var controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 17.0,
        ),
      ),
    );
    var marker = Marker(
        markerId: markerId,
        position: latLng,
        infoWindow: InfoWindow(
            title: trackerData.name, snippet: trackerData.designation),
        anchor: const Offset(0.5, 0.5),
        icon: _trackerMakerIcon);
    _markers[markerId] = marker;

    setState(() {});
  }

  onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    setState(() {});
  }

  exitScreen() {
    var trackerIsMe = context.read<HubProvider>().trackerIsMe;
    if (trackerIsMe) {
      context.read<HubProvider>().stopTracker();
    }
    context.read<HubProvider>().hideMeFromTracker();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitScreen();
        return true;
      },
      child: Scaffold(
          body: BackgroundWidget(
        title: "Tracker",
        leadingWidget: IconButton(
            onPressed: () {
              exitScreen();
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: UserColors.primaryColor,
            )),
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
                child: isTrackerAlive == false
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            context.read<HubProvider>().startTracker();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: const Text("Start Tracker"),
                        ))
                    : trackerIsMe == true
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ElevatedButton(
                              onPressed: () async {
                                context.read<HubProvider>().stopTracker();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: const Text("Stop Tracker"),
                            ),
                          )
                        : const SizedBox.shrink()),
          ],
        ),
      )),
    );
  }
}
