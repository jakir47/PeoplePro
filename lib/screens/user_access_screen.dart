import 'package:peoplepro/models/user_access_model.dart';
import 'package:peoplepro/models/user_access_view_model.dart';
import 'package:peoplepro/services/hive_service.dart';
import 'package:peoplepro/services/security_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/checkbox_widget.dart';
import 'package:peoplepro/widgets/dropdown_button_widget.dart';
import 'package:flutter/material.dart';

class UserAccessScreen extends StatefulWidget {
  final String? empCode;
  const UserAccessScreen({Key? key, this.empCode}) : super(key: key);

  @override
  State<UserAccessScreen> createState() => _UserAccessScreenState();
}

class _UserAccessScreenState extends State<UserAccessScreen> {
  final ctrlCode = TextEditingController();
  final _focusNode = FocusNode();
  UserAccessViewModel? _userAccess = UserAccessViewModel();

  List<DropdownItem> _editions = [];
  String _selectedEditionId = "3";

  @override
  void initState() {
    super.initState();
    loadEditions();
    if (widget.empCode != null) {
      loadNavigated(widget.empCode!);
    }
  }

  void loadEditions() async {
    _editions = await HiveService.getEditions().then((data) {
      return data
          .map((e) => DropdownItem(e.name!, e.editionId.toString()))
          .toList();
    });

    setState(() {});
  }

