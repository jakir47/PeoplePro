import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class HolidayListScreen extends StatefulWidget {
  const HolidayListScreen({Key? key}) : super(key: key);

  @override
  HolidayListScreenState createState() => HolidayListScreenState();
}

class HolidayListScreenState extends State<HolidayListScreen> {
  DateTime today = DateTime.now();
  bool isLoading = true;
  int days = 0;
  String heading = "";

  bool alreadySubmitted = true;

  final List<DropdownMenuItem<int>> months = [
    const DropdownMenuItem(value: 1, child: Text("January")),
    const DropdownMenuItem(value: 2, child: Text("February")),
    const DropdownMenuItem(value: 3, child: Text("March")),
    const DropdownMenuItem(value: 4, child: Text("April")),
    const DropdownMenuItem(value: 5, child: Text("May")),
    const DropdownMenuItem(value: 6, child: Text("June")),
    const DropdownMenuItem(value: 7, child: Text("July")),
    const DropdownMenuItem(value: 8, child: Text("August")),
    const DropdownMenuItem(value: 9, child: Text(" September")),
    const DropdownMenuItem(value: 10, child: Text("October")),
    const DropdownMenuItem(value: 11, child: Text("November")),
    const DropdownMenuItem(value: 12, child: Text("December")),
  ];
  final List<DropdownMenuItem<int>> years = [
    DropdownMenuItem(
        value: DateTime.now().year - 1,
        child: Text((DateTime.now().year - 1).toString())),
    DropdownMenuItem(
        value: DateTime.now().year,
        child: Text((DateTime.now().year).toString())),
    DropdownMenuItem(
        value: DateTime.now().year + 1,
        child: Text((DateTime.now().year + 1).toString())),
  ];

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool nextOne = false;
    return Scaffold(
      body: BackgroundWidget(
        showBottomStrip: false,
        title: "Holiday Calendar",
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                itemCount: Session.userData.holidays!.length,
                separatorBuilder: ((context, index) {
                  return const SizedBox(height: 6.0);
                  // Divider(height: 1, color: Colors.grey.withOpacity(0.5));
                }),
                itemBuilder: (ctx, idx) {
                  var holiday = Session.userData.holidays![idx];
                  //   var dayName = DateFormat('EEEE').format(holiday.eventDate);

                  if (!nextOne && holiday.isUpcoming!) {
                    nextOne = true;
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        border:
                            Border.all(width: 1, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                      color: holiday.isUpcoming!
                                          ? UserColors.primaryColor
                                          : Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Text(
                                    holiday.date!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                  )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2.0),
                                child: Text(holiday.day!,
                                    style: const TextStyle(fontSize: 12.0)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        FittedBox(
                            child: Text(
                          holiday.event!,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Visibility(
                            visible: holiday.isUpcoming!,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "${holiday.dayCount} ${holiday.dayCount! > 1 ? "days" : "day"} remaining",
                                style: const TextStyle(fontSize: 10),
                              ),
                            )),
                      ],
                    ),
                  );
                },
              )),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadiusDirectional.circular(4.0)),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "* Subject to Appearance of the moon.",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    Text(
                      "* Applicable for BGI Head Office only except EAL & DFL.",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
