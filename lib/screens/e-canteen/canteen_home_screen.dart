import 'package:intl/intl.dart';
import 'package:peoplepro/models/e-canteen/meal_monthly_summary.dart';
import 'package:peoplepro/screens/e-canteen/meal_card_screen.dart';
import 'package:peoplepro/screens/e-canteen/meal_closing_screen.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class CanteenHomeScreen extends StatefulWidget {
  const CanteenHomeScreen({Key? key}) : super(key: key);

  @override
  State<CanteenHomeScreen> createState() => _CanteenHomeScreenState();
}

class _CanteenHomeScreenState extends State<CanteenHomeScreen> {
  MealMonthlySummary _mealMonthlySummary = MealMonthlySummary();
  var closedToday = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onLoad());
  }

  void onLoad() {
    loadMealClosing();
    loadMonthlySummary();
  }

  void loadMealClosing() async {
    Session.mealClosings =
        await CanteenService.getMealClosingList(Session.empCode);
    var inputDate = DateTime(Settings.serverToday.year,
        Settings.serverToday.month, Settings.serverToday.day);
    closedToday = Session.mealClosings.any((d) => d.issueDate! == inputDate);
    setState(() {});
  }

  void loadMonthlySummary() async {
    _mealMonthlySummary =
        await CanteenService.getMealMonthlySummary(Session.empCode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
            title: "e-Canteen",
            child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (Settings.userAccess.printToken! &&
                                Settings.isActivated)
                              TextButton(
                                onPressed: closedToday
                                    ? null
                                    : () async {
                                        Utils.showLoadingIndicator(context);
                                        var msg = await CanteenService
                                            .generateToken();
                                        if (msg == "Success") {
                                          await Future.delayed(
                                              const Duration(seconds: 3),
                                              () {});
                                          Utils.hideLoadingIndicator(context);

                                          MessageBox.show(context, "Token",
                                              "Token request successful.");
                                          await Future.delayed(
                                              const Duration(seconds: 2),
                                              () => loadMonthlySummary());
                                        } else {
                                          Utils.hideLoadingIndicator(context);
                                          MessageBox.error(
                                              context, "Token", msg);
                                        }
                                      },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.print_outlined,
                                      color: UserColors.primaryColor,
                                      size: 32.0,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        "Print Token",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            TextButton(
                              onPressed: () async {
                                var applied = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MealClosingScreen()));
                                if (applied != null && applied) {
                                  loadMealClosing();
                                }
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.dinner_dining_outlined,
                                    color: UserColors.red,
                                    size: 32.0,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      "Meal Closing",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const MealCardScreen()));
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.food_bank_outlined,
                                    color: UserColors.green,
                                    size: 32.0,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      "Meal Card",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Visibility(
                        visible: closedToday,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                            decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(3.0)),
                            child: const Text(
                              "You've closed your meal for today!",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: UserColors.primaryColor,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Text(
                          "Meal Summary ${_mealMonthlySummary.title!}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildSummaryTable(),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: UserColors.primaryColor,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: const Text(
                            "Upcoming Meal Closing",
                            style: TextStyle(color: Colors.white),
                          )),
                      const SizedBox(height: 10.0),
                      Expanded(
                          child: Session.mealClosings.isEmpty
                              ? Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 2.0,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Colors.black54,
                                      )),
                                      child: const Text(
                                        "No data found",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: Session.mealClosings.length,
                                  itemBuilder: (ctx, index) {
                                    var data = Session.mealClosings[index];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: UserColors.primaryColor,
                                              size: 16.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                  DateFormat("dd/MM/yyyy")
                                                      .format(data.issueDate!)),
                                            ),
                                          ],
                                        ),
                                        Text(data.isDriver! ? "Driver" : "---"),
                                        (!data.cancellable!)
                                            ? const SizedBox(
                                                height: 34.0, width: 46.0)
                                            : InkWell(
                                                onTap: () async {
                                                  var success =
                                                      await CanteenService
                                                          .mealClosingCancel(
                                                              data.empId!,
                                                              data.id!);
                                                  if (success) {
                                                    loadMealClosing();
                                                    MessageBox.show(
                                                        context,
                                                        "Meal Closing",
                                                        "Cancellation successful.");
                                                  } else {
                                                    MessageBox.error(
                                                        context,
                                                        "Meal Closing",
                                                        "Cannot fulfill your request.");
                                                  }
                                                },
                                                child: Card(
                                                  color: UserColors.red,
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 4.0),
                                                    child: Icon(
                                                      Icons.cancel_outlined,
                                                      color: Colors.white,
                                                      size: 18.0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                      ],
                                    );
                                  })),
                    ],
                  ),
                ))));
  }

  _buildSummaryTable() {
    final isDriverVisible = Settings.userAccess.driverId!.isNotEmpty;
    final items = [
      _SummaryItem("Employee", _mealMonthlySummary.employee.toString(),
          UserColors.primaryColor, 90),
      _SummaryItem("Guest", _mealMonthlySummary.guest.toString(),
          Colors.orange.shade600, 80.0),
      if (isDriverVisible)
        _SummaryItem("Driver", _mealMonthlySummary.driver.toString(),
            Colors.green.shade600, 80.0),
      _SummaryItem("Total", _mealMonthlySummary.total.toString(),
          Colors.blue.shade800, 80.0,
          isTotal: true),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items,
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double width;
  final bool isTotal;

  const _SummaryItem(
    this.label,
    this.value,
    this.color,
    this.width, {
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: isTotal
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isTotal ? color : Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
