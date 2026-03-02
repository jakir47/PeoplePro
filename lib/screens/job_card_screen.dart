import 'dart:ui';
import 'package:peoplepro/models/jobcard_model.dart';
import 'package:peoplepro/services/attendance_service.dart';
import 'package:peoplepro/services/download_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/report_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class JobCardScreen extends StatefulWidget {
  const JobCardScreen({Key? key}) : super(key: key);

  @override
  State<JobCardScreen> createState() => _JobCardScreenState();
}

class _JobCardScreenState extends State<JobCardScreen> {
  List<JobCardModel> _jobCardItems = [];
  bool isLoading = true;

  DateTime? _fromDate = Settings.serverToday;
  DateTime? _toDate = Settings.serverToday;
  final ctrlFromDate = TextEditingController();
  final ctrlToDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrlFromDate.text = Utils.formatDate(_fromDate!);
    ctrlToDate.text = Utils.formatDate(_toDate!);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadJobCards());
  }

  Future<void> loadJobCards() async {
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    await Future.delayed(const Duration(seconds: 1), () async {
      var fromDate = Utils.formatDate(_fromDate!, format: "yyyy-MM-dd");
      var toDate = Utils.formatDate(_toDate!, format: "yyyy-MM-dd");
      _jobCardItems = await AttendanceService.getJobCard(fromDate, toDate);
    });

    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  Color getStatusColor(String inputText) {
    Color output = Colors.transparent;

    switch (inputText) {
      case "LI":
        output = Colors.orange;
        break;
      case "P":
        output = Colors.green;
        break;
      case "W":
        output = Colors.teal;
        break;
      case "LV":
        output = Colors.indigo;
        break;
      case "A":
        output = Colors.red;
        break;
      case "OS":
        output = Colors.blue;
        break;
      case "H":
        output = UserColors.primaryColor;
        break;
      case "WP":
        output = Colors.blueGrey.shade600;
        break;
      default:
        output = Colors.teal.shade800;
        break;
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {
    int totalCount = _jobCardItems.length;
    int leaveCount = 0;
    int presentCount = 0;
    int lateCount = 0;
    int absentCount = 0;
    int weekendCount = 0;
    double otHrCount = 0;
    int holidayCount = 0;
    int osCount = 0;

    for (JobCardModel item in _jobCardItems) {
      if (item.status == "P") {
        presentCount++;
      } else if (item.status == "A") {
        absentCount++;
      } else if (item.status == "LI") {
        lateCount++;
      } else if (item.status == "LV") {
        leaveCount++;
      } else if (item.status == "H") {
        holidayCount++;
      } else if (item.status == "OS") {
        osCount++;
      }

      if (item.status == "W") {
        weekendCount++;
      }
      otHrCount += item.overTimeHours!;

      if (item.status!.isEmpty) {
        item.status = "?";
      }
    }

    return Scaffold(
      body: BackgroundWidget(
        title: "Job Card",
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReportDatePicker(onDateChanged: (data) {
                _fromDate = data.startDate;
                _toDate = data.endDate;
                loadJobCards();
                setState(() {});
              }),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _jobCardItems.length,
                itemBuilder: (context, index) {
                  return ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.white.withOpacity(0.6),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 2.0),
                                            decoration: BoxDecoration(
                                                color: UserColors.primaryColor,
                                                borderRadius: const BorderRadius
                                                    .only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft:
                                                        Radius.circular(4))),
                                            child: Text(
                                              Utils.formatDate(
                                                  _jobCardItems[index].date!,
                                                  format: "dd/MM/yyyy"),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 2.0),
                                          child: Text(_jobCardItems[index].day!,
                                              style: const TextStyle(
                                                  fontSize: 14.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 34.0,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                        color: getStatusColor(
                                            _jobCardItems[index].status!),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Text(
                                      _jobCardItems[index].status!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 16.0,
                                        color: UserColors.primaryColor,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          'Entry',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: UserColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _jobCardItems[index].inTime!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer_outlined,
                                        size: 16.0,
                                        color: UserColors.primaryColor,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          'Exit',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: UserColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          _jobCardItems[index].outTime!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.bus_alert_outlined,
                                        size: 16.0,
                                        color: Colors.orange,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          'Late',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${_jobCardItems[index].lateMinutes} min',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.work_history_outlined,
                                        size: 16.0,
                                        color: Colors.red,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          'Overtime',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.pink.shade800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${_jobCardItems[index].overTimeHours} hr',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Remarks: ${_jobCardItems[index].remarks}',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.white.withOpacity(0.8),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      generateBlock("Total", totalCount, Colors.black54),
                      generateBlock("Present", presentCount, Colors.green),
                      generateBlock("Absent", absentCount, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 1.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      generateBlock("Leave", leaveCount, Colors.indigo),
                      generateBlock("Late", lateCount, Colors.orange),
                      generateBlock(
                          "Holidays", holidayCount, UserColors.primaryColor),
                    ],
                  ),
                  const SizedBox(height: 1.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      generateBlock("Weekend", weekendCount, Colors.teal),
                      generateBlock("Outstation", osCount, Colors.blue),
                      generateBlock(
                          "Overtime", otHrCount, Colors.pink.shade800),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  if (Settings.userAccess.jobCardDownload!)
                    TextButton.icon(
                        onPressed: _jobCardItems.isEmpty
                            ? null
                            : () {
                                var empCode = Session.empCode;
                                var fromDate = Utils.formatDate(_fromDate!,
                                    format: "yyyy-MM-dd");
                                var toDate = Utils.formatDate(_toDate!,
                                    format: "yyyy-MM-dd");

                                var fileName =
                                    "Job-Card-$empCode (${Utils.formatDate(_fromDate!, format: "dd-MM-yyyy")}-${Utils.formatDate(_toDate!, format: "dd-MM-yyyy")})";

                                downloadAndShare(
                                    empCode, fromDate, toDate, fileName);
                              },
                        icon: Icon(
                          Icons.download_rounded,
                          size: 20.0,
                          color: UserColors.green,
                        ),
                        label: Text(
                          "Download",
                          style: TextStyle(
                              fontSize: 13.0, color: UserColors.green),
                        ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  downloadAndShare(
      String empCode, String fromDate, String toDate, String fileName) async {
    Utils.showLoadingIndicator(context);

    var filePath = await DownloadService.downloadAttendanceCard(
        empCode, fromDate, toDate, fileName);
    Utils.hideLoadingIndicator(context);
    if (filePath != null) {
      var paths = <String>[];
      paths.add(filePath);

      Share.shareFiles(paths);
    } else {
      MessageBox.show(context, "Download", "Unable to download!");
    }
  }

  generateBlock(String title, dynamic count, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 64,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2.0)),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12.0),
            )),
        Container(
          width: 46,
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          child: Text(count.toString(), style: const TextStyle(fontSize: 14.0)),
        ),
      ],
    );
  }
}