  Future<void> loadNavigated(String empCode) async {
    ctrlCode.text = empCode;
    _userAccess = await SecurityService.getUserAccess(empCode);
    _selectedEditionId = _userAccess!.editionId.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "User Access",
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: ctrlCode,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outlined),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.indigo),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.indigo),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffix: ctrlCode.text.length == 6
                            ? TextButton(
                                child: const Text("Get"),
                                onPressed: () async {
                                  var empCode = ctrlCode.text;
                                  _userAccess =
                                      await SecurityService.getUserAccess(
                                          empCode);
                                  _focusNode.unfocus();
                                  _selectedEditionId =
                                      _userAccess!.editionId.toString();
                                  setState(() {});
                                },
                              )
                            : null),
                    onChanged: (txt) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 90, child: Text("Code")),
                    Text(
                      _userAccess!.userId ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const SizedBox(width: 90, child: Text("Name")),
                    Text(
                      _userAccess!.name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const SizedBox(width: 90, child: Text("Designation")),
                    Text(
                      _userAccess!.designation ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const SizedBox(width: 90, child: Text("Department")),
                    Text(
                      _userAccess!.department ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: () async {
                    var userId = ctrlCode.text;
                    if (userId.isEmpty) return;
                    var removed = await SecurityService.removeDevice(userId);
                    if (removed) {
                      MessageBox.success(
                          context, "Success", "Device removed successfully.");
                    } else {
                      MessageBox.error(
                          context, "Error", "Unable to remove device.");
                    }
                  },
                  icon: Icon(
                    Icons.device_unknown,
                    color: UserColors.primaryColor,
                  ),
                  label: Text(
                    "Remove Device",
                    style: TextStyle(fontSize: 12, color: UserColors.red),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(children: [
                    Text(
                      "Edition",
                      style: TextStyle(
                        fontSize: 16,
                        color: UserColors.primaryColor,
                      ),
                    ),
                    const Divider(),
                    DropdownButtonWidget(
                      hint: '',
                      items: _editions,
                      borderColor: UserColors.primaryColor,
                      selectedValue: _selectedEditionId,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 14),
                      selectedValueChanged: (value) async {
                        _userAccess!.editionId = int.parse(value);
                        _selectedEditionId = _userAccess!.editionId.toString();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    CheckboxWidget(
                        label: "User Access Enabled",
                        value: _userAccess!.isActive!,
                        checkedChanged: (value) {
                          _userAccess!.isActive = value;
                          setState(() {});
                        }),
                    Text(
                      "Apps",
                      style: TextStyle(
                        fontSize: 16,
                        color: UserColors.primaryColor,
                      ),
                    ),
                    const Divider(),
                    CheckboxWidget(
                        label: "e-Directory",
                        value: _userAccess!.directory!,
                        checkedChanged: (value) {
                          _userAccess!.directory = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "e-Poll",
                        value: _userAccess!.poll!,
                        checkedChanged: (value) {
                          _userAccess!.poll = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "e-Attendance Monitor",
                        value: _userAccess!.attendanceMonitor,
                        checkedChanged: (value) {
                          _userAccess!.attendanceMonitor = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "e-Canteen",
                        value: _userAccess!.canteen!,
                        checkedChanged: (value) {
                          _userAccess!.canteen = value;
                          setState(() {});
                        }),
                    const SizedBox(height: 20),
                    Text(
                      "Special Access",
                      style: TextStyle(
                        fontSize: 16,
                        color: UserColors.primaryColor,
                      ),
                    ),
                    const Divider(),
                    CheckboxWidget(
                        label: "Control Panel",
                        value: _userAccess!.controlPanel!,
                        checkedChanged: (value) {
                          _userAccess!.controlPanel = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Zone Manager",
                        value: _userAccess!.zoneManager!,
                        checkedChanged: (value) {
                          _userAccess!.zoneManager = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Location Manager",
                        value: _userAccess!.locationManager!,
                        checkedChanged: (value) {
                          _userAccess!.locationManager = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Notification Manager",
                        value: _userAccess!.notifier!,
                        checkedChanged: (value) {
                          _userAccess!.notifier = value;
                          setState(() {});
                        }),
                    const SizedBox(height: 20),
                    Text(
                      "Extras",
                      style: TextStyle(
                        fontSize: 16,
                        color: UserColors.primaryColor,
                      ),
                    ),
                    const Divider(),
                    CheckboxWidget(
                        label: "Prfile Update",
                        value: _userAccess!.updateProfile!,
                        checkedChanged: (value) {
                          _userAccess!.updateProfile = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Notice",
                        value: _userAccess!.notice!,
                        checkedChanged: (value) {
                          _userAccess!.notice = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Notification",
                        value: _userAccess!.notification!,
                        checkedChanged: (value) {
                          _userAccess!.notification = value;
                          setState(() {});
                        }),
                    const SizedBox(height: 20),
                    Text(
                      "Features",
                      style: TextStyle(
                        fontSize: 16,
                        color: UserColors.primaryColor,
                      ),
                    ),
                    const Divider(),
                    CheckboxWidget(
                        label: "Attendance",
                        value: _userAccess!.attendance,
                        checkedChanged: (value) {
                          _userAccess!.attendance = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Leave",
                        value: _userAccess!.leave,
                        checkedChanged: (value) {
                          _userAccess!.leave = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Outstation",
                        value: _userAccess!.outstation,
                        checkedChanged: (value) {
                          _userAccess!.outstation = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Approval",
                        value: _userAccess!.approval,
                        checkedChanged: (value) {
                          _userAccess!.approval = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Payslip",
                        value: _userAccess!.payslip,
                        checkedChanged: (value) {
                          _userAccess!.payslip = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Job Card",
                        value: _userAccess!.jobCard,
                        checkedChanged: (value) {
                          _userAccess!.jobCard = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Holiday",
                        value: _userAccess!.holiday,
                        checkedChanged: (value) {
                          _userAccess!.holiday = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Job History",
                        value: _userAccess!.jobHistory,
                        checkedChanged: (value) {
                          _userAccess!.jobHistory = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Hiring",
                        value: _userAccess!.hiring,
                        checkedChanged: (value) {
                          _userAccess!.hiring = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Provident Fund",
                        value: _userAccess!.providentFund,
                        checkedChanged: (value) {
                          _userAccess!.providentFund = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "My Profile",
                        value: _userAccess!.myProfile,
                        checkedChanged: (value) {
                          _userAccess!.myProfile = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Policies",
                        value: _userAccess!.policies,
                        checkedChanged: (value) {
                          _userAccess!.policies = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Update Profile",
                        value: _userAccess!.updateProfile,
                        checkedChanged: (value) {
                          _userAccess!.updateProfile = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Canteen Manager",
                        value: _userAccess!.canteenManager,
                        checkedChanged: (value) {
                          _userAccess!.canteenManager = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Print Token",
                        value: _userAccess!.printToken,
                        checkedChanged: (value) {
                          _userAccess!.printToken = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Job Card Download",
                        value: _userAccess!.jobCardDownload,
                        checkedChanged: (value) {
                          _userAccess!.jobCardDownload = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Regularization",
                        value: _userAccess!.regularization,
                        checkedChanged: (value) {
                          _userAccess!.regularization = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Bus Late",
                        value: _userAccess!.busLate,
                        checkedChanged: (value) {
                          _userAccess!.busLate = value;
                          setState(() {});
                        }),
                    CheckboxWidget(
                        label: "Debug",
                        value: _userAccess!.debug,
                        checkedChanged: (value) {
                          _userAccess!.debug = value;
                          setState(() {});
                        }),
                  ]),
                )),
                const SizedBox(height: 6.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      var access = UserAccessModel();
                      access.userId = _userAccess!.userId;
                      access.editionId = _userAccess!.editionId;
                      access.edition = _userAccess!.edition;
                      access.isActive = _userAccess!.isActive;
                      access.controlPanel = _userAccess!.controlPanel;
                      access.notifier = _userAccess!.notifier;
                      access.zoneManager = _userAccess!.zoneManager;
                      access.locationManager = _userAccess!.locationManager;
                      access.attendanceMonitor = _userAccess!.attendanceMonitor;
                      access.poll = _userAccess!.poll;
                      access.directory = _userAccess!.directory;
                      access.canteen = _userAccess!.canteen;
                      access.transport = _userAccess!.transport;
                      access.notification = _userAccess!.notification;
                      access.notice = _userAccess!.notice;
                      access.attendance = _userAccess!.attendance;
                      access.leave = _userAccess!.leave;
                      access.outstation = _userAccess!.outstation;
                      access.approval = _userAccess!.approval;
                      access.payslip = _userAccess!.payslip;
                      access.jobCard = _userAccess!.jobCard;
                      access.holiday = _userAccess!.holiday;
                      access.jobHistory = _userAccess!.jobHistory;
                      access.hiring = _userAccess!.hiring;
                      access.providentFund = _userAccess!.providentFund;
                      access.myProfile = _userAccess!.myProfile;
                      access.policies = _userAccess!.policies;
                      access.updateProfile = _userAccess!.updateProfile;
                      access.canteenManager = _userAccess!.canteenManager;
                      access.printToken = _userAccess!.printToken;
                      access.jobCardDownload = _userAccess!.jobCardDownload;
                      access.regularization = _userAccess!.regularization;
                      access.busLate = _userAccess!.busLate;
                      access.timeout = 0;
                      access.debug = _userAccess!.debug;

                      var success =
                          await SecurityService.updateUserAccess(access);
                      if (success) {
                        MessageBox.success(
                            context, "Update Access", "User access updated.");
                      } else {
                        MessageBox.error(context, "Update Access",
                            "Oops! something went wrong!");
                      }
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
                      'Update Access',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
