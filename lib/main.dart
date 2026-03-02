import 'dart:io';
//import 'package:flutter_device_id/flutter_device_id.dart';
import 'package:flutter_device_id/flutter_device_id.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:peoplepro/providers/hub_provider.dart';
import 'package:peoplepro/screens/splash_screen.dart';
import 'package:peoplepro/utils/api_url.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/tracker_hub.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Settings.apiUrl = await ApiUrl.getApiUrl();

  var app = await PackageInfo.fromPlatform();
  AndroidDeviceInfo? adi =
      Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;

  IosDeviceInfo? idi = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : null;

  final device = FlutterDeviceId();
  var deviceId = await device.getDeviceId();
  Settings.appVersion = app.version;
  Settings.deviceId = deviceId!;
  Settings.manufacturer = Platform.isAndroid ? adi!.manufacturer : "Apple";
  Settings.brand = Platform.isAndroid ? adi!.brand : idi!.name;
  Settings.model = Platform.isAndroid ? adi!.model : idi!.model;
  Settings.osVersion =
      Platform.isAndroid ? adi!.version.release : idi!.systemVersion;
  Settings.isPhysicalDevice =
      Platform.isAndroid ? adi!.isPhysicalDevice : idi!.isPhysicalDevice;
  Settings.architecture = Utils.getDeviceArchitecture();
  Settings.supportedAbis =
      Platform.isAndroid ? adi!.supportedAbis[0] : idi!.utsname.machine;
  Settings.tags = Platform.isAndroid ? adi!.tags : idi!.utsname.sysname;
  Settings.sdk = Platform.isAndroid ? adi!.version.sdkInt : 0;

  Settings.edition =
      await Utils.storage.read(key: "edition") ?? "Startup Edition";

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => HubProvider()),
    ChangeNotifierProvider(create: (_) => TrackerHub()),
  ], child: const StartupScreen()));
}

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PeoplePro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: UserColors.primarySwatch,
        ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
                statusBarColor: UserColors.primaryColor,
                statusBarBrightness: Brightness.light),
            child: const SplashScreen()));
  }
}
