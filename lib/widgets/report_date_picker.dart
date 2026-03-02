import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/packages/dropdown_package.dart' as ddp;
import 'package:peoplepro/packages/date_range_picker.dart' as drp;

class ReportDatePicker extends StatefulWidget {
  final ValueChanged<ReportDate> onDateChanged;

  const ReportDatePicker({required this.onDateChanged, Key? key})
      : super(key: key);

  @override
  State<ReportDatePicker> createState() => _ReportDatePickerState();
}

class _ReportDatePickerState extends State<ReportDatePicker> {
  List<ReportDate?>? reportDates = <ReportDate>[];

  @override
  void initState() {
    super.initState();
    loadDates();
  }

  void loadDates() {
    var today = Settings.serverToday;

    var dates = <ReportDate?>[];
    dates.add(ReportDate(
        text: "Today", startDate: today, endDate: today, hasDivider: false));
    dates.add(ReportDate(
        text: "Last 7 days",
        startDate: today.subtract(const Duration(days: 6)),
        hasDivider: false,
        endDate: today));

    // dates.add(ReportDate(
    //     text: "Last 14 days",
    //     startDate: today.subtract(const Duration(days: 13)),
    //     hasDivider: false,
    //     endDate: today));

    // dates.add(ReportDate(
    //     text: "Last 28 days",
    //     startDate: today.subtract(const Duration(days: 27)),
    //     hasDivider: false,
    //     endDate: today));

    // dates.add(ReportDate(
    //     text: "Last 90 days",
    //     startDate: today.subtract(const Duration(days: 89)),
    //     hasDivider: false,
    //     endDate: today));

    // dates.add(ReportDate(
    //     text: "Last 365 days",
    //     startDate: today.subtract(const Duration(days: 364)),
    //     endDate: today,
    //     hasDivider: true));

    // dates.add(ReportDate(
    //     text: (today.year - 1).toString(),
    //     hasDivider: false,
    //     startDate: DateTime(today.year - 1, 1, 1),
    //     endDate: DateTime(today.year - 1, 12, 31)));

    // dates.add(ReportDate(
    //     text: (today.year).toString(),
    //     startDate: DateTime(today.year, 1, 1),
    //     endDate: DateTime(today.year, 12, 31),
    //     hasDivider: true));

    dates.add(ReportDate(
        text: (Utils.formatDate(today, format: "MMMM")),
        hasDivider: false,
        startDate: DateTime(today.year, today.month, 1),
        endDate: DateTime(today.year, today.month + 1, 0)));

    var prevMonthText = "";
    var date = DateTime(today.year, today.month - 1, 1);
    if (date.year == today.year) {
      prevMonthText = Utils.formatDate(date, format: "MMMM");
    } else {
      prevMonthText = Utils.formatDate(date, format: "MMMM yyyy");
    }
    dates.add(ReportDate(
        text: prevMonthText,
        hasDivider: false,
        startDate: date,
        endDate: DateTime(date.year, date.month + 1, 0)));

    date = DateTime(today.year, today.month - 2, 1);
    if (date.year == today.year) {
      prevMonthText = Utils.formatDate(date, format: "MMMM");
    } else {
      prevMonthText = Utils.formatDate(date, format: "MMMM yyyy");
    }
    dates.add(ReportDate(
        text: prevMonthText,
        startDate: date,
        endDate: DateTime(date.year, date.month + 1, 0),
        hasDivider: true));
    date = DateTime(today.year, today.month - 3, 1);
    if (date.year == today.year) {
      prevMonthText = Utils.formatDate(date, format: "MMMM");
    } else {
      prevMonthText = Utils.formatDate(date, format: "MMMM yyyy");
    }
    dates.add(ReportDate(
        text: prevMonthText,
        startDate: date,
        endDate: DateTime(date.year, date.month + 1, 0),
        hasDivider: true));

    dates.add(ReportDate(
        text: "Custom",
        hasDivider: false,
        startDate: today.subtract(const Duration(days: 7)),
        endDate: today));

    reportDates = dates;
    selectedDate = dates.first;
    changeDateText();
    setState(() {});
  }

  ReportDate? selectedDate;
  String selectedDateText = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(selectedDateText,
              style: TextStyle(fontSize: 12, color: Colors.grey[800])),
          SizedBox(
            height: 24,
            child: ddp.DropdownButton<ReportDate>(
                isDense: true,
                isExpanded: true,
                elevation: 4,
                iconSize: 20,
                itemHeight: 38,
                value: selectedDate,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(12),
                items: reportDates!.map((ReportDate? item) {
                  return ddp.DropdownMenuItem(
                      child: Text(item!.text!,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black)),
                      value: item);
                }).toList(),
                onChanged: (ReportDate? value) async {
                  if (value!.text == "Custom") {
                    var dates = await drp.showDatePicker(
                        context: context,
                        initialFirstDate: value.startDate!,
                        initialLastDate: value.endDate!,
                        firstDate: DateTime(2021),
                        lastDate: DateTime(
                          DateTime.now().year,
                          DateTime.now().month + 2,
                          0,
                        ));

                    if (dates != null && dates.length == 2) {
                      value.startDate = dates[0];
                      value.endDate = dates[1];
                    } else {
                      return;
                    }
                  }

                  selectedDate = value;
                  widget.onDateChanged(value);
                  changeDateText();
                  setState(() {});
                }),
          ),
        ],
      ),
    );
  }

  void changeDateText() {
    selectedDateText = selectedDate!.startDate == selectedDate!.endDate
        ? Utils.formatDate(selectedDate!.startDate!, format: "MMMM dd, yyyy")
        : Utils.formatDate(selectedDate!.startDate!, format: "MMM dd, yyyy") +
            " – " +
            Utils.formatDate(selectedDate!.endDate!, format: "MMM dd, yyyy");
  }
}

class ReportDate {
  String? text;
  DateTime? startDate;
  DateTime? endDate;
  bool? hasDivider;
  ReportDate({this.text, this.startDate, this.endDate, this.hasDivider});

  ReportDate.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    hasDivider = json['hasDivider'];
  }
}
