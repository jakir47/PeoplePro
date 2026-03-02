import 'package:peoplepro/screens/employee_directory_search_result.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
      title: "About App",
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12.0),
                  // SvgPicture.asset(
                  //   'assets/images/logo.svg',
                  //   color: UserColors.primaryColor,
                  //   height: 100,
                  //   width: 100,
                  // ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/bgi3d.png',
                        width: 100,
                        height: 100,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "People",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                          children: [
                            TextSpan(
                                text: "Pro",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: UserColors.primaryColor,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  // const Text(
                  //   "BGI HRIS",
                  //   style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black87),
                  // ),
                  // const SizedBox(height: 2.0),
                  Text(
                    "Version ${Settings.appVersion}",
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.black87.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    "PeoplePro: HR app for businesses. Manage attendance, job cards, payslips, employee data, payroll, benefits, compliance, and performance. Streamline HR with reporting tools and analytics.",
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.black87.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 36.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const EmployeeDirectorySearchResultScreen(
                                  searchText: "072171",
                                  searchType: "EmpCode")));
                    },
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: UserColors.primaryColor),
                                borderRadius: BorderRadius.circular(4),
                                color: UserColors.primaryColor),
                            child: const Text(
                              "PROJECT CHAMPION",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                        const SizedBox(height: 4.0),
                        Text(Settings.manufacturer == "Apple"
                            ? "Muntasir Shajib"
                            : "Mirza Md. Borhan Kabir"),
                        const SizedBox(height: 2.0),
                        Text("General Manager",
                            style: TextStyle(
                                color: UserColors.primaryColor, fontSize: 13)),
                        const SizedBox(height: 2.0),
                        Text("Information Technology",
                            style: TextStyle(
                                color: Colors.black87.withOpacity(0.9),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const EmployeeDirectorySearchResultScreen(
                                  searchText: "047785",
                                  searchType: "EmpCode")));
                    },
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: UserColors.primaryColor),
                                borderRadius: BorderRadius.circular(4),
                                color: UserColors.primaryColor),
                            child: const Text(
                              "DEVELOPED BY",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                        const SizedBox(height: 4.0),
                        const Text("Md. Jakir Hossain"),
                        const SizedBox(height: 2.0),
                        Text("Team Lead (Software Development)",
                            style: TextStyle(
                                color: UserColors.primaryColor, fontSize: 13)),
                        const SizedBox(height: 2.0),
                        Text("Information Technology",
                            style: TextStyle(
                                color: Colors.black87.withOpacity(0.9),
                                fontSize: 12)),
                      ],
                    ),
                  )

                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8.0),
                  //   child: Divider(height: 1, color: Colors.black12),
                  // ),
                  // Expanded(
                  //     child: SingleChildScrollView(
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 6, vertical: 1),
                  //           decoration: BoxDecoration(
                  //               border: Border.all(
                  //                   color: UserColors.primaryColor),
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: UserColors.primaryColor),
                  //           child: const Text(
                  //             "PROJECT ASSOCIATES",
                  //             style: TextStyle(
                  //                 color: Colors.white, fontSize: 11),
                  //           )),
                  //       const SizedBox(height: 4.0),
                  //       const Text("Md. Kazi Anwar Hossain"),
                  //       const SizedBox(height: 2.0),
                  //       Text("Assistant General Manager",
                  //           style: TextStyle(
                  //               color: Colors.black87.withOpacity(0.7),
                  //               fontSize: 12)),
                  //       const SizedBox(height: 2.0),
                  //       Text("Information Technology",
                  //           style: TextStyle(
                  //               color: Colors.black87.withOpacity(0.7),
                  //               fontSize: 12)),
                  //       const SizedBox(height: 16.0),
                  //       Column(
                  //         children: [
                  //           const Text("Md. Aminul Islam Chowdhury"),
                  //           const SizedBox(height: 2.0),
                  //           Text("Manager",
                  //               style: TextStyle(
                  //                   color: Colors.black87.withOpacity(0.7),
                  //                   fontSize: 12)),
                  //           const SizedBox(height: 2.0),
                  //           Text("Information Technology",
                  //               style: TextStyle(
                  //                   color: Colors.black87.withOpacity(0.7),
                  //                   fontSize: 12)),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 16.0),
                  //       Column(
                  //         children: [
                  //           const Text("Mst. Sohel Saedatun Easmin"),
                  //           const SizedBox(height: 2.0),
                  //           Text("Deputy Manager",
                  //               style: TextStyle(
                  //                   color: Colors.black87.withOpacity(0.7),
                  //                   fontSize: 12)),
                  //           const SizedBox(height: 2.0),
                  //           Text("HRD",
                  //               style: TextStyle(
                  //                   color: Colors.black87.withOpacity(0.7),
                  //                   fontSize: 12)),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
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
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
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
            ),
          ),
        ],
      ),
    ));
  }
}
