import 'package:peoplepro/screens/attendance_location_screen.dart';
import 'package:peoplepro/screens/attendance_location_zone_screen.dart';
import 'package:peoplepro/screens/cache_manager_screen.dart';
import 'package:peoplepro/screens/hub_users_screen.dart';
import 'package:peoplepro/screens/login_tester_screen.dart';
import 'package:peoplepro/screens/notification_screen.dart';
import 'package:peoplepro/screens/user_access_screen.dart';
import 'package:peoplepro/screens/user_app_update_screen.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({Key? key}) : super(key: key);

  @override
  State<ControlPanelScreen> createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "Control Panel",
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                if (Settings.userAccess.zoneManager!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.place_outlined,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("Zone Manager")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const AttendanceLocationZoneScreen()));
                      },
                    ),
                  ),
                if (Settings.userAccess.locationManager!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.location_searching,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("Location Manager")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const AttendanceLocationScreen()));
                      },
                    ),
                  ),
                if (Settings.userAccess.notifier!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.notifications,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("Notification Manager")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                      },
                    ),
                  ),
                if (Session.empCode == "047785")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.supervised_user_circle_outlined,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("Hub User")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HubUsersScreen()));
                      },
                    ),
                  ),
                if (Session.empCode == "047785")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.cached,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("Cache Manager")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CacheManagerScreen()));
                      },
                    ),
                  ),
                if (Session.empCode == "047785")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.login,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("Login Tester")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginTesterScreen()));
                      },
                    ),
                  ),
                if (Session.empCode == "047785")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.done_all,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("User Access")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserAccessScreen()));
                      },
                    ),
                  ),
                if (Session.empCode == "047785")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                4.0,
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          child: Row(children: [
                            Icon(
                              Icons.update,
                              color: UserColors.primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Text("User App Updated")
                          ])),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const UserAppUpdatedScreen()));
                      },
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
