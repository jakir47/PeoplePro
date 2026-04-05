import 'package:intl/intl.dart';
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
  List<CanteenMealCloseListModel> _mealCloseItems = [];
  String statusText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onLoad());
  }

  void onLoad() async {
    // var success = await login();

    // if (!success) {
    //   statusText = "Canteen service is currently unavailable.";
    //   setState(() {});
    //   return;
    // }
    loadMealClosedList();
    setState(() {});
  }

  void loadMealClosedList() async {
    _mealCloseItems = await CanteenService.getMealClosedList(Session.empCode);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundWidget(
            title: "e-Canteen 2.1",
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (Settings.userAccess.printToken! &&
                              Settings.isActivated)
                            Card(
                              child: TextButton(
                                onPressed: Session.isMealClosedToday
                                    ? null
                                    : () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text("Confirm Request"),
                                            content: const Text(
                                                "Are you sure you want to request a Meal Token?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm != true)
                                          return; // User cancelled

                                        Utils.showLoadingIndicator(context);
                                        var msg =
                                            await CanteenService.printMealToken(
                                                Session.empCode,
                                                Settings.deviceId);
                                        if (msg == "Success") {
                                          await Future.delayed(
                                              const Duration(seconds: 3),
                                              () {});
                                          Utils.hideLoadingIndicator(context);

                                          MessageBox.show(context, "Meal Token",
                                              "Meal Token request successful.");
                                        } else {
                                          Utils.hideLoadingIndicator(context);
                                          MessageBox.error(
                                              context, "Meal Token", msg);
                                        }
                                      },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.print_outlined,
                                      color: Session.isMealClosedToday
                                          ? Colors.grey.shade300
                                          : UserColors.primaryColor,
                                      size: 32.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        "Print Meal Token",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Session.isMealClosedToday
                                              ? Colors.grey.shade300
                                              : Colors.black87,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          Card(
                            child: TextButton(
                              onPressed: () async {
                                var closedDates = _mealCloseItems
                                    .map((e) => e.mealDate)
                                    .toList();
                                var applied = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => MealCloseScreen(
                                            mealClosedDates: closedDates)));
                                if (applied != null && applied) {
                                  loadMealClosedList();
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
                                      "Meal Close",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: TextButton(
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
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Visibility(
                      visible: Session.isMealClosedToday,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(4.0)),
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
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          "Upcoming Closed Meals",
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(height: 10.0),
                    Expanded(
                        child: _mealCloseItems.isEmpty
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
                            : ListView.separated(
                                itemCount: _mealCloseItems.length,
                                itemBuilder: (ctx, index) {
                                  var data = _mealCloseItems[index];
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
                                            child: Text(DateFormat("dd/MM/yyyy")
                                                .format(data.mealDate)),
                                          ),
                                        ],
                                      ),
                                      (!data.isCancellable)
                                          ? const SizedBox(
                                              height: 34.0, width: 46.0)
                                          : InkWell(
                                              onTap: () async {
                                                var response =
                                                    await CanteenService
                                                        .mealCancel(
                                                            Session.empCode,
                                                            data.mealDate);

                                                if (response != null &&
                                                    response.success) {
                                                  loadMealClosedList();
                                                  MessageBox.show(
                                                      context,
                                                      "Meal Cancellation",
                                                      response.message);
                                                } else if (response != null &&
                                                    !response.success) {
                                                  MessageBox.error(
                                                      context,
                                                      "Meal Cancellation",
                                                      response.message);
                                                } else {
                                                  MessageBox.error(
                                                      context,
                                                      "Meal Cancellation",
                                                      "Cannot fulfill your request.");
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: UserColors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0)),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                                  child: Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.white,
                                                    size: 20.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                              )),
                  ],
                )))));
  }
}
