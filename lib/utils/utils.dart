import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:peoplepro/models/attendance_zone_model.dart';
import 'package:peoplepro/models/duration_model.dart';
import 'package:peoplepro/models/user_auth_model.dart';
import 'dart:ui' as ui;
import 'package:peoplepro/services/http.dart';
import 'package:peoplepro/services/security_service.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/canteen_session.dart';
import 'package:peoplepro/utils/log.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'colors.dart';

class Utils {
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<Uint8List> circleImageToUint8List(
      ui.Image image, double size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;
    final path = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size / 2, size / 2), radius: size / 2));
    canvas.clipPath(path);
    canvas.drawImage(image, Offset.zero, paint);
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<ui.Image> resizeImageWithZoom(
      ui.Image image, double size, double zoom) async {
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final destinationSize = Size(size, size);
    final scale = destinationSize.width / imageSize.width * zoom;
    final destinationRect = Rect.fromLTWH(
        (destinationSize.width - imageSize.width * scale) / 2,
        (destinationSize.height - imageSize.height * scale) / 2,
        imageSize.width * scale,
        imageSize.height * scale);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, destinationRect);
    final paint = Paint();
    paint.filterQuality = FilterQuality.high;
    paint.isAntiAlias = true;

    canvas.drawImageRect(
        image, Offset.zero & imageSize, destinationRect, paint);
    final path = Path();
    path.addOval(
        Rect.fromCircle(center: Offset(size / 2, size / 2), radius: size / 2));
    canvas.clipPath(path);
    canvas.drawImage(image, Offset.zero, paint);

    final picture = recorder.endRecording();
    return await picture.toImage(
        destinationSize.width.toInt(), destinationSize.height.toInt());
  }

  static _validatePopupNotification() {
    Settings.popupNotificationId =
        Session.userData.popNotification!.notificationId!;
    Settings.popupNotificationImageUrl =
        Utils.getImageUrl(Session.userData.popNotification!.imageName!);

    if (Session.userData.popNotification!.isRepeated!) {
      return;
    }

    if (Settings.popupNotificationId ==
        Session.userData.popNotification!.notificationId!) {
      Settings.popupNotificationId = 0;
      return;
    }
  }

  static Future<bool> authenticate(
      UserAuthModel auth, String userId, String password, bool remember) async {
    try {
      Http.access_token = auth.inteAccToken!;
      Settings.jwtToken = auth.jwtToken!;

      await Utils.setRemember(userId, password, remember);
      Settings.userAccess = auth.access!;

      Settings.edition = auth.access!.edition!;
      Settings.editionId = auth.access!.editionId!;
      Settings.debug = auth.access!.debug!;

      await Utils.storage.write(key: "edition", value: auth.access!.edition);

      var data = await UserService.getUserData(userId);

      if (data == null) return false;
      Session.userData = data;
      Session.approvalPendingCount = data.approvalPendingCount!;
      Session.empId = Session.userData.userInformation!.empId!;
      Session.empCode = Session.userData.userInformation!.empCode!;
      Session.empName = Session.userData.userInformation!.name!;
      Session.designation = Session.userData.userInformation!.designation!;
      Session.department = Session.userData.userInformation!.departmentName!;
      Session.operatingLocation =
          Session.userData.userInformation!.operatingLocation!;

      // BEGIN Canteen service
      CanteenSession.username = userId;
      CanteenSession.password = password;
      // END Canteen service

      if (Session.userData.userInformation!.photo != null) {
        Session.empImage = const Base64Decoder()
            .convert(Session.userData.userInformation!.photo!);
      } else {
        Session.empImage =
            await Utils.assetsImageToUint8List("assets/images/avatar.jpg");
      }
      _validatePopupNotification();
      Settings.serverToday = data.serverToday!;

      Settings.shiftStartTime = DateTime(Settings.serverToday.year,
          Settings.serverToday.month, Settings.serverToday.day, 9, 0, 0);

      Settings.shiftEndTime = DateTime(Settings.serverToday.year,
          Settings.serverToday.month, Settings.serverToday.day, 17, 0, 0);

      var serviceDays = DateTime.now()
          .difference(
              DateTime.parse(Session.userData.userInformation!.joiningDate!))
          .inDays;
      Settings.serviceDays = serviceDays;
      Settings.isEarnLeaveApplicable = serviceDays >= 365;

      Settings.deviceStatus = await SecurityService.getDeviceStatus();
      Settings.isActivated = Settings.deviceStatus == "Activated";

      for (var notice in Session.userData.notices!) {
        notice.thubnailImage = Image.network(
          Utils.getImageUrl(notice.thumbnail!),
          fit: BoxFit.fill,
          height: 40,
          width: 300,
        );
      }
      Log.createLogin();
      return true;
    } catch (e) {
      print(e);

      Log.create(e.toString(), "Login Error: $userId");
      return false;
    }
  }

  static String extractHost(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return 'Invalid URL';
    }
  }

  static Future<Uint8List> assetsImageToUint8List(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  static Widget divider() {
    return const Divider();
  }

  static Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  static Future<void> setRemember(
      String userId, String password, bool remember) async {
    await storage.write(key: "userId", value: userId);
    await storage.write(key: "password", value: password);
    await storage.write(key: "remember", value: remember ? "1" : "0");
  }

  static Future<void> removeRemember() async {
    await storage.delete(key: "userId");
    await storage.delete(key: "password");
    await storage.delete(key: "remember");
  }

  static void navigateTo(
    BuildContext context,
    dynamic screen, {
    bool pushReplacement = false,
  }) {
    Route route = MaterialPageRoute(builder: (context) => screen);
    if (pushReplacement) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  static Future<void> wait(BuildContext context) async {
    if (Settings.userAccess.timeout! > 0) {
      showLoadingIndicator(context);
      await Future.delayed(Duration(milliseconds: Settings.userAccess.timeout!),
          () {
        hideLoadingIndicator(context);
      });
    }
  }

  static showToast(String message,
      {ToastGravity location = ToastGravity.BOTTOM, Color? backColor}) {
    Fluttertoast.showToast(
        msg: message,
        gravity: location,
        fontSize: 14,
        backgroundColor: backColor ?? const Color.fromARGB(160, 0, 0, 0),
        textColor: Colors.white);
  }

  static double getDouble(String input) {
    if (input.isEmpty) return 0.00;
    return double.parse(input);
  }

  static void showNoInternetModal(
      BuildContext context, VoidCallback onClicked) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Connect to a network',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'To use PeoplePro, turn on mobile data or connect to Wi-Fi.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: onClicked, child: const Text("OK"))),
                  ],
                ),
              ),
            ));
  }

  static void hideLoadingIndicator(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Image.asset(
                      "assets/images/bgi.png",
                      width: 24.0,
                    ),
                  ),
                ),
                SpinKitCircle(
                  color: UserColors.primaryColor,
                  size: 68.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> internetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static Uint8List base64StringToUint8List(String base64String) {
    List<int> bytes = base64Decode(base64String);
    return Uint8List.fromList(bytes);
  }

  static Future<String> imageToBase64String(Image image) async {
    final Uint8List uint8List = await convertImageToBytes(image);
    return base64Encode(uint8List);
  }

  static InputDecoration inputDecoration() => InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: UserColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: UserColors.borderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

  static Widget poweredBy() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        text: "POWERED BY ",
        style: TextStyle(fontSize: 10, color: Colors.black87),
        children: <TextSpan>[
          TextSpan(
              text: "BENGAL GROUP IT",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  static DateTime getFirstDateOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  static DateTime getLastDateOfMonth(DateTime dateTime) {
    final DateTime nextMonth = dateTime.month < 12
        ? DateTime(dateTime.year, dateTime.month + 1, 1)
        : DateTime(dateTime.year + 1, 1, 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  static InputDecoration commonDecoration() => InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: UserColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: UserColors.borderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );

  static void showFancyCustomDialog(
    BuildContext context,
    Widget content,
    String? title,
  ) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: title != null ? 50 : 30,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: title != null
                        ? Text(
                            title,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        : const SizedBox(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      content,
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              child: const Text("CANCEL"), onPressed: () {}),
                          ElevatedButton(
                              child: const Text("OK"), onPressed: () {})
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: const Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  static void showCustomModal(
      BuildContext context, String title, String text, VoidCallback onClicked) {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      text,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: onClicked, child: const Text("OK"))),
                  ],
                ),
              ),
            ));
  }

  static void showWidgetModal(
      BuildContext context, String title, Widget child, VoidCallback onClicked,
      {String buttonText = "OK", bool isCancelVisibled = true}) {
    showModal(
      configuration: const FadeScaleTransitionConfiguration(
          transitionDuration: Duration(milliseconds: 300),
          reverseTransitionDuration: Duration(milliseconds: 200),
          barrierDismissible: false),
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red[600],
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: child,
            ),
            Divider(
              height: 1,
              color: Colors.grey[300],
            ),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isCancelVisibled,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("CANCEL"),
                      ),
                    ),
                    TextButton(
                      onPressed: onClicked,
                      child: Text(buttonText),
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

  static double calculateDistance(LatLng startLatLng, LatLng endLatLng) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((endLatLng.latitude - startLatLng.latitude) * p) / 2 +
        c(startLatLng.latitude * p) *
            c(endLatLng.latitude * p) *
            (1 - c((endLatLng.longitude - startLatLng.longitude) * p)) /
            2;
    // Output as meter since multiply by 1000.
    var output = 1000 * 12742 * asin(sqrt(a));

    return output;
  }

  static AttendanceZoneModel getNearestZone(
      List<AttendanceZoneModel> zones, LatLng deviceLatLng) {
    double minDistance = double.infinity;
    AttendanceZoneModel nearestZone = AttendanceZoneModel();

    for (AttendanceZoneModel zone in zones) {
      var zoneLatLng = LatLng(zone.latitude!, zone.longitude!);
      double distance = calculateDistance(
        deviceLatLng,
        zoneLatLng,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestZone = zone;
      }
    }

    var distanceInMeters = Utils.calculateDistance(
        deviceLatLng, LatLng(nearestZone.latitude!, nearestZone.longitude!));

    if (distanceInMeters > 100.0 && nearestZone.zoneId == 9999) {
      var newZones = zones.where((z) => z.zoneId != 9999).toList();

      minDistance = double.infinity;
      for (AttendanceZoneModel zone in newZones) {
        var zoneLatLng = LatLng(zone.latitude!, zone.longitude!);
        double distance = calculateDistance(
          deviceLatLng,
          zoneLatLng,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestZone = zone;
        }
      }
    }
    return nearestZone;
  }

  static String getImageUrl(String name) {
    var imageUrl = "${Settings.apiUrl}/hive/image?name=$name";
    return imageUrl;
  }

  static Future<Uint8List> convertImageToBytes(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(info.image)));
    final ui.Image imageUI = await completer.future;
    final ByteData? byteData =
        await imageUI.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<Uint8List> getNetworkImage(String imageUrl) async {
    var imgBytes = await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    var bytes = imgBytes.buffer.asUint8List();
    return bytes;
  }

  static Future<Uint8List?> loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var img = NetworkImage(path);
    img
        .resolve(const ImageConfiguration(size: Size.fromHeight(10)))
        .addListener(
            ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData = await imageInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData?.buffer.asUint8List();
  }

  static String formatTimeIn24Hours(TimeOfDay time) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return formatDate(date, format: "HH:mm:ss");
  }

  static String formatDate(DateTime date, {String? format}) {
    final formatPattern = format ?? 'dd/MM/yyyy';
    final formatter = DateFormat(formatPattern);
    final formattedDate = formatter.format(date);
    return formattedDate;
  }

  static formatPrice(double price) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    final formattedPrice = formatter.format(price);
    return formattedPrice;
  }

  static final currencyFormatter = NumberFormat(
    "#,##,###",
    "en_US",
  );
  static final currencyFormatter2 = NumberFormat(
    "#,##,##0.00",
    "en_US",
  );
  static final currencyFormatter3 = NumberFormat(
    "#,##,##0",
    "en_US",
  );

  static Image getAvatarImage() {
    try {
      var image = Image.memory(
        Session.empImage,
        fit: BoxFit.cover,
        scale: 2.0,
      );
      return image;
    } catch (e) {
      var avatar = Image.asset('assets/images/avatar.jpg');
      return avatar;
    }
  }

  static Future<BitmapDescriptor> circleMarkerIcon(
    Uint8List imageUint8List,
  ) async {
    double size = 100.0;
    var codec = await ui.instantiateImageCodec(imageUint8List,
        targetHeight: size.toInt(), targetWidth: size.toInt());
    var frame = await codec.getNextFrame();
    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder);
    var paint = Paint();
    paint.isAntiAlias = true;

    final path = Path();
    path.addOval(
        Rect.fromCircle(center: Offset(size / 2, size / 2), radius: size / 2));
    canvas.clipPath(path);
    canvas.drawImage(frame.image, Offset.zero, paint);

    var borderPaint = Paint();
    borderPaint.color = Colors.white;
    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 8.0;

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      borderPaint,
    );
    var picture = recorder.endRecording();
    var imgage = await picture.toImage(size.toInt(), size.toInt());
    var byteData = await imgage.toByteData(format: ui.ImageByteFormat.png);
    var bytes = byteData!.buffer.asUint8List();

    try {
      return BitmapDescriptor.fromBytes(bytes);
    } catch (e) {
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<void> addValueToStorage(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static String getOsName() {
    Map<int, String> androidVersions = {
      16: "Jelly Bean",
      17: "Jelly Bean",
      18: "Jelly Bean",
      19: "KitKat",
      21: "Lollipop",
      22: "Lollipop",
      23: "Marshmallow",
      24: "Nougat",
      25: "Nougat",
      26: "Oreo",
      27: "Oreo",
      28: "Pie",
      29: "Q",
      30: "R"
    };
    return androidVersions[Settings.sdk] ?? "Unknown";
  }

  static String getDeviceArchitecture() {
    String deviceArch = "";
    if (Platform.isAndroid) {
      // Get the device's architecture for Android

      if (Platform.version.contains("64")) {
        deviceArch = "arm64-v8a";
      } else {
        deviceArch = "armeabi-v7a";
      }
    } else if (Platform.isIOS) {
      // Get the device's architecture for iOS
      deviceArch = "";
      if (Platform.version.contains("arm64")) {
        deviceArch = "arm64";
      } else {
        deviceArch = "armv7";
      }
    } else {
      deviceArch = "Unsupported platform";
    }
    return deviceArch;
  }

  static double speedInKmh(double speedInMps) {
    var kmh = speedInMps == 0.0 ? 0.0 : (speedInMps * 3600.0) / 1000.0;
    return kmh;
  }

  static String speedInKmhAsString(double speedInMps) {
    return "${speedInKmh(speedInMps).round()} km";
  }

  static double metersInKilometers(double meters) {
    var km = meters / 1000;
    return double.parse(km.toStringAsFixed(2));
  }

  static String metersInKilometersAsString(double meters) {
    var km = meters / 1000;
    return "${km.toStringAsFixed(2)} km";
  }

  static Widget badgeText(String text, String badgeText, bool newFeature,
      {Color color = Colors.red}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: newFeature
              ? const EdgeInsets.only(top: 12.0, right: 16.0)
              : const EdgeInsets.all(0.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        if (newFeature)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(color: Colors.white, fontSize: 8.0),
              ),
            ),
          ),
      ],
    );
  }

  static DurationModel calculateDuration(
      DateTime joiningDate, DateTime lastDate) {
    int years = lastDate.year - joiningDate.year;
    int months = lastDate.month - joiningDate.month;
    int days = lastDate.day - joiningDate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += 12;
    }

    if (days < 0) {
      days += DateTime(lastDate.year, lastDate.month - 1, 0).day;
      months--;
    }

    bool isOneYearToday =
        lastDate.month == joiningDate.month && lastDate.day == joiningDate.day;
    return DurationModel(
        year: years, month: months, day: days, isOneYearToday: isOneYearToday);
  }

  static bool isValidMobileNumber(String number) {
    RegExp regex = RegExp(r'^01[0123456789]\d{8}$');
    return regex.hasMatch(number);
  }

  static bool isValidateEmail(String email) {
    final regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regExp.hasMatch(email);
  }

  static void log(dynamic value, String name) {
    print("==================$name BEGIN===================");
    print(value);
    print("==================$name END==================");
  }

  static String formatDateTimeAsReadable(DateTime date) {
    final today = Settings.serverToday;

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      final today = DateFormat("h:mma").format(date);
      return "Today at $today";
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      final yesterdayFormatted = DateFormat("h:mma").format(date);
      return "Yesterday at $yesterdayFormatted";
    }

    return DateFormat("MMMM d 'at' h:mma").format(date);
  }

  static bool isSameDate(DateTime dateTime1, DateTime dateTime2) {
    var output = dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
    return output;
  }
}
