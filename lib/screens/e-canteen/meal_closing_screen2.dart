import 'package:peoplepro/services/canteen_service2.dart';
import 'package:peoplepro/utils/canteen_session.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/message_box.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MealCloseScreen extends StatefulWidget {
  final List<DateTime> mealClosedDates;
  const MealCloseScreen({Key? key, required this.mealClosedDates})
      : super(key: key);

  @override
  State<MealCloseScreen> createState() => _MealCloseScreenState();
}

class _MealCloseScreenState extends State<MealCloseScreen> {
  final Key _pickerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
  }

  void submitRequest() async {
    Utils.showLoadingIndicator(context);

    try {
      int successCount = 0;
      int failCount = 0;
      List<String> failMessages = [];

      for (final mealDate in _selectedDates) {
        final response = await CanteenService2.mealClose(
          CanteenSession.username,
          mealDate,
        );

        final formattedDate = Utils.formatDate(mealDate);

        if (response == null) {
          failCount++;
          failMessages.add("No response for $formattedDate");
          continue;
        }

        if (response.success) {
          successCount++;
        } else {
          failCount++;
          failMessages.add("$formattedDate: ${response.message}");
        }
      }

      Utils.hideLoadingIndicator(context);

      if (failCount == 0) {
        MessageBox.success(
          context,
          "Meal Close",
          "All $successCount meal(s) closed successfully.",
          onOkTapped: () {
            Navigator.pop(context, true);
          },
        );
      } else {
        final summary =
            "Success: $successCount\nFailed: $failCount\n\n${failMessages.join('\n')}";
        if (successCount > 0) {
          MessageBox.success(
            context,
            "Meal Close",
            summary,
            onOkTapped: () {
              Navigator.pop(context, true);
            },
          );
        } else {
          MessageBox.error(context, "Meal Close", summary);
        }
      }
    } catch (e) {
      Utils.hideLoadingIndicator(context);
      MessageBox.error(context, "Meal Close", "Error: ${e.toString()}");
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
    } else if (widget.mealClosedDates.any((mc) => mc == day)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        title: "Meal Close",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SfDateRangePicker(
                  key: _pickerKey,
                  minDate: Settings.serverToday.add(const Duration(days: 1)),
                  maxDate: Settings.serverToday.add(const Duration(days: 45)),
                  onSelectionChanged: _onSelectionChanged,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    weekendDays: const [5],
                    specialDates: widget.mealClosedDates,
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    specialDatesDecoration: BoxDecoration(
                        color: UserColors.primaryColor, shape: BoxShape.circle),
                    specialDatesTextStyle: const TextStyle(color: Colors.white),
                    todayCellDecoration:
                        const BoxDecoration(shape: BoxShape.circle),
                  ),
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  selectableDayPredicate: _isSelectableDay,
                  selectionColor: Colors.red,
                ),
                const SizedBox(height: 40.0),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                          "Submit Request",
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
