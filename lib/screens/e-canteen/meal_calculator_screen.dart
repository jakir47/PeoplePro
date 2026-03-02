import 'package:flutter/services.dart';
import 'package:peoplepro/models/canteen_meal_off_pending_list_model.dart';
import 'package:peoplepro/models/e-canteen/request_report_model.dart';
import 'package:peoplepro/screens/e-canteen/request_report_details_screen.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/widgets/month_picker_field_widget.dart';

class MealCalculatorScreen extends StatefulWidget {
  const MealCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<MealCalculatorScreen> createState() => _MealCalculatorScreenState();
}

class _MealCalculatorScreenState extends State<MealCalculatorScreen> {
  List<RequestReportModel> _lines = [];
  bool isLoading = true;

  final ctrlEmpCode = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> calculateMeals(int costTotal, int mealTotal) async {
    FocusScope.of(context).unfocus();
    isLoading = true;
    setState(() {});
    Utils.showLoadingIndicator(context);

    var firstDate = Utils.getFirstDateOfMonth(selectedDate);
    var lastDate = Utils.getLastDateOfMonth(selectedDate);
    String startDate = Utils.formatDate(firstDate, format: "yyyy-MM-dd");
    String endDate = Utils.formatDate(lastDate, format: "yyyy-MM-dd");

    _lines = await CanteenService.getCalculatedMeals(
        startDate, endDate, costTotal, mealTotal);
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

  TextEditingController ctrlMealMonth = TextEditingController();
  DateTime selectedDate = DateTime.now();

  TextEditingController ctrlMealTotal = TextEditingController();
  TextEditingController ctrlCostTotal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Meal Calulator",
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MonthPickerWidget(
                  controller: ctrlMealMonth,
                  selectedDate: selectedDate,
                  onChanged: (date) {
                    if (date != null) {
                      selectedDate = date;
                    }
                  }),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Text("Cost Total"),
                    ),
                    SizedBox(
                      width: 140.0,
                      height: 40.0,
                      child: TextFormField(
                        controller: ctrlCostTotal,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          errorStyle: const TextStyle(
                              height: 0, color: Colors.transparent),
                          contentPadding: const EdgeInsets.only(left: 12.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: UserColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: UserColors.primaryColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Text("Meal Total"),
                    ),
                    SizedBox(
                      width: 140.0,
                      height: 40.0,
                      child: TextFormField(
                        controller: ctrlMealTotal,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          errorStyle: const TextStyle(
                              height: 0, color: Colors.transparent),
                          contentPadding: const EdgeInsets.only(left: 12.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: UserColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: UserColors.primaryColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
              const SizedBox(height: 6),
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
                        calculateMeals(2000, 12);
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
