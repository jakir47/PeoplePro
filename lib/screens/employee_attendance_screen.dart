import 'package:peoplepro/models/employee_attendance_model.dart';
import 'package:peoplepro/screens/employee_directory_search_result.dart';
import 'package:peoplepro/services/hive_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/date_field_widget.dart';
import 'package:peoplepro/widgets/dropdown_button_widget.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  List<EmployeeAttendanceModel> _attendances = [];

  List<DropdownItem> _departments = [];
  String? _selectedDepartmentId = "95b391d9-ec33-9f1f-6d2d-965ddb828c8d";
  final ctrlDate =
      TextEditingController(text: Utils.formatDate(Settings.serverToday));
  DateTime? _selectedDate = Settings.serverToday;
  @override
  void initState() {
    super.initState();
    loadDepartments();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  loadDepartments() async {
    var data = await HiveService.getdepartments();
    _departments =
        data.map((l) => DropdownItem(l.name!, l.departmentId!)).toList();
    setState(() {});
  }

  void loadData() async {
    Utils.showLoadingIndicator(context);

    if (Settings.editionId == 2) {
      _selectedDepartmentId = Session.userData.userInformation!.departmentId!;
    }

    var entryDate =
        ('${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}');
    _attendances = await HiveService.getEmployeeAttendances(
        _selectedDepartmentId!, entryDate);
    setState(() {});
    Utils.hideLoadingIndicator(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "e-Attendance Monitor",
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (Settings.editionId == 1 && Session.empCode == "047785")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonWidget(
                      hint: '',
                      items: _departments,
                      borderColor: UserColors.primaryColor,
                      selectedValue: _selectedDepartmentId,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 14),
                      selectedValueChanged: (value) async {
                        _selectedDepartmentId = value;
                        setState(() {});
                        loadData();
                      },
                    ),
                  ),
                const SizedBox(height: 4.0),
                if (Settings.editionId == 1 && Session.empCode == "047785")
                  DateFieldWidget(
                    controller: ctrlDate,
                    onChanged: (DateTime? date) {
                      _selectedDate = date;
                      setState(() {});
                      loadData();
                    },
                  ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        var attendanceLine = _attendances[index];

                        Image image;

                        image = Image.asset("assets/images/avatar.jpg");

                        // var photo = user.photo;

                        // if (photo.isEmpty) {
                        //   image = Image.asset("assets/images/avatar.jpg");
                        // } else {
                        //   var img = const Base64Decoder().convert(photo);
                        //   image = Image.memory(
                        //     img,
                        //     fit: BoxFit.cover,
                        //     scale: 1.0,
                        //   );
                        // }

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadiusDirectional.circular(4.0)),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            horizontalTitleGap: 8.0,
                            leading: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                SizedBox(
                                  width: 60.0,
                                  height: 60.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: image,
                                  ),
                                ),
                                Positioned(
                                    bottom: -5,
                                    right: -5,
                                    child: Container(
                                      width: 16.0,
                                      height: 16.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: attendanceLine.isPresent!
                                                  ? Colors.green
                                                  : Colors.red),
                                          child: Container(),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                  bottom: -20,
                                  child: Text(
                                    attendanceLine.empCode!,
                                    style: TextStyle(
                                      color: UserColors.primaryColor,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                if (attendanceLine.isPresent!)
                                  Positioned(
                                    bottom: 13,
                                    right: -5,
                                    child: Icon(
                                      attendanceLine.attendSource! ==
                                              "Mobile App"
                                          ? Icons.mobile_screen_share
                                          : Icons.fingerprint,
                                      color: UserColors.primaryColor,
                                      size: 18,
                                    ),
                                  )
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attendanceLine.name!,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 2.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 0.0),
                                  decoration: BoxDecoration(
                                      color: UserColors.primaryColor,
                                      borderRadius: BorderRadius.circular(4.0)),
                                  child: Text(
                                    attendanceLine.designation!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  attendanceLine.department!,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  attendanceLine.location!,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13.0,
                                  ),
                                ),
                                if (attendanceLine.isPresent!)
                                  Row(
                                    children: [
                                      const Text(
                                        "Entry time: ",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        attendanceLine.entryTime!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: attendanceLine.isLate!
                                                ? Colors.orange.shade800
                                                : Colors.green.shade800),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeDirectorySearchResultScreen(
                                          searchText: attendanceLine.empCode!,
                                          searchType: "EmpCode")));
                            },
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                          child: SizedBox(),
                        );
                      },
                      itemCount: _attendances.length),
                ),
                Container(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        generateBlock(
                            "Total", _attendances.length, Colors.black54),
                        generateBlock(
                            "Present",
                            _attendances
                                .where((item) => item.isPresent!)
                                .length,
                            Colors.green),
                        generateBlock(
                            "Absent",
                            _attendances
                                .where((item) => item.isPresent == false)
                                .length,
                            Colors.red)
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  generateBlock(String title, int count, Color color) {
    return Container(
      width: 105.0,
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
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              )),
          Container(
            width: 40,
            padding: const EdgeInsets.only(left: 6.0),
            child:
                Text(count.toString(), style: const TextStyle(fontSize: 14.0)),
          ),
        ],
      ),
    );
  }
}
