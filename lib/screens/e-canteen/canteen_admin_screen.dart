import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peoplepro/models/e-canteen/admin_meal_closing_count_model.dart';
import 'package:peoplepro/models/e-canteen/admin_meal_daily_report.dart';
import 'package:peoplepro/models/e-canteen/meal_count_summary_model.dart';
import 'package:peoplepro/screens/e-canteen/admin_member_count_model.dart';
import 'package:peoplepro/screens/e-canteen/canteen_admin_card_screen.dart';
import 'package:peoplepro/screens/e-canteen/canteen_admin_factory_guest_token_screen.dart';
import 'package:peoplepro/screens/e-canteen/canteen_member_query_screen.dart';
import 'package:peoplepro/screens/e-canteen/canteen_member_screen.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';

class CanteenAdminScreen extends StatefulWidget {
  const CanteenAdminScreen({Key? key}) : super(key: key);

  @override
  State<CanteenAdminScreen> createState() => _CanteenAdminScreenState();
}

class _CanteenAdminScreenState extends State<CanteenAdminScreen> {
  List<MealCountSummaryModel> _mealCounts = [];
  List<AdminMealClosingCountModel> _mealClosingCount = [];
  AdminMemberCountModel _memberCount = AdminMemberCountModel();
  var totalMealCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onLoad());
  }

  void onLoad() {
    loadSummaries();
  }

  void loadSummaries() async {
    _mealCounts = await CanteenService.getMealCountSummary();
    totalMealCount = _mealCounts.fold(0, (sum, item) => sum + item.mealCount!);
    _memberCount = await CanteenService.getAdminMemberCount();
    _mealClosingCount = await CanteenService.getAdminMealClosingCountSummary();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          title: "e-Canteen: Dashboard",
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 20.0,
                        color: UserColors.primaryColor,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text("Total Member (Active)"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                              width: 70,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Colors.black54),
                                  top: BorderSide(color: Colors.black54),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: const Text(
                                "Paid",
                                style: TextStyle(),
                              )),
                          Container(
                            width: 70,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.black54),
                                top: BorderSide(color: Colors.black54),
                                bottom: BorderSide(color: Colors.black54),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: InkWell(
                              onTap: () {
                                Utils.navigateTo(
                                    context,
                                    const CanteenMemberQueryScreen(
                                      type: 1,
                                    ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  _memberCount.paidCount.toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: UserColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              width: 70,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Colors.black54),
                                  top: BorderSide(color: Colors.black54),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: const Text(
                                "Free",
                                style: TextStyle(),
                              )),
                          Container(
                            width: 70,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.black54),
                                top: BorderSide(color: Colors.black54),
                                bottom: BorderSide(color: Colors.black54),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: InkWell(
                              onTap: () {
                                Utils.navigateTo(context,
                                    const CanteenMemberQueryScreen(type: 2));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  _memberCount.freeCount.toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: UserColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              width: 70,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Colors.black54),
                                  top: BorderSide(color: Colors.black54),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: const Text(
                                "Rice",
                                style: TextStyle(),
                              )),
                          Container(
                            width: 70,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.black54),
                                top: BorderSide(color: Colors.black54),
                                bottom: BorderSide(color: Colors.black54),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: InkWell(
                              onTap: () {
                                Utils.navigateTo(context,
                                    const CanteenMemberQueryScreen(type: 3));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  _memberCount.riceCount.toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: UserColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              width: 70,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Colors.black54),
                                  top: BorderSide(color: Colors.black54),
                                  right: BorderSide(color: Colors.black54),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: const Text(
                                "Total",
                                style: TextStyle(),
                              )),
                          Container(
                            width: 70,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.black54),
                                top: BorderSide(color: Colors.black54),
                                right: BorderSide(color: Colors.black54),
                                bottom: BorderSide(color: Colors.black54),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                _memberCount.total.toString(),
                                style: const TextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.food_bank_outlined,
                        size: 20.0,
                        color: UserColors.red,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text("Meal Closing"),
                      ),
                    ],
                  ),
                  const Divider(),
                  Column(
                      children: _mealClosingCount
                          .map((mc) => mealClosingCountRow(mc))
                          .toList()),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.dinner_dining_outlined,
                            size: 20.0,
                            color: UserColors.green,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Text("Meal Served (Today)"),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: UserColors.green,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            totalMealCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          children: _mealCounts
                              .map((mc) => mealCountSummaryRow(mc))
                              .toList()),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const CanteenMembersScreen()));
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  color: UserColors.primaryColor,
                                  size: 20.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Members",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const CanteenAdminCardScreen()));
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.card_membership,
                                  color: UserColors.red,
                                  size: 20.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Master Card",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              Utils.navigateTo(context,
                                  const CanteenAdminFactoryGuestTokenScreen());
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.food_bank_outlined,
                                  color: UserColors.green,
                                  size: 20.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Factory Guest",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              //
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.paid_outlined,
                                  color: Colors.deepOrange,
                                  size: 20.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Cost Entry",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              //
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inventory,
                                  color: Colors.cyan.shade500,
                                  size: 20.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Item Entry",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              //
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.pie_chart,
                                  color: Colors.amberAccent.shade400,
                                  size: 20.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Analytics",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         const CanteenMembersScreen()));
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.food_bank_outlined,
                                  color: Colors.orange,
                                  size: 20.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Manual Close",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         const AdminMealDailyReport()));
                            },
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.list_rounded,
                                  color: Colors.indigo,
                                  size: 20.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Daily Report",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          width: 96.0,
                          child: TextButton(
                            onPressed: () {
                              //
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.pending_actions_rounded,
                                  color: Colors.purple.shade900,
                                  size: 20.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "Final Report",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget mealCountSummaryRow(MealCountSummaryModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(data.title!),
          Text(
            data.mealCount.toString(),
            style: const TextStyle(),
          ),
        ],
      ),
    );
  }

  Widget mealClosingCountRow(AdminMealClosingCountModel data) {
    var isToday = data.isToday!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: isToday ? UserColors.red : UserColors.primaryColor,
                size: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  DateFormat("dd/MM/yyyy").format(data.issueDate!) +
                      (data.isToday! ? ' (Today)' : ''),
                  style: TextStyle(
                      color: isToday ? UserColors.red : Colors.black87),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Utils.navigateTo(context,
                  CanteenMemberQueryScreen(type: 4, inputData: data.issueDate));
            },
            child: Card(
              child: Container(
                width: 50,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                child: Text(
                  data.total.toString(),
                  style: TextStyle(
                    color: isToday ? UserColors.red : UserColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
