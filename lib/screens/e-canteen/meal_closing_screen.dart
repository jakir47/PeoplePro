import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/session.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:peoplepro/widgets/dropdown_button_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MealClosingScreen extends StatefulWidget {
  const MealClosingScreen({Key? key}) : super(key: key);

  @override
  State<MealClosingScreen> createState() => _MealClosingScreenState();
}

class _MealClosingScreenState extends State<MealClosingScreen> {
  final List<DropdownItem> _reuestTypes = [
    DropdownItem("Employee (Self)", "1")
  ];

  Key _pickerKey = UniqueKey();
  int _requestTypeId = 1;

  @override
  void initState() {
    super.initState();

    if (Settings.userAccess.driverId!.isNotEmpty) {
      _reuestTypes.add(DropdownItem("Driver", "2"));
    }
  }

  void submitRequest() async {
    Utils.showLoadingIndicator(context);

    var empCode =
        _requestTypeId == 1 ? Session.empCode : Settings.userAccess.driverId!;
    var output = await CanteenService.mealClosing(empCode, _selectedDates);

    Utils.hideLoadingIndicator(context);

    if (output.isSuccess!) {
      MessageBox.success(
          context, "Meal Closing", "Meal closing request successful",
          onOkTapped: () {
        Navigator.pop(context, true);
      });
    } else {
      MessageBox.error(context, "Meal Closing", output.message!);
    }
  }

  List<DateTime> _selectedDates = [];
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDates = args.value as List<DateTime>;
    });
  }

  bool _isSelectableDay(DateTime day) {
    if (day.weekday == DateTime.friday) {
      return false;
    } else if (Session.mealClosings.any((mc) =>
        mc.issueDate! == day &&
        mc.empId ==
            (_requestTypeId == 2
                ? Settings.userAccess.driverId!
                : Session.empCode))) {
      return false;
    }
    return true;
  }

  List<DateTime>? getClosingDays() {
    var days = Session.mealClosings
        .where((mc) =>
            mc.empId ==
            (_requestTypeId == 2
                ? Settings.userAccess.driverId!
                : Session.empCode))
        .map((mc) => mc.issueDate)
        .whereType<DateTime>()
        .toList();
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Meal Closing",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "Meal closing for",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                      DropdownButtonWidget(
                        hint: '',
                        items: _reuestTypes,
                        borderColor: UserColors.primaryColor,
                        selectedValue: _requestTypeId.toString(),
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14),
                        selectedValueChanged: (value) async {
                          _requestTypeId = int.parse(value);
                          _pickerKey = UniqueKey();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                SfDateRangePicker(
                  key: _pickerKey,
                  minDate: Settings.serverToday.add(const Duration(days: 1)),
                  maxDate: Settings.serverToday.add(const Duration(days: 45)),
                  onSelectionChanged: _onSelectionChanged,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    weekendDays: const [5],
                    specialDates: getClosingDays(),
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    specialDatesDecoration: BoxDecoration(
                        color: Colors.grey.shade400, shape: BoxShape.circle),
                    specialDatesTextStyle:
                        const TextStyle(color: Colors.black87),
                    todayCellDecoration:
                        const BoxDecoration(shape: BoxShape.circle),
                  ),
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  selectableDayPredicate: _isSelectableDay,
                  selectionColor: Colors.red,
                ),
                const SizedBox(height: 40.0),
                SizedBox(
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
                        onPressed: _selectedDates.isEmpty
                            ? null
                            : () => submitRequest(),
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
