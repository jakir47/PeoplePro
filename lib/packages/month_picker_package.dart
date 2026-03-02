import 'package:flutter/material.dart';
import 'package:peoplepro/utils/colors.dart';

class MonthPickerDialog extends StatefulWidget {
  final DateTime selectedDate;

  const MonthPickerDialog({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  _MonthPickerDialogState createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Month',
        style: TextStyle(fontSize: 14.0),
      ),
      content: SizedBox(
        width: double.minPositive,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: UserColors.primaryColor),
                  onPressed: () {
                    setState(() {
                      _currentDate =
                          DateTime(_currentDate.year - 1, _currentDate.month);
                    });
                  },
                ),
                Text(
                  "${_currentDate.year}",
                ),
                IconButton(
                  icon:
                      Icon(Icons.arrow_forward, color: UserColors.primaryColor),
                  onPressed: () {
                    setState(() {
                      _currentDate =
                          DateTime(_currentDate.year + 1, _currentDate.month);
                    });
                  },
                ),
              ],
            ),
            MonthGrid(
              selectedDate: widget.selectedDate,
              currentDate: _currentDate,
              onMonthTap: (DateTime selectedMonth) {
                Navigator.of(context).pop(selectedMonth);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MonthGrid extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentDate;
  final Function(DateTime) onMonthTap;

  const MonthGrid({
    Key? key,
    required this.selectedDate,
    required this.currentDate,
    required this.onMonthTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        final DateTime month = DateTime(currentDate.year, index + 1);
        final bool isSelected = month.year == selectedDate.year &&
            month.month == selectedDate.month;
        final bool isCurrentMonth =
            month.year == currentDate.year && month.month == currentDate.month;

        return GestureDetector(
          onTap: () {
            if (!isCurrentMonth) {
              onMonthTap(month);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCurrentMonth ? Colors.grey.shade200 : null,
            ),
            child: Text(
              monthNames[index].substring(0, 3),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? UserColors.primaryColor : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}
