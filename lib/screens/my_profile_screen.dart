import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/my_profile_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      title: "My Profile",
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200.withOpacity(0.3),
        ),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MyProfileTextWidget(
              label: "Employee Code",
              text: Session.empCode,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Name",
              text: Session.empName,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Designation",
              text: Session.designation,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Department",
              text: Session.department,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Company",
              text: Session.userData.userInformation!.companyName!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Operating Location",
              text: Session.operatingLocation,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Attendance Location",
              text: Session.userData.userInformation!.attendanceLocation!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Reporting Manager",
              text: Session.userData.userInformation!.managerName!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Blood Group",
              text: Session.userData.userInformation!.bloodGroup!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Gender",
              text: Session.userData.userInformation!.gender!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Date of Birth",
              text: Utils.formatDate(DateFormat("yyyy-MM-dd")
                  .parse(Session.userData.userInformation!.birthDate!)),
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Date of Joining",
              text: Utils.formatDate(DateFormat("yyyy-MM-dd")
                  .parse(Session.userData.userInformation!.joiningDate!)),
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Date of Confirmation",
              text: Utils.formatDate(DateFormat("yyyy-MM-dd")
                  .parse(Session.userData.userInformation!.confirmationDate!)),
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Father's Name",
              text: Session.userData.userInformation!.fatherName!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Mother's Name",
              text: Session.userData.userInformation!.motherName!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Spouse's Name",
              text: Session.userData.userInformation!.spouseName!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Present Address",
              text: Session.userData.userInformation!.currentAddress!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Permanent Address",
              text: Session.userData.userInformation!.permanentAddress!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Mobile No.",
              text: Session.userData.userInformation!.mobileNo!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "NID/Smart Card",
              text: Session.userData.userInformation!.nid!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Bank A/C",
              text: Session.userData.userInformation!.bankAccountNo!,
            ),
            const SizedBox(height: 6.0),
            MyProfileTextWidget(
              label: "Salary",
              text: Utils.formatPrice(
                  Session.userData.userInformation!.grossSalary!),
            ),
          ]),
        ),
      ),
    ));
  }
}
