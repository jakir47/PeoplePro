import 'package:peoplepro/models/leave_balance_model.dart';
import 'package:peoplepro/services/leave_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/date_field_widget.dart';
import 'package:flutter/material.dart';

class LeaveApplyScreen extends StatefulWidget {
  const LeaveApplyScreen({Key? key}) : super(key: key);

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  List<LeaveBalanaceModel> _leaveLines = [];

  final ctrlLeaveLine = TextEditingController();
  final ctrlNote = TextEditingController();
  final ctrlFromDate = TextEditingController();
  final ctrlToDate = TextEditingController();
  final ctrlDocToHR = TextEditingController();

  final ctrlApplyDaysCount = TextEditingController(text: "0.0");

  // ============ Leave Validation Begin ============
  DateTime? fromDate = Settings.serverToday;
  DateTime? toDate = Settings.serverToday;
  DateTime? _sendDocDate = Settings.serverToday;

  bool _isFullDay = true;
  bool _isFirstHalf = true;
  bool isSubmittable = false;

  LeaveBalanaceModel _selectedLeaveLine = LeaveBalanaceModel(
      balanceDays: 0, leaveType: LeaveType(leaveTypeCode: ""));
  double _appliedDays = 0.0;
  bool _sendDocToHR = false;
  String _selectedLeaveTypeCode = "";

// ============ Leave Validation End ============

  @override
  void initState() {
    super.initState();

    ctrlFromDate.text = Utils.formatDate(fromDate!);
    ctrlToDate.text = Utils.formatDate(toDate!);

    onLoad();
  }

  void onLoad() async {
    var balances = await LeaveService.getLeaveBalanceList();
    balances.sort((a, b) => a.leaveType!.name!.compareTo(b.leaveType!.name!));

    for (var balance in balances) {
      if (balance.leaveType!.leaveTypeCode! == "EL") {
        if (Settings.isEarnLeaveApplicable) {
          _leaveLines.add(balance);
        }
        continue;
      }
      _leaveLines.add(balance);
    }

    setState(() {});
  }

