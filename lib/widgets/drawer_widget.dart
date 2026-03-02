import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final Function(int) onMenuItemClicked;

  const DrawerWidget({
    Key? key,
    required this.onMenuItemClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            alignment: Alignment.topCenter,
            opacity: 0.6,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Settings.userAccess.transport!)
                          builedDrawerItem(
                              context,
                              "Resetter Tool v1.0",
                              Icon(Icons.folder_open_outlined,
                                  size: 20.0, color: UserColors.primaryColor),
                              1,
                              newFeature: true),

                        if (Settings.userAccess.poll!)
                          builedDrawerItem(
                              context,
                              'e-Poll  ${Settings.ePollVersion}',
                              Icon(Icons.poll_outlined,
                                  size: 20.0, color: UserColors.primaryColor),
                              2,
                              newFeature: false),

                        if (Settings.userAccess.regularization!)
                          builedDrawerItem(
                            context,
                            'Attendance Regularization',
                            Icon(Icons.history_toggle_off,
                                size: 20.0, color: UserColors.primaryColor),
                            13,
                            newFeature: true,
                            labelText: "New",
                          ),

                        if (Settings.userAccess.attendanceMonitor!)
                          builedDrawerItem(
                              context,
                              'e-Attendance Monitor  ${Settings.eAttendanceMonitor}',
                              Icon(Icons.timer_outlined,
                                  size: 20.0, color: UserColors.primaryColor),
                              3,
                              newFeature: false),
                        if (Settings.userAccess.transport!)
                          builedDrawerItem(
                              context,
                              'e-Transport ${Settings.eTransport}',
                              Icon(Icons.train_outlined,
                                  size: 20.0, color: UserColors.primaryColor),
                              10,
                              newFeature: false),
                        if (Settings.userAccess.canteenManager!)
                          builedDrawerItem(
                            context,
                            'e-Canteen Manager ${Settings.eCanteen}',
                            Icon(Icons.food_bank_outlined,
                                size: 20.0, color: UserColors.primaryColor),
                            4,
                            newFeature: true,
                            labelText: "New",
                          ),

                        builedDrawerItem(
                            context,
                            'Profile Update',
                            Icon(Icons.verified_user_outlined,
                                size: 20.0, color: UserColors.primaryColor),
                            5,
                            newFeature: false),

                        if (Settings.userAccess.notification!)
                          builedDrawerItem(
                            context,
                            'Notifications',
                            Icon(Icons.notifications_active_outlined,
                                size: 20.0, color: UserColors.primaryColor),
                            6,
                          ),

                        if (Settings.userAccess.notice!)
                          builedDrawerItem(
                            context,
                            'Notice',
                            Icon(Icons.message_outlined,
                                size: 20.0, color: UserColors.primaryColor),
                            7,
                          ),

                        if (Settings.userAccess.busLate!)
                          builedDrawerItem(
                            context,
                            'Bus Late 1.0',
                            Icon(Icons.bus_alert_outlined,
                                size: 20.0, color: UserColors.primaryColor),
                            12,
                            newFeature: true,
                            labelText: "New",
                          ),

                        if (Settings.userAccess.controlPanel!)
                          builedDrawerItem(
                              context,
                              'Control Panel',
                              Icon(Icons.settings,
                                  size: 20.0, color: UserColors.primaryColor),
                              8,
                              newFeature: false),

                        builedDrawerItem(
                            context,
                            'About App',
                            Icon(Icons.info_outline,
                                size: 20.0, color: UserColors.primaryColor),
                            9,
                            showBottomBorder: false),

                        // Divider(
                        //   height: 1,
                        //   color: UserColors.primaryColor.withOpacity(0.2),
                        // ),
                        // builedDrawerItem(
                        //   context,
                        //   'Device Info',
                        //   Icon(Icons.device_unknown_outlined,
                        //       size: 20.0, color: UserColors.primaryColor),
                        //   10,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextButton(
                    onPressed: () => onMenuItemClicked(0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            size: 20.0,
                            color: UserColors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: UserColors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                InkWell(
                  onTap: () => onMenuItemClicked(11),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 8.0),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 16.0,
                          color: UserColors.primaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Change Password?",
                            style: TextStyle(
                                color: UserColors.primaryColor, fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, String user) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/images/"),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              radius: 24,
              backgroundColor: UserColors.primaryColor,
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builedDrawerItem(
      BuildContext context, String text, Widget icon, int menuItemIndex,
      {bool newFeature = false,
      bool updated = false,
      String? labelText,
      bool showBottomBorder = true}) {
    var color = Colors.transparent;
    var badgeText = "";
    if (newFeature) {
      color = UserColors.red;
      badgeText = labelText ?? "New";
    } else {
      color = UserColors.green;
      badgeText = labelText ?? "Updated";
    }

    return SizedBox(
      height: 42.0,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero), // Remove padding
        ),
        onPressed: () => onMenuItemClicked(menuItemIndex),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 12.0),
                  child: icon,
                ),
                Text(text)
              ],
            ),
            if (newFeature || updated)
              Positioned(
                top: 0,
                right: 8.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(color: Colors.white, fontSize: 10.0),
                  ),
                ),
              ),
            if (showBottomBorder)
              Positioned(
                bottom: -10.0,
                left: 0,
                right: 0,
                child: Divider(
                  height: 1,
                  color: UserColors.primaryColor.withOpacity(0.1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
