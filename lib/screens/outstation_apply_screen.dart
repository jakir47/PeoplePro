import 'package:peoplepro/services/leave_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/date_field_widget.dart';
import 'package:flutter/material.dart';

class OutstationApplyScreen extends StatefulWidget {
  const OutstationApplyScreen({Key? key}) : super(key: key);

  @override
  State<OutstationApplyScreen> createState() => _OutstationApplyScreenState();
}

class _OutstationApplyScreenState extends State<OutstationApplyScreen> {
  final ctrlPurpose = TextEditingController();
  final ctrlLocation = TextEditingController();
  final ctrlFromDate = TextEditingController();
  final ctrlToDate = TextEditingController();

  final ctrlApplyDaysCount = TextEditingController(text: "0.0");

  DateTime? fromDate = Settings.serverToday;
  DateTime? toDate = Settings.serverToday;

  bool _isFullDay = true;
  bool _isFirstHalf = true;
  bool isSubmittable = false;

  double _appliedDays = 0.0;

  @override
  void initState() {
    super.initState();

    ctrlFromDate.text = Utils.formatDate(fromDate!);
    ctrlToDate.text = Utils.formatDate(toDate!);
  }

  void calculateAppliedDays() {
    var days = toDate!.difference(fromDate!).inDays + 1;

    if (days > 1 && !_isFullDay) {
      _appliedDays = 0;
    } else {
      _appliedDays = _isFullDay ? days.toDouble() : (days / 2.0);
    }

    ctrlApplyDaysCount.text = _appliedDays.toString();
    submitValidate();
    setState(() {});
  }

  void submitValidate() {
    isSubmittable = true;

    if (_appliedDays == 0.0) {
      isSubmittable = false;
    }

    if (ctrlPurpose.text.isEmpty) {
      isSubmittable = false;
    }

    if (ctrlLocation.text.isEmpty) {
      isSubmittable = false;
    }

    setState(() {});
  }

  void createOutstationDuty() async {
    String dateFrom = ('${fromDate!.year}-${fromDate!.month}-${fromDate!.day}');
    String dateTo = ('${toDate!.year}-${toDate!.month}-${toDate!.day}');

    String purpose = ctrlPurpose.text;
    String location = ctrlLocation.text;

    String leaveDuration =
        _isFullDay ? "fullDay" : (_isFirstHalf ? "halfDayAm" : "halfDayPm");

    Utils.showLoadingIndicator(context);

    var success = await LeaveService.createOutstation(
        dateFrom, dateTo, leaveDuration, purpose, location);

    Utils.hideLoadingIndicator(context);

    if (success) {
      MessageBox.success(
          context, "Outstation Application", "Outstation applied successfully",
          onOkTapped: () {
        Navigator.pop(context, true);
      });
    } else {
      MessageBox.error(context, "Outstation Application", "An error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Outstation Duty Apply",
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "From Date",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          child: DateFieldWidget(
                            controller: ctrlFromDate,
                            onChanged: (DateTime? date) async {
                              fromDate = date;
                              var daysCount =
                                  fromDate!.difference(toDate!).inDays;
                              if (daysCount > 0) {
                                toDate = fromDate;
                                ctrlToDate.text = Utils.formatDate(toDate!);
                                setState(() {});
                              }
                              calculateAppliedDays();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "To Date",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          child: DateFieldWidget(
                            controller: ctrlToDate,
                            onChanged: (DateTime? date) async {
                              toDate = date;
                              var daysCount =
                                  fromDate!.difference(toDate!).inDays;
                              if (daysCount > 0) {
                                fromDate = toDate;
                                ctrlFromDate.text = Utils.formatDate(fromDate!);
                                setState(() {});
                              }
                              calculateAppliedDays();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        Text(
                          _isFullDay ? "Full Day" : "Half Day",
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.black87),
                        ),
                        Switch(
                          value: _isFullDay,
                          activeColor: UserColors.primaryColor,
                          onChanged: (value) {
                            _isFullDay = value;
                            setState(() {});
                            calculateAppliedDays();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Visibility(
                      visible: !_isFullDay,
                      child: Column(
                        children: [
                          Text(
                            _isFullDay
                                ? ""
                                : _isFirstHalf
                                    ? "1st Half"
                                    : "2nd Half",
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.black87),
                          ),
                          Switch(
                            value: _isFirstHalf,
                            activeColor: UserColors.primaryColor,
                            onChanged: _isFullDay
                                ? null
                                : (value) {
                                    setState(() {
                                      _isFirstHalf = value;
                                    });
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "Days",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 50,
                          child: TextField(
                            controller: ctrlApplyDaysCount,
                            enabled: false,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                  height: 0, color: Colors.transparent),
                              contentPadding: const EdgeInsets.only(left: 0.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: UserColors.borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: UserColors.borderColor),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: UserColors.borderColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Purpose",
                    style: TextStyle(color: Colors.black87, fontSize: 12.0),
                  ),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: ctrlPurpose,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: UserColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: UserColors.primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (text) {
                      submitValidate();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Location",
                    style: TextStyle(color: Colors.black87, fontSize: 12.0),
                  ),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: ctrlLocation,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: UserColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: UserColors.primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (text) {
                      submitValidate();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
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
                      onPressed: isSubmittable
                          ? () {
                              createOutstationDuty();
                            }
                          : null,
                      child: const Text(
                        "Submit",
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