  void onShowLeaveBalance() {
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0.7),
        context: context,
        builder: (context) {
          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(width: 1, color: Colors.grey.shade200),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Leave Type",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Balance",
                        style: TextStyle(fontSize: 12),
                      ),
                    ]),
              ),
              Expanded(
                  child: ListView.separated(
                itemCount: _leaveLines.length,
                separatorBuilder: ((context, index) {
                  return Divider(
                      height: 1, color: Colors.grey.withOpacity(0.4));
                }),
                itemBuilder: (ctx, idx) {
                  var leaveLine = _leaveLines[idx];

                  return InkWell(
                    onTap: () {
                      ctrlLeaveLine.text = leaveLine.leaveType!.name!;
                      _selectedLeaveLine = leaveLine;
                      _selectedLeaveTypeCode =
                          leaveLine.leaveType!.leaveTypeCode!;
                      Navigator.pop(context);
                      calculateAppliedDays();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                      color: UserColors.primaryColor,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(4))),
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: Text(
                                      leaveLine.leaveType!.leaveTypeCode!,
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 4),
                                  child: Text(leaveLine.leaveType!.name!,
                                      style: const TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            leaveLine.balanceDays.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ],
          );
        });
  }

  void calculateAppliedDays() {
    var leaveTypeName = _selectedLeaveLine.leaveType!.leaveTypeCode!;

    if (leaveTypeName.isEmpty) {
      MessageBox.error(context, leaveTypeName, "Please select a leave type");
      _appliedDays = 0;
      ctrlApplyDaysCount.text = _appliedDays.toString();
      setState(() {});
      return;
    }

    var balanceDays = _selectedLeaveLine.balanceDays!;
    var days = toDate!.difference(fromDate!).inDays + 1;

    if (balanceDays == 0) {
      _appliedDays = 0;
    } else if (days > 1 && !_isFullDay) {
      _appliedDays = 0;
    } else {
      var selectedDays = _isFullDay ? days.toDouble() : (days.toDouble() / 2.0);

      if (_selectedLeaveTypeCode == "CL" && selectedDays > 3) {
        _appliedDays = 0;
        MessageBox.error(context, leaveTypeName,
            "You've exceeded the maximum consecutive leave days limit of 3.0 days.");
      } else if (_selectedLeaveTypeCode == "SL" &&
          selectedDays > 3 &&
          !_sendDocToHR) {
        _appliedDays = 0;
        MessageBox.error(
            context, leaveTypeName, "Please select send doc to HR");
      } else {
        _appliedDays = selectedDays <= balanceDays ? selectedDays : 0.0;
        if (_appliedDays == 0.0) {
          MessageBox.error(
              context, leaveTypeName, "You've exceeded the balance leave days");
        }
      }
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

    if (ctrlNote.text.trim().isEmpty) {
      isSubmittable = false;
    }

    if (_selectedLeaveTypeCode == "SL" && !_sendDocToHR && _appliedDays > 3.0) {
      _appliedDays = 0;
      ctrlApplyDaysCount.text = _appliedDays.toString();
    }

    setState(() {});
  }

  void createLeaveApplication() async {
    String dateFrom = ('${fromDate!.year}-${fromDate!.month}-${fromDate!.day}');
    String dateTo = ('${toDate!.year}-${toDate!.month}-${toDate!.day}');

    String note = ctrlNote.text;
    String docSentToHrDate =
        ('${_sendDocDate!.year}-${_sendDocDate!.month}-${_sendDocDate!.day}');

    String leaveDuration =
        _isFullDay ? "fullDay" : (_isFirstHalf ? "halfDayAm" : "halfDayPm");

    Utils.showLoadingIndicator(context);

    var base64Image = "";

    var success = await LeaveService.createLeaveApplication(
        _selectedLeaveTypeCode,
        dateFrom,
        dateTo,
        leaveDuration,
        note,
        base64Image,
        _sendDocToHR,
        docSentToHrDate);

    Utils.hideLoadingIndicator(context);

    if (success) {
      MessageBox.success(
          context, "Leave Application", "Leave applied successfully",
          onOkTapped: () {
        Navigator.pop(context, true);
      });
    } else {
      MessageBox.error(context, "Leave Application", "An error occurred");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Leave Apply",
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Leave Type",
                        style: TextStyle(color: Colors.black87, fontSize: 12.0),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                      child: InkWell(
                        onTap:
                            _leaveLines.isNotEmpty ? onShowLeaveBalance : null,
                        child: IgnorePointer(
                          child: TextField(
                            controller: ctrlLeaveLine,
                            readOnly: true,
                            autofocus: false,
                            keyboardType: TextInputType.none,
                            maxLines: 1,
                            decoration: InputDecoration(
                                hintText: "Select a leave type",
                                hintStyle: const TextStyle(
                                    fontSize: 14.0, color: Colors.black54),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(color: UserColors.borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: UserColors.primaryColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                suffix: Text(
                                  _selectedLeaveLine.balanceDays.toString(),
                                  style:
                                      TextStyle(color: UserColors.primaryColor),
                                ),
                                suffixIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: UserColors.primaryColor,
                                )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
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
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
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
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
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
                                  ctrlFromDate.text =
                                      Utils.formatDate(fromDate!);
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
                            // materialTapTargetSize:
                            //     MaterialTapTargetSize.shrinkWrap,

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
                              // materialTapTargetSize:
                              //     MaterialTapTargetSize.shrinkWrap,
                              // inactiveThumbColor: Colors.grey,
                              // inactiveTrackColor: Colors.grey.withOpacity(0.5),

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
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
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
                                contentPadding:
                                    const EdgeInsets.only(left: 0.0),
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
                      "Note",
                      style: TextStyle(color: Colors.black87, fontSize: 12.0),
                    ),
                    const SizedBox(height: 6.0),
                    TextField(
                      controller: ctrlNote,
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
                          borderSide:
                              BorderSide(color: UserColors.primaryColor),
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
                Visibility(
                    visible:
                        _selectedLeaveLine.leaveType!.leaveTypeCode! == "SL",
                    child: const SizedBox(height: 16.0)),
                Visibility(
                  visible: _selectedLeaveLine.leaveType!.leaveTypeCode! == "SL",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Checkbox(
                            value: _sendDocToHR,
                            onChanged: (bool? value) {
                              _sendDocToHR = value!;
                              if (_sendDocToHR) {
                                ctrlDocToHR.text =
                                    Utils.formatDate(_sendDocDate!);
                              } else {
                                ctrlDocToHR.text = "";
                              }
                              submitValidate();
                              setState(() {});
                            }),
                      ),
                      GestureDetector(
                          onTap: () {
                            _sendDocToHR = !_sendDocToHR;
                            if (_sendDocToHR) {
                              ctrlDocToHR.text =
                                  Utils.formatDate(_sendDocDate!);
                            } else {
                              ctrlDocToHR.text = "";
                            }
                            submitValidate();
                            setState(() {});
                          },
                          child: const Text("Send doc to HR")),
                      Flexible(
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: DateFieldWidget(
                              controller: ctrlDocToHR,
                              onChanged: (DateTime? date) async {
                                _sendDocDate = date;
                                setState.call(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                UserColors.primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: BorderSide(
                                      color: UserColors.primaryColor)),
                            )),
                        onPressed: isSubmittable
                            ? () {
                                createLeaveApplication();
                              }
                            : null,
                        child: const Text(
                          "Submit",
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
