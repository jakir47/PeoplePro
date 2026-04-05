import 'dart:async';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:peoplepro/screens/error_screen.dart';
import 'package:peoplepro/screens/home_screen.dart';
import 'package:peoplepro/screens/login_screen.dart';
import 'package:peoplepro/services/update_service.dart';
import 'package:peoplepro/services/user_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:version/version.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();

  var visible = false;

  @override
  void initState() {
    super.initState();
  }

  static Future<void> showConnectionModal(BuildContext context) async {
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 12.0,
                  right: 16.0,
                  bottom: 6.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.red,
                          size: 30.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6.0),
                          child: Text(
                            "Network Error",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      "Your Internet connection might not be working at the moment. Please check and try again.",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            child: const Text("OK"),
                            onPressed: () async {
                              SystemNavigator.pop();
                            })),
                  ],
                ),
              ),
            ));
  }

  void _installApk(String filePath) async {
    try {
      await InstallPlugin.installApk(filePath,
          appId: 'com.bgi.jakir.peoplepro');
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }

  void onNextScreen() async {
    var authenticated = false;

    var connected = await checkInternet();
    if (!connected) {
      showConnectionModal(context);
      return;
    }

    if (Platform.isAndroid) {
      var downloadApk = await checkUpdate(context);
      if (downloadApk != null) {
        _installApk(downloadApk.path);

        // await OpenFile.open(downloadApk.path);
        SystemNavigator.pop();
        return;
      }
    }

    var isConfettiBlast = await Utils.storage.read(key: "isConfettiBlast") ?? 1;
    Settings.isConfettiBlast = isConfettiBlast == 1;

    var isRemembered = await Utils.storage.read(key: "remember");
    if (isRemembered != null && isRemembered == "1") {
      var userId = await Utils.storage.read(key: "userId");
      var password = await Utils.storage.read(key: "password");
      var stringDate = await Utils.storage.read(key: "lastSuccessAttendanceAt");
      if (stringDate != null) {
        Settings.lastSuccessAttendanceAt = DateTime.parse(stringDate);
      }

      var auth = await UserService.login(userId!, password!);

      if (auth.success!) {
        if (!auth.access!.isActive!) {
          Utils.navigateTo(
              context,
              const ErrorScreen(
                errorMessage:
                    "We're sorry, but an unexpected error occurred in our mobile app. We apologize for the inconvenience. Please try again later or contact our support team for assistance if the problem persists. Thank you for your understanding.",
              ),
              pushReplacement: true);
          return;
        }

        authenticated = await Utils.authenticate(auth, userId, password, true);
      }
    }

    if (authenticated) {
      var route = MaterialPageRoute(builder: (ctx) => const HomeScreen());
      Navigator.pushReplacement(context, route);
    } else {
      var route = MaterialPageRoute(builder: (ctx) => const LoginScreen());
      Navigator.pushReplacement(context, route);
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) return false;
    var hasConnection = await Utils.internetConnectivity();
    return hasConnection;
  }

  Future<File> getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    var downloadPath = "${dir.path}/$fileName";

    return File(downloadPath);
  }

  Future<File?> checkUpdate(BuildContext context) async {
    File? downloadedApk;
    var currentVersion = Version.parse(Settings.appVersion);
    double progress = 0;
    var downloading = false;
    var updateInfo = await UpdateService.check();
    if (updateInfo == null) return downloadedApk;

    updateInfo.isAvailable = (currentVersion < updateInfo.version);

    if (updateInfo.isAvailable!) {
      downloadedApk = await showModal(
          configuration: const FadeScaleTransitionConfiguration(
              transitionDuration: Duration(milliseconds: 300),
              reverseTransitionDuration: Duration(milliseconds: 200),
              barrierDismissible: false),
          context: context,
          builder: (context) => Dialog(
              backgroundColor: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Update Available!",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: UserColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12.0),
                              const Text(
                                  "Time to update! A new version of PeoplePro is ready to download. Don't miss out on the latest improvements.",
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black87)),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100.0,
                                    child: Text("Current version",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54)),
                                  ),
                                  Text(currentVersion.toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: UserColors.primaryColor))
                                ],
                              ),
                              const SizedBox(height: 2.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100.0,
                                    child: Text("Latest version",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54)),
                                  ),
                                  Text(updateInfo.version.toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: UserColors.primaryColor))
                                ],
                              ),
                              const SizedBox(height: 2.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100.0,
                                    child: Text("Date of release",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black54)),
                                  ),
                                  Text(updateInfo.releaseDate!,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.normal,
                                          color: UserColors.primaryColor))
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              const Text("What's new",
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black54)),
                              const SizedBox(height: 2.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(updateInfo.releaseNote!,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        color: UserColors.primaryColor)),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 8.0),
                        if (!downloading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: updateInfo.required!
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                      },
                                child: Text(
                                  "No thanks",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: updateInfo.required!
                                        ? Colors.black12
                                        : UserColors.primaryColor,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                // style: ElevatedButton.styleFrom(
                                //     minimumSize: const Size(100.0, 36.0)),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text("Update",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.white)),
                                ),
                                onPressed: () async {
                                  downloading = true;
                                  var arc = Settings.architecture;
                                  var apkUrl =
                                      "${Settings.apiUrl}/update/apk?version=${updateInfo.version}&arch=$arc";

                                  var request =
                                      http.Request('GET', Uri.parse(apkUrl));
                                  var response =
                                      await http.Client().send(request);
                                  var contentLength = response.contentLength;
                                  //var apkFile = "bgi.hris.v${updateInfo.version}-$arc-release.apk";
                                  var apkFile = "";
                                  var headers =
                                      response.headers.entries.toList();
                                  if (headers.any((header) =>
                                      header.key == "content-disposition")) {
                                    var content = headers.firstWhere((header) =>
                                        header.key == "content-disposition");
                                    apkFile = content.value
                                        .split(';')
                                        .firstWhere((item) =>
                                            item.trim().startsWith("filename="))
                                        .split('=')[1];
                                  }

                                  var file = await getFile(apkFile);
                                  var bytes = <int>[];
                                  response.stream.listen(
                                    (newBytes) {
                                      bytes.addAll(newBytes);
                                      progress = bytes.length / contentLength!;
                                      setState(() {});
                                    },
                                    onDone: () async {
                                      progress = 1;
                                      downloading = false;
                                      setState(() {});
                                      await file.writeAsBytes(bytes).then(
                                          (value) =>
                                              Navigator.pop(context, file));
                                    },
                                    onError: print,
                                    cancelOnError: true,
                                  );
                                },
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, bottom: 4.0),
                                child: Text("Downloading update...",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black87)),
                              ),
                              LinearPercentIndicator(
                                lineHeight: 2.0,
                                percent: progress,
                                backgroundColor: Colors.white,
                                linearGradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    UserColors.primaryColor,
                                    UserColors.primaryColor,
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        //  Text("Release Note: ${updateInfo.releaseNote}"),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1),
                        ),

                        Row(
                          children: [
                            // Flexible(
                            //   child: Row(
                            //     children: [
                            //       Image.asset(
                            //         'assets/images/bgi3d.png',
                            //         width: 24.0,
                            //         height: 24.0,
                            //       ),
                            //       const Padding(
                            //         padding: EdgeInsets.only(left: 4.0),
                            //         child: Text("PeoplePro",
                            //             style: TextStyle(
                            //                 fontSize: 14.0,
                            //                 color: Colors.black87)),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  "assets/images/bgi.png",
                                  height: 36,
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("DEVELOPED BY",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54)),
                                    const SizedBox(height: 2.0),
                                    Text("Md. Jakir Hossain",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: UserColors.primaryColor)),
                                    const Text(
                                        "Team Lead (Software Development)",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                );
              })));
    }

    if (updateInfo.isAvailable! &&
        updateInfo.required! &&
        downloadedApk == null) {
      SystemNavigator.pop();
    }

    return downloadedApk;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BackgroundWidget(
          showTitlebar: false,
          child: Container(
            color: Colors.white.withOpacity(0.3),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder(
                          curve: Curves.easeInQuad,
                          duration: const Duration(milliseconds: 1500),
                          tween: Tween<double>(begin: 0, end: 150),
                          builder: ((context, value, child) {
                            return Column(
                              children: [
                                Image.asset(
                                  'assets/images/bgi3d.png',
                                  width: value,
                                  height: value,
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "People",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: "Pro",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: UserColors.primaryColor,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                          onEnd: () async {
                            visible = true;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16.0),
                        AnimatedOpacity(
                          opacity: visible ? 1.0 : 0.0,
                          onEnd: (() {
                            //  onNextScreen();
                          }),
                          duration: const Duration(milliseconds: 1500),
                          child: Column(
                            children: [
                              if (Settings.edition.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 2.0,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Text(
                                    Settings.edition,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: UserColors.primaryColor,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                "Version ${Settings.appVersion}",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey.shade800),
                              ),
                              // const SizedBox(height: 8.0),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 10.0,
                              //     vertical: 2.0,
                              //   ),
                              //   decoration: BoxDecoration(
                              //       color: UserColors.red,
                              //       border: Border.all(
                              //         color: Colors.grey.shade400,
                              //         width: 0.5,
                              //       ),
                              //       borderRadius: BorderRadius.circular(4.0)),
                              //   child: Text(
                              //     "Version ${Settings.appVersion}",
                              //     style: const TextStyle(
                              //       fontSize: 12.0,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: visible ? 1.0 : 0.0,
                  onEnd: (() {
                    onNextScreen();
                  }),
                  duration: const Duration(milliseconds: 1500),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 3.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3.0)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "POWERED BY ",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey.shade800),
                              children: [
                                TextSpan(
                                    text: "BENGAL GROUP IT",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: UserColors.primaryColor)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            Utils.extractHost(Settings.apiUrl),
                            style: TextStyle(
                              fontSize: 11.0,
                              color: UserColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
