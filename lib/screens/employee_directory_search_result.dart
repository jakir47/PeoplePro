import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:peoplepro/models/employee_directory_model.dart';
import 'package:peoplepro/screens/user_access_screen.dart';
import 'package:peoplepro/services/directory_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDirectorySearchResultScreen extends StatefulWidget {
  final String searchText;
  final String searchType;
  const EmployeeDirectorySearchResultScreen({
    required this.searchText,
    required this.searchType,
    super.key,
  });

  @override
  State<EmployeeDirectorySearchResultScreen> createState() =>
      _EmployeeDirectorySearchResultScreenState();
}

class _EmployeeDirectorySearchResultScreenState
    extends State<EmployeeDirectorySearchResultScreen> {
  final ScrollController _scrollController = ScrollController();
  List<EmployeeDirectoryModel> items = [];
  bool loading = false;
  bool allLoaded = false;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        search();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => search());
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> search() async {
    if (allLoaded) {
      return;
    }
    loading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);

    var offset = (currentPage - 1) * 25;
    var newData = await DirectoryService.search(
        widget.searchText, widget.searchType, offset);
    currentPage++;

    if (newData.isNotEmpty) {
      items.addAll(newData);
    }

    Utils.hideLoadingIndicator(context);
    loading = false;
    allLoaded = newData.isEmpty;
    setState(() {});
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendMail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    }
  }

  Widget getExpLevel(int expLevel) {
    List<Icon> stars = [];

    for (var i = 0; i < expLevel; i++) {
      stars.add(Icon(
        Icons.star,
        size: 12.0,
        color: Colors.yellow.shade900,
      ));
    }

    return Row(children: stars.map((e) => e).toList());
  }

  Widget employeeInfoWidget(EmployeeDirectoryModel employee, bool isModal) {
    Image image;
    var photo = employee.photo!;
    if (photo.isEmpty) {
      image = Image.asset("assets/images/avatar.jpg");
    } else {
      var img = const Base64Decoder().convert(photo);
      image = Image.memory(
        img,
        fit: BoxFit.cover,
        scale: 2.0,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 72.0,
                  height: 72.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: image,
                  ),
                ),
                const SizedBox(height: 2.0),
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: employee.isActive!
                          ? UserColors.primaryColor
                          : Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      employee.isActive!
                          ? Icons.check_outlined
                          : Icons.remove_circle_outline,
                      color: Colors.white,
                      size: 12.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -14,
                  child: getExpLevel(employee.expLevel!),
                ),
              ],
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name!,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 2.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color: UserColors.primaryColor,
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Text(
                    employee.designation!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  employee.section!,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: UserColors.primaryColor,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  employee.department!,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  employee.location!,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget dataLineWidget(String label, String text,
      {IconData? iconData, Function()? onLabelTap}) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          color: UserColors.primaryColor, fontSize: 14.0),
                    ),
                  ],
                )),
            Expanded(
              child: InkWell(
                onTap: () {
                  FlutterClipboard.copy(text)
                      .then((value) => Utils.showToast("$label copied"));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 2.0),
                  child: Text(text, style: const TextStyle(fontSize: 14.0)),
                ),
              ),
            ),
            if (iconData != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: onLabelTap,
                  child: Icon(
                    iconData,
                    color: UserColors.primaryColor,
                    size: 20.0,
                  ),
                ),
              ),
          ],
        ));
  }

  void showOtherInfo(EmployeeDirectoryModel employee) {
    var lastDate =
        employee.isActive! ? Settings.serverToday : employee.inActiveFrom!;

    var duration = Utils.calculateDuration(employee.joiningDate!, lastDate);
    var durationText = "";
    if (duration.year! > 0) {
      durationText +=
          ("${duration.year}${duration.year! == 1 ? " year" : " years"}");
    }
    if (duration.month! > 0) {
      durationText += durationText.isNotEmpty ? ", " : "";
      durationText +=
          ("${duration.month}${duration.month! == 1 ? " month" : " months"}");
    }
    if (duration.day! > 0) {
      durationText += durationText.isNotEmpty ? ", " : "";
      durationText +=
          ("${duration.day}${duration.day! == 1 ? " day" : " days"}");
    }

    showModal(
        configuration: const FadeScaleTransitionConfiguration(
            transitionDuration: Duration(milliseconds: 300),
            reverseTransitionDuration: Duration(milliseconds: 200),
            barrierDismissible: false),
        context: context,
        builder: (context) => Dialog(
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    opacity: 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                        onTap: () {
                          if (Session.empCode == '047785') {
                            var route = MaterialPageRoute(
                                builder: (ctx) => UserAccessScreen(
                                    empCode: employee.empCode));
                            Navigator.push(context, route);
                          }
                        },
                        child: employeeInfoWidget(employee, true)),
                    const SizedBox(height: 6.0),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                    //   child: Divider(
                    //     height: 1,
                    //     color: Colors.blue.shade100,
                    //   ),
                    // ),
                    Expanded(
                      child: ListView(
                        children: [
                          if (Settings.editionId == 1)
                            const SizedBox(height: 8.0),
                          if (Settings.editionId == 1)
                            dataLineWidget(
                              employee.isActive! ? "Serving" : "Served",
                              durationText,
                            ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "ID",
                            employee.empCode!,
                          ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "IPX",
                            employee.ipx!,
                          ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "Email",
                            employee.email!,
                            iconData: Icons.email_outlined,
                            onLabelTap: () {
                              _sendMail(employee.email!);
                            },
                          ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "Mobile",
                            employee.mobileNo!,
                            iconData: Icons.call_outlined,
                            onLabelTap: () {
                              _makePhoneCall(employee.mobileNo!);
                            },
                          ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "Emergency",
                            employee.emergencyContact!,
                            iconData: Icons.call_outlined,
                            onLabelTap: () {
                              _makePhoneCall(employee.emergencyContact!);
                            },
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: dataLineWidget(
                                  "Blood Group",
                                  employee.bloodGroup!,
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: dataLineWidget("Donate Blood?",
                                    employee.isBloodDonor! ? "Yes" : "No"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "Religion",
                            employee.religion!,
                          ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "Gender",
                            employee.gender!,
                          ),
                          const SizedBox(height: 4.0),
                          dataLineWidget(
                            "Marital Status",
                            employee.maritalStatus!,
                          ),
                          if (Settings.editionId == 1)
                            const SizedBox(height: 4.0),
                          if (Settings.editionId == 1)
                            dataLineWidget(
                              "Father's Name",
                              employee.fatherName!,
                            ),
                          if (Settings.editionId == 1)
                            const SizedBox(height: 4.0),
                          if (Settings.editionId == 1)
                            dataLineWidget(
                              "Mother's Name",
                              employee.motherName!,
                            ),
                          if (Settings.editionId == 1)
                            const SizedBox(height: 4.0),
                          if (Settings.editionId == 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          "Present Address",
                                          style: TextStyle(
                                              color: UserColors.primaryColor,
                                              fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                        text: employee.presentAddress!,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87)),
                                  ],
                                ),
                              ),
                            ),
                          if (Settings.editionId == 1)
                            const SizedBox(height: 4.0),
                          if (Settings.editionId == 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6.0),
                                        child: Text(
                                          "Permanent Address",
                                          style: TextStyle(
                                              color: UserColors.primaryColor,
                                              fontSize: 14.0),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                        text: employee.permanentAddress!,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: UserColors.primaryColor),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 0.0),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "e-Directory: Search Results",
        child: LayoutBuilder(builder: (context, constraints) {
          return ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index < items.length) {
                  var employee = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6.0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: GestureDetector(
                          onTap: () {
                            showOtherInfo(employee);
                          },
                          child: Container(
                              color: Colors.transparent,
                              child: employeeInfoWidget(employee, false))),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: 50,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: const Text(
                          "No more data to load!",
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 4.0);
              },
              itemCount: items.length + (allLoaded ? 1 : 0));
        }),
      ),
    );
  }
}
