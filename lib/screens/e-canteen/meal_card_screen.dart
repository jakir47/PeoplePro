import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peoplepro/models/e-canteen/meal_card_model.dart';
import 'package:peoplepro/services/canteen_service.dart';
import 'package:peoplepro/utils/colors.dart';
import 'package:peoplepro/utils/settings.dart';
import 'package:peoplepro/utils/utils.dart';
import 'package:peoplepro/widgets/background_widget.dart';
import 'package:peoplepro/widgets/report_date_picker.dart';

class MealCardScreen extends StatefulWidget {
  const MealCardScreen({Key? key}) : super(key: key);

  @override
  State<MealCardScreen> createState() => _MealCardScreenState();
}

class _MealCardScreenState extends State<MealCardScreen> {
  List<MealCardModel> _mealCardItems = [];
  int total = 0;
  int employee = 0;
  int guest = 0;
  int driver = 0;
  int closedMeals = 0;
  int holidaysWeekends = 0;
  bool isLoading = true;
  DateTime? _fromDate = Settings.serverToday;
  DateTime? _toDate = Settings.serverToday;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadMealCard());
  }

  Future<void> loadMealCard() async {
    setState(() {
      isLoading = true;
      total = 0;
      employee = 0;
      guest = 0;
      driver = 0;
      closedMeals = 0;
      holidaysWeekends = 0;
    });

    try {
      final fromDate = Utils.formatDate(_fromDate!, format: "yyyy-MM-dd");
      final toDate = Utils.formatDate(_toDate!, format: "yyyy-MM-dd");
      _mealCardItems = await CanteenService.getMealCard(fromDate, toDate);

      for (var item in _mealCardItems) {
        total += item.total!;
        employee += item.employee!;
        guest += item.guest!;
        driver += item.driver!;

        if (item.statusText == 'C') {
          closedMeals++;
        } else if (item.statusText == 'H' || item.statusText == 'W') {
          holidaysWeekends++;
        }
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _handleDateRangeChanged(DateTime start, DateTime end) {
    _fromDate = start;
    _toDate = end;
    loadMealCard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDriverVisible = Settings.userAccess.driverId!.isNotEmpty;

    return Scaffold(
      body: BackgroundWidget(
        title: "Meal Card Report",
        child: Column(
          children: [
            // Date Picker Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: ReportDatePicker(
                onDateChanged: (data) => _handleDateRangeChanged(
                  data.startDate!,
                  data.endDate!,
                ),
              ),
            ),

            // Legend Section
            _buildLegend(isDriverVisible),

            // Data Section
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _mealCardItems.isEmpty
                      ? Center(
                          child: Text(
                            "No meal card data available",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          itemCount: _mealCardItems.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = _mealCardItems[index];
                            return _MealCardItem(
                              item: item,
                              isDriverVisible: isDriverVisible,
                            );
                          },
                        ),
            ),

            // Summary Section
            if (!isLoading) _buildSummaryCard(isDriverVisible),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDriverVisible) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Wrap(
        spacing: 16.0,
        runSpacing: 12.0,
        children: [
          _LegendItem(
            color: UserColors.primaryColor,
            text: "Employee",
          ),
          _LegendItem(
            color: Colors.orange.shade600,
            text: "Guest",
          ),
          if (isDriverVisible)
            _LegendItem(
              color: Colors.green.shade600,
              text: "Driver",
            ),
          const _LegendItem(
            color: Colors.red,
            text: "Closed",
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(bool isDriverVisible) {
    if (_mealCardItems.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "SUMMARY",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 2.0,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                if (employee > 0)
                  _SummaryItem(
                    label: "Employee",
                    value: employee,
                    color: UserColors.primaryColor,
                  ),
                if (guest > 0)
                  _SummaryItem(
                    label: "Guest",
                    value: guest,
                    color: Colors.orange.shade600,
                  ),
                if (isDriverVisible && driver > 0)
                  _SummaryItem(
                    label: "Driver",
                    value: driver,
                    color: Colors.green.shade600,
                  ),
                if (closedMeals > 0)
                  _SummaryItem(
                    label: "Closed",
                    value: closedMeals,
                    color: Colors.red.shade600,
                  ),
                _SummaryItem(
                  label: "Total",
                  value: total,
                  color: Colors.blue.shade800,
                  isTotal: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCardItem extends StatelessWidget {
  final MealCardModel item;
  final bool isDriverVisible;

  const _MealCardItem({
    required this.item,
    required this.isDriverVisible,
  });

  String _getStatusText(String status) {
    switch (status) {
      case 'C':
        return "Closed";
      case 'H':
        return "Holiday";
      case 'W':
        return "Weekend";
      case 'A':
        return "Absent";
      case 'P':
        return "Present";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isClosed = item.statusText == 'C';
    final isHolidayOrWeekend = item.statusText == 'H' || item.statusText == 'W';

    final dayColor = isClosed
        ? Colors.red
        : isHolidayOrWeekend
            ? Colors.grey.shade600
            : UserColors.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: dayColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              Utils.formatDate(item.issueDate!,
                                  format: "dd MMM yyyy"),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: dayColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat("EEEE").format(item.issueDate!),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (item.employee! > 0)
                            _MealCountBox(
                              label: "Employee",
                              count: item.employee!,
                              color: UserColors.primaryColor,
                            ),
                          if (item.guest! > 0)
                            _MealCountBox(
                              label: "Guest",
                              count: item.guest!,
                              color: Colors.orange.shade600,
                            ),
                          if (isDriverVisible && item.driver! > 0)
                            _MealCountBox(
                              label: "Driver",
                              count: item.driver!,
                              color: Colors.green.shade600,
                            ),
                        ],
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: dayColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text(
                    _getStatusText(item.statusText!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _MealCountBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _MealCountBox({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: color.withOpacity(0.3))),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool isTotal;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 60),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isTotal ? color : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 14,
                color: isTotal ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
