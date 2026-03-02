import 'package:peoplepro/models/canteen_meal_off_pending_list_model.dart';
import 'package:peoplepro/models/e-canteen/request_report_model.dart';
import 'package:peoplepro/screens/e-canteen/request_report_details_screen.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/widgets/report_date_picker.dart';

class RequestReportScreen extends StatefulWidget {
  const RequestReportScreen({Key? key}) : super(key: key);

  @override
  State<RequestReportScreen> createState() => _RequestReportScreenState();
}

class _RequestReportScreenState extends State<RequestReportScreen> {
  List<RequestReportModel> _lines = [];
  bool isLoading = true;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final ctrlEmpCode = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadMealOffReport(
      String startDate, String endDate, String? empCode) async {
    FocusScope.of(context).unfocus();
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);
    _lines = await CanteenService.getRequestReport(startDate, endDate, empCode);
    Utils.hideLoadingIndicator(context);
    isLoading = false;
    setState(() {});
  }

  Widget employeeInfoWidget(MealOffPendingListModel line) {
    Image image = Image.asset("assets/images/avatar.jpg");

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
              ],
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.name!,
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
                    line.designation!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  line.department!,
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

  buildListItem(RequestReportModel line) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RequestReportDetailsScreen(
                  reportLine: line,
                )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                        ),
                      )),
                  const SizedBox(width: 8.0),
                  Text(
                    "${line.name!} (${line.empCode!})",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        "Total Meal Off",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                        ),
                      )),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      line.totalMealOff.toString(),
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.fade,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        "Total My Guest",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                        ),
                      )),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      line.totalMyGuest.toString(),
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.fade,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Report",
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ReportDatePicker(onDateChanged: (data) {
                _startDate = data.startDate!;
                _endDate = data.endDate!;
              }),
              const SizedBox(height: 12),
              TextFormField(
                controller: ctrlEmpCode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "047785",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(width: 1.0)),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              UserColors.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side:
                                    BorderSide(color: UserColors.primaryColor)),
                          )),
                      onPressed: () {
                        loadMealOffReport(
                            Utils.formatDate(_startDate, format: "yyyy-MM-dd"),
                            Utils.formatDate(_endDate, format: "yyyy-MM-dd"),
                            ctrlEmpCode.text);
                        setState(() {});
                      },
                      child: const Text(
                        "Generate",
                      ))),
              const SizedBox(height: 12.0),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var line = _lines[index];
                    return buildListItem(line);
                  },
                  itemCount: _lines.length,
                  separatorBuilder: ((context, index) {
                    return const SizedBox(height: 6.0);
                    // Divider(height: 1, color: Colors.grey.withOpacity(0.5));
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
