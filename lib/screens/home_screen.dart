import 'dart:async';
import 'dart:io';
import 'package:peoplepro/providers/hub_provider.dart';
import 'package:peoplepro/screens/about_screen.dart';
import 'package:peoplepro/screens/approval_screen.dart';
import 'package:peoplepro/screens/attendance_regularization_screen.dart';
import 'package:peoplepro/screens/attendance_screen.dart';
import 'package:peoplepro/screens/bus_late_screen.dart';
import 'package:peoplepro/screens/change_password_screen.dart';
import 'package:peoplepro/screens/control_panel_screen.dart';
import 'package:peoplepro/screens/e-canteen/canteen_admin_screen.dart';
import 'package:peoplepro/screens/e-canteen/canteen_home_screen2.dart';
import 'package:peoplepro/screens/e-directory/directory_screen.dart';
import 'package:peoplepro/screens/e-transport/tracker_demo.dart';
import 'package:peoplepro/screens/employee_attendance_screen.dart';
import 'package:peoplepro/screens/employee_directory_search_screen.dart';
import 'package:peoplepro/screens/employee_poll_screen.dart';
import 'package:peoplepro/screens/notice_viewer_screen.dart';
import 'package:peoplepro/screens/holiday_list_screen.dart';
import 'package:peoplepro/screens/job_card_screen.dart';
import 'package:peoplepro/screens/leave_application_list_screen.dart';
import 'package:peoplepro/screens/login_screen.dart';
import 'package:peoplepro/screens/my_profile_screen.dart';
import 'package:peoplepro/screens/notice_screen.dart';
import 'package:peoplepro/screens/notification_list_screen.dart';
import 'package:peoplepro/screens/outstation_list_screen.dart';
import 'package:peoplepro/screens/payslip_screen.dart';
import 'package:peoplepro/screens/policies_screen.dart';
import 'package:peoplepro/screens/profile_update_modal_screen.dart';
import 'package:peoplepro/screens/profile_update_screen.dart';
import 'package:peoplepro/screens/provident_fund_screen.dart';
import 'package:peoplepro/screens/resetter_screen.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/log.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/drawer_widget.dart';
import 'package:peoplepro/widgets/icon_button_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  var drawerKey = GlobalKey<ScaffoldState>();

  final _controllerStarBlast =
      ConfettiController(duration: const Duration(seconds: 10));
  bool _starBlasting = false;
  var appLastNotificationId = Session.userData.lastNotificationId!;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
  }

  @override
  void dispose() {
    context.read<HubProvider>().disconnect();
    _controllerStarBlast.dispose();
    super.dispose();
  }

  void initialize() async {
    context.read<HubProvider>().buildConnection();

    var userLastNotificationId = context.read<HubProvider>().lastNotificationId;

    if (userLastNotificationId == 0) {
      userLastNotificationId = appLastNotificationId - 1;
    }

    List<int> unseenNotificationIds = Iterable.generate(
        appLastNotificationId - userLastNotificationId,
        (i) => userLastNotificationId + i + 1).toList();

    context.read<HubProvider>().setUnseenNotificationIds(unseenNotificationIds);
    context.read<HubProvider>().setLastNotificationId(appLastNotificationId);
    // Utils.addValueToStorage("notificationId", "0");
    checkModalNotification();

    var joiningDate = DateTime.parse(
        Session.userData.userInformation?.joiningDate ?? "2020-11-10T00:00:00");

    var today = DateTime(Settings.serverToday.year, Settings.serverToday.month,
        Settings.serverToday.day);
    var anniversaryDate =
        DateTime(Settings.serverToday.year, joiningDate.month, joiningDate.day);

    var annivKey = "anniv-${Settings.serverToday.year}";
    var annivBlasted = await Utils.storage.read(key: annivKey);

    if (today == anniversaryDate && annivBlasted == null) {
      workAnniversaryModal(joiningDate, today);
      Utils.storage.write(key: annivKey, value: "done");
    } else if (Settings.isConfettiBlast) {
      Utils.storage.write(key: "isConfettiBlast", value: "0");
      _controllerStarBlast.play();
    }
    // checkProfileComplete();
    if (Settings.debug) {
      Future.delayed(const Duration(seconds: 10), () {
        exit(1);
        //createUnresponsiveState();
      });
    }
  }

  Future<void> checkProfileComplete() async {
    var profileComplete = await Utils.storage.read(key: 'profileComplete');
    if (profileComplete != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const PopScope(
          canPop: false,
          child: Dialog(
            child: ProfileUpdateModalScreen(),
          ),
        ),
      );
    }
  }

  void createUnresponsiveState() {
    Timer.run(() {
      while (true) {
        //
      }
    });
  }

  void workAnniversaryModal(DateTime joiningDate, DateTime today) {
    int yearsOfService = today.year - joiningDate.year;
    if (today.month < joiningDate.month ||
        (today.month == joiningDate.month && today.day < joiningDate.day)) {
      yearsOfService--;
    }
    String name = Session.empName;
    String designation = Session.designation;
    String department = Session.department;

    final confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          content: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 48.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 40.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Color.fromARGB(255, 141, 204, 255),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Work Anniversary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text("🎉 Congratulations, $name! 🎉"),
                          const SizedBox(height: 14.0),
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              children: [
                                const TextSpan(text: "On completing "),
                                TextSpan(
                                  text:
                                      "$yearsOfService ${yearsOfService == 1 ? 'year' : 'years'}",
                                  style: TextStyle(
                                    color: UserColors.primaryColor,
                                  ),
                                ),
                                const TextSpan(
                                    text: " of dedicated service as "),
                                TextSpan(
                                  text: designation,
                                  style: TextStyle(
                                    color: UserColors.primaryColor,
                                  ),
                                ),
                                const TextSpan(text: " in the "),
                                TextSpan(
                                  text: department,
                                  style: TextStyle(
                                    color: UserColors.primaryColor,
                                  ),
                                ),
                                const TextSpan(text: " department."),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14.0),
                          const Text(
                              "Your hard work and commitment are truly appreciated!"),
                          const SizedBox(height: 14.0),
                          const Text(
                              "We look forward to many more successful years together!"),
                          ConfettiWidget(
                            confettiController: confettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            shouldLoop: false,
                            numberOfParticles: 50,
                            emissionFrequency: 0.05,
                            maxBlastForce: 50,
                            minBlastForce: 20,
                            gravity: 0.3,
                            colors: [
                              Colors.green.shade700,
                              Colors.blue.shade700,
                              Colors.red.shade700,
                              Colors.orange.shade700,
                              Colors.yellow.shade700
                            ],
                            createParticlePath: Utils.drawStar,
                          ),
                        ],
                      ),
                    )),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.close_outlined,
                      size: 18.0,
                      color: UserColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void checkModalNotification() {
    if (Settings.popupNotificationId == 0) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          content: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 50.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(Settings.popupNotificationImageUrl)),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Utils.storage.write(
                        key: "popupNotificationId",
                        value: Settings.popupNotificationId.toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.close_outlined,
                      size: 18.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  DateTime currentBackPressTime = DateTime.now();
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Utils.showToast("Press again to exit.");
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    var isConnected = context.watch<HubProvider>().isConnected;
    var notificationCount = context.watch<HubProvider>().notificationIds.length;
    return Scaffold(
      key: drawerKey,
      drawer: Drawer(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: DrawerWidget(onMenuItemClicked: (index) async {
            Navigator.pop(context);

            await Utils.wait(context);

            if (index == 0) {
              await Utils.removeRemember().whenComplete(() {
                Log.createLogout();
                context.read<HubProvider>().disconnect();
                Utils.navigateTo(context, const LoginScreen(),
                    pushReplacement: true);
              });
            } else if (index == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ResetterScreen()));
            } else if (index == 2) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EmployeePollScreen()));
            } else if (index == 3) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EmployeeAttendanceScreen()));
            } else if (index == 4) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const CanteenAdminScreen();
              }));
            } else if (index == 5) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfileUpdateScreen()));
            } else if (index == 6) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NotificationListScreen()));
            } else if (index == 7) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NoticeScreen()));
            } else if (index == 8) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ControlPanelScreen()));
            } else if (index == 9) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutScreen()));
            } else if (index == 10) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TrackerDemo()));
            } else if (index == 11) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen()));
            } else if (index == 12) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BusLateScreen()));
            } else if (index == 13) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const AttendanceRegularizationScreen()));
            }
          })),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: BackgroundWidget(
          showBottomStrip: false,
          leadingWidget: IconButton(
            onPressed: () {
              if (drawerKey.currentState!.isDrawerOpen) {
                drawerKey.currentState!.openEndDrawer();
              } else {
                drawerKey.currentState!.openDrawer();
              }
            },
            icon: Icon(Icons.menu, color: UserColors.primaryColor),
          ),
          optionWidget: Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: UserColors.primaryColor,
                ),
                onPressed: () {
                  if (notificationCount > 0) {
                    Utils.addValueToStorage(
                        "notificationId", appLastNotificationId.toString());
                    Utils.navigateTo(context, const NotificationListScreen());
                  }
                },
              ),
              Visibility(
                visible: notificationCount > 0,
                child: Positioned(
                  top: 2.0,
                  right: 0.0,
                  child: InkWell(
                    onTap: () {
                      if (notificationCount > 0) {
                        Utils.navigateTo(
                            context, const NotificationListScreen());
                      }
                    },
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 8.0),
                      width: double.infinity,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_starBlasting) {
                                _controllerStarBlast.stop();
                                _starBlasting = false;
                              } else {
                                _controllerStarBlast.play();
                                _starBlasting = true;
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipOval(
                                    child: Utils.getAvatarImage(),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      width: 18.0,
                                      height: 18.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isConnected
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          child: Container(),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Session.empName,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                    color: UserColors.primaryColor,
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Text(
                                  Session.designation,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                Session.department,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                Session.operatingLocation,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 4.0,
                          right: 30.0,
                          bottom: 10.0,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.attendance!,
                                    label: "Attendance",
                                    icon: const Icon(
                                      Icons.mobile_friendly_rounded,
                                      color: Colors.orange,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AttendanceScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.leave!,
                                    label: "Leave",
                                    icon: const Icon(
                                      Icons.work_off,
                                      color: Colors.red,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              const LeaveApplicationListScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.outstation!,
                                    label: "Outstation",
                                    icon: const Icon(
                                      Icons.access_alarms_rounded,
                                      color: Colors.blue,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              const LeaveOutstationListScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.approval!,
                                    label: "Approval",
                                    notificationCount:
                                        Session.approvalPendingCount,
                                    icon: const Icon(
                                      Icons.done_all_rounded,
                                      color: Colors.green,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ApprovalScreen()));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 36.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.payslip!,
                                    label: "Payslip",
                                    icon: const Icon(
                                      Icons.payments,
                                      color: Colors.red,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PayslipScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.jobCard!,
                                    label: "Job Card",
                                    icon: const Icon(
                                      Icons.list_rounded,
                                      color: Colors.purple,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const JobCardScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    label: "PF",
                                    icon: const Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: Colors.teal,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProvidentFundScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.holiday!,
                                    label: "Holiday",
                                    icon: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.deepOrange,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HolidayListScreen()));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 36.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.myProfile!,
                                    label: "My Profile",
                                    icon: const Icon(
                                      Icons.verified_user_rounded,
                                      color: Colors.deepOrange,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyProfileScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.policies!,
                                    label: "Policies",
                                    icon: const Icon(
                                      Icons.checklist_rounded,
                                      color: Colors.blue,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () async {
                                      await Utils.wait(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PoliciesScreen()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.canteen!,
                                    label: "e-Canteen 2.0",
                                    isUpdated: true,
                                    icon: const Icon(
                                      Icons.food_bank_rounded,
                                      color: Colors.indigo,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CanteenHomeScreen2()));
                                    },
                                  ),
                                  IconButtonWidget(
                                    isLocked: !Settings.userAccess.directory!,
                                    label: "e-Directory",
                                    icon: const Icon(
                                      Icons.folder_shared_outlined,
                                      color: Colors.teal,
                                      size: 32.0,
                                    ),
                                    color: Colors.white,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DirectoryScreen()));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  CarouselSlider(
                      carouselController: _controller,
                      items: Session.userData.notices!
                          .map((notice) => Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.7),
                                        width: 0.0),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return NoticeViewerScreen(
                                              notice: notice);
                                        }));
                                      },
                                      child: notice.thubnailImage),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: 120,
                        autoPlay: true,
                        //  aspectRatio: 4.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        Session.userData.notices!.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54.withOpacity(
                                  _current == entry.key ? 0.7 : 0.3)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0)
                ],
              ),
              Positioned(
                top: 70.0,
                child: ConfettiWidget(
                  confettiController: _controllerStarBlast,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [
                    Colors.green.shade700,
                    Colors.blue.shade700,
                    Colors.red.shade700,
                    Colors.orange.shade700,
                    Colors.yellow.shade700
                  ],
                  createParticlePath: Utils.drawStar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
