library date_range_picker;

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

enum DatePickerMode { day, year }

const Duration _kMonthScrollDuration = Duration(milliseconds: 200);
const double _kDayPickerRowHeight = 42.0;
const int _kMaxDayPickerRowCount = 6;

const double _kMaxDayPickerHeight =
    _kDayPickerRowHeight * (_kMaxDayPickerRowCount + 2);

const double _kMonthPickerPortraitWidth = 330.0;

class _DatePickerHeader extends StatelessWidget {
  const _DatePickerHeader({
    Key? key,
    required this.selectedFirstDate,
    this.selectedLastDate,
    required this.mode,
    required this.onModeChanged,
  }) : super(key: key);

  final DateTime selectedFirstDate;
  final DateTime? selectedLastDate;
  final DatePickerMode mode;
  final ValueChanged<DatePickerMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextTheme headerTextTheme = themeData.primaryTextTheme;
    Color? yearColor 
          =
            mode == DatePickerMode.year ? Colors.black87 : Colors.black54;
         
    final TextStyle yearStyle =
        headerTextTheme.subtitle1!.copyWith(color: yearColor, height: 1.4);

    Color? backgroundColor;
    switch (themeData.brightness) {
      case Brightness.light:
        backgroundColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        backgroundColor = themeData.backgroundColor;
        break;
    }

    Widget renderYearButton(date) {
      return IgnorePointer(
        ignoring: mode != DatePickerMode.day,
        ignoringSemantics: false,
        child: _DateHeaderButton(
          color: backgroundColor,
          child: Semantics(
              selected: mode == DatePickerMode.year,
              child: Text(localizations.formatYear(date), style: yearStyle)),
        ),
      );
    }

    Widget renderDayButton(date) {
      return IgnorePointer(
        ignoring: mode == DatePickerMode.day,
        ignoringSemantics: false,
        child: _DateHeaderButton(
          color: backgroundColor,
          child: Semantics(
              selected: mode == DatePickerMode.day,
              child: Text(
                localizations.formatMediumDate(date),
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              )),
        ),
      );
    }

    final Widget startHeader = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderYearButton(selectedFirstDate),
        renderDayButton(selectedFirstDate),
      ],
    );
    final Widget endHeader = selectedLastDate != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              renderYearButton(selectedLastDate),
              renderDayButton(selectedLastDate),
            ],
          )
        : Container();

    return Container(
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [startHeader, endHeader],
        ));
  }
}

class _DateHeaderButton extends StatelessWidget {
  const _DateHeaderButton({
    Key? key,
    this.onTap,
    this.color,
    this.child,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      type: MaterialType.button,
      color: color,
      child: InkWell(
        borderRadius: kMaterialEdges[MaterialType.button],
        highlightColor: theme.highlightColor,
        splashColor: theme.splashColor,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        ),
      ),
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double tileHeight = math.min(_kDayPickerRowHeight,
        constraints.viewportMainAxisExtent / (_kMaxDayPickerRowCount + 1));
    return SliverGridRegularTileLayout(
      crossAxisCount: columnCount,
      mainAxisStride: tileHeight,
      crossAxisStride: tileWidth,
      childMainAxisExtent: tileHeight,
      childCrossAxisExtent: tileWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _kDayPickerGridDelegate = _DayPickerGridDelegate();

class DayPicker extends StatelessWidget {
  const DayPicker({
    Key? key,
    required this.selectedFirstDate,
    this.selectedLastDate,
    required this.currentDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.displayedMonth,
    this.selectableDayPredicate,
  }) : super(key: key);

  final DateTime selectedFirstDate;
  final DateTime? selectedLastDate;

  final DateTime currentDate;
  final ValueChanged<List<DateTime?>> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime displayedMonth;
  final SelectableDayPredicate? selectableDayPredicate;
  List<Widget> _getDayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = [];
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(ExcludeSemantics(
        child: Center(child: Text(weekday, style: headerStyle)),
      ));
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) break;
    }
    return result;
  }

  static const List<int> _daysInMonth = <int>[
    31,
    -1,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) return 29;
      return 28;
    }
    return _daysInMonth[month - 1];
  }

  int _computeFirstDayOffset(
      int year, int month, MaterialLocalizations localizations) {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    final int firstDayOfWeekFromSunday = localizations.firstDayOfWeekIndex;

    final int firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;

    return (weekdayFromMonday - firstDayOfWeekFromMonday) % 7;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = getDaysInMonth(year, month);
    final int firstDayOffset =
        _computeFirstDayOffset(year, month, localizations);
    final List<Widget> labels = [];
    labels.addAll(_getDayHeaders(themeData.textTheme.caption, localizations));
    for (int i = 0; true; i += 1) {
      final int day = i - firstDayOffset + 1;
      if (day > daysInMonth) break;
      if (day < 1) {
        labels.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool disabled = dayToBuild.isAfter(lastDate) ||
            dayToBuild.isBefore(firstDate) ||
            (selectableDayPredicate != null &&
                !selectableDayPredicate!(dayToBuild));
        BoxDecoration? decoration;
        TextStyle? itemStyle = themeData.textTheme.bodyText1;
        final bool isSelectedFirstDay = selectedFirstDate.year == year &&
            selectedFirstDate.month == month &&
            selectedFirstDate.day == day;
        final bool? isSelectedLastDay = selectedLastDate != null
            ? (selectedLastDate!.year == year &&
                selectedLastDate!.month == month &&
                selectedLastDate!.day == day)
            : null;
        final bool? isInRange = selectedLastDate != null
            ? (dayToBuild.isBefore(selectedLastDate!) &&
                dayToBuild.isAfter(selectedFirstDate))
            : null;
        if (isSelectedFirstDay &&
            (isSelectedLastDay == null || isSelectedLastDay)) {
          itemStyle = themeData.textTheme.bodyText2;
          decoration = BoxDecoration(
              color: themeData.primaryColor, shape: BoxShape.circle);
        } else if (isSelectedFirstDay) {
          itemStyle = themeData.textTheme.bodyText2;
          decoration = BoxDecoration(
              color: themeData.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                bottomLeft: Radius.circular(50.0),
              ));
        } else if (isSelectedLastDay != null && isSelectedLastDay) {
          itemStyle = themeData.textTheme.bodyText2;
          decoration = BoxDecoration(
              color: themeData.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ));
        } else if (isInRange != null && isInRange) {
          decoration = BoxDecoration(
              color: themeData.colorScheme.secondary.withOpacity(0.1),
              shape: BoxShape.rectangle);
        } else if (disabled) {
          itemStyle = themeData.textTheme.bodyText1!
              .copyWith(color: themeData.disabledColor);
        } else if (currentDate.year == year &&
            currentDate.month == month &&
            currentDate.day == day) {
          itemStyle = themeData.textTheme.bodyText2!
              .copyWith(color: themeData.colorScheme.secondary);
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Semantics(
              label:
                  '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedFirstDay ||
                  isSelectedLastDay != null && isSelectedLastDay,
              child: ExcludeSemantics(
                child: Text(localizations.formatDecimal(day), style: itemStyle),
              ),
            ),
          ),
        );

        if (!disabled) {
          dayWidget = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              DateTime? first, last;
              if (selectedLastDate != null) {
                first = dayToBuild;
                last = null;
              } else {
                if (dayToBuild.compareTo(selectedFirstDate) <= 0) {
                  first = dayToBuild;
                  last = selectedFirstDate;
                } else {
                  first = selectedFirstDate;
                  last = dayToBuild;
                }
              }
              onChanged([first, last]);
            },
            child: dayWidget,
          );
        }

        labels.add(dayWidget);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SizedBox(
            height: _kDayPickerRowHeight,
            child: Center(
              child: ExcludeSemantics(
                child: Text(
                  localizations.formatMonthYear(displayedMonth),
                  style: themeData.textTheme.subtitle1,
                ),
              ),
            ),
          ),
          Flexible(
            child: GridView.custom(
              gridDelegate: _kDayPickerGridDelegate,
              childrenDelegate:
                  SliverChildListDelegate(labels, addRepaintBoundaries: false),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthPicker extends StatefulWidget {
  const MonthPicker({
    Key? key,
    required this.selectedFirstDate,
    this.selectedLastDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.selectableDayPredicate,
  }) : super(key: key);

  final DateTime selectedFirstDate;
  final DateTime? selectedLastDate;

  final ValueChanged<List<DateTime?>> onChanged;

  final DateTime firstDate;

  final DateTime lastDate;

  final SelectableDayPredicate? selectableDayPredicate;

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    int monthPage;
    if (widget.selectedLastDate == null) {
      monthPage = _monthDelta(widget.firstDate, widget.selectedFirstDate);
    } else {
      monthPage = _monthDelta(widget.firstDate, widget.selectedLastDate!);
    }
    _dayPickerController = PageController(initialPage: monthPage);
    _handleMonthPageChanged(monthPage);
    _updateCurrentDate();

    _chevronOpacityController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _chevronOpacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _chevronOpacityController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLastDate == null) {
      final int monthPage =
          _monthDelta(widget.firstDate, widget.selectedFirstDate);
      _dayPickerController = PageController(initialPage: monthPage);
      _handleMonthPageChanged(monthPage);
    } else if (oldWidget.selectedLastDate == null ||
        widget.selectedLastDate != oldWidget.selectedLastDate) {
      final int monthPage =
          _monthDelta(widget.firstDate, widget.selectedLastDate!);
      _dayPickerController = PageController(initialPage: monthPage);
      _handleMonthPageChanged(monthPage);
    }
  }

  late MaterialLocalizations localizations;
  late TextDirection textDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    textDirection = Directionality.of(context);
  }

  late DateTime _todayDate;
  late DateTime _currentDisplayedMonthDate;
  Timer? _timer;
  PageController? _dayPickerController;
  late AnimationController _chevronOpacityController;
  late Animation<double> _chevronOpacityAnimation;

  void _updateCurrentDate() {
    _todayDate = DateTime.now();
    final DateTime tomorrow =
        DateTime(_todayDate.year, _todayDate.month, _todayDate.day + 1);
    Duration timeUntilTomorrow = tomorrow.difference(_todayDate);
    timeUntilTomorrow += const Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer(timeUntilTomorrow, () {
      setState(() {
        _updateCurrentDate();
      });
    });
  }

  static int _monthDelta(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }

  DateTime _addMonthsToMonthDate(DateTime monthDate, int monthsToAdd) {
    return DateTime(
        monthDate.year + monthsToAdd ~/ 12, monthDate.month + monthsToAdd % 12);
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month = _addMonthsToMonthDate(widget.firstDate, index);
    return DayPicker(
      key: ValueKey<DateTime>(month),
      selectedFirstDate: widget.selectedFirstDate,
      selectedLastDate: widget.selectedLastDate,
      currentDate: _todayDate,
      onChanged: widget.onChanged,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  void _handleNextMonth() {
    if (!_isDisplayingLastMonth) {
      SemanticsService.announce(
          localizations.formatMonthYear(_nextMonthDate), textDirection);
      _dayPickerController!
          .nextPage(duration: _kMonthScrollDuration, curve: Curves.ease);
    }
  }

  void _handlePreviousMonth() {
    if (!_isDisplayingFirstMonth) {
      SemanticsService.announce(
          localizations.formatMonthYear(_previousMonthDate), textDirection);
      _dayPickerController!
          .previousPage(duration: _kMonthScrollDuration, curve: Curves.ease);
    }
  }

  bool get _isDisplayingFirstMonth {
    return !_currentDisplayedMonthDate
        .isAfter(DateTime(widget.firstDate.year, widget.firstDate.month));
  }

  bool get _isDisplayingLastMonth {
    return !_currentDisplayedMonthDate
        .isBefore(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  late DateTime _previousMonthDate;
  late DateTime _nextMonthDate;

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      _previousMonthDate =
          _addMonthsToMonthDate(widget.firstDate, monthPage - 1);
      _currentDisplayedMonthDate =
          _addMonthsToMonthDate(widget.firstDate, monthPage);
      _nextMonthDate = _addMonthsToMonthDate(widget.firstDate, monthPage + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kMonthPickerPortraitWidth,
      height: _kMaxDayPickerHeight,
      child: Stack(
        children: [
          Semantics(
            sortKey: _MonthPickerSortKey.calendar,
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (_) {
                _chevronOpacityController.forward();
                return false;
              },
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (_) {
                  _chevronOpacityController.reverse();
                  return false;
                },
                child: PageView.builder(
                  key: ValueKey<DateTime?>(widget.selectedFirstDate == null
                      ? widget.selectedFirstDate
                      : widget.selectedLastDate),
                  controller: _dayPickerController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _monthDelta(widget.firstDate, widget.lastDate) + 1,
                  itemBuilder: _buildItems,
                  onPageChanged: _handleMonthPageChanged,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0.0,
            start: 8.0,
            child: Semantics(
              sortKey: _MonthPickerSortKey.previousMonth,
              child: FadeTransition(
                opacity: _chevronOpacityAnimation,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  tooltip: _isDisplayingFirstMonth
                      ? null
                      : '${localizations.previousMonthTooltip} ${localizations.formatMonthYear(_previousMonthDate)}',
                  onPressed:
                      _isDisplayingFirstMonth ? null : _handlePreviousMonth,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 0.0,
            end: 8.0,
            child: Semantics(
              sortKey: _MonthPickerSortKey.nextMonth,
              child: FadeTransition(
                opacity: _chevronOpacityAnimation,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  tooltip: _isDisplayingLastMonth
                      ? null
                      : '${localizations.nextMonthTooltip} ${localizations.formatMonthYear(_nextMonthDate)}',
                  onPressed: _isDisplayingLastMonth ? null : _handleNextMonth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dayPickerController?.dispose();
    super.dispose();
  }
}

class _MonthPickerSortKey extends OrdinalSortKey {
  static const _MonthPickerSortKey previousMonth = _MonthPickerSortKey(1.0);
  static const _MonthPickerSortKey nextMonth = _MonthPickerSortKey(2.0);
  static const _MonthPickerSortKey calendar = _MonthPickerSortKey(3.0);

  const _MonthPickerSortKey(double order) : super(order);
}

class YearPicker extends StatefulWidget {
  YearPicker({
    Key? key,
    required this.selectedFirstDate,
    this.selectedLastDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
  })  : assert(!firstDate.isAfter(lastDate)),
        super(key: key);

  final DateTime selectedFirstDate;
  final DateTime? selectedLastDate;
  final ValueChanged<List<DateTime?>> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  static const double _itemExtent = 50.0;
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    int offset;
    if (widget.selectedLastDate != null) {
      offset = widget.lastDate.year - widget.selectedLastDate!.year;
    } else {
      offset = widget.selectedFirstDate.year - widget.firstDate.year;
    }
    scrollController = ScrollController(
      initialScrollOffset: offset * _itemExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle? style = themeData.textTheme.bodyText1;
    return ListView.builder(
      controller: scrollController,
      itemExtent: _itemExtent,
      itemCount: widget.lastDate.year - widget.firstDate.year + 1,
      itemBuilder: (BuildContext context, int index) {
        final int year = widget.firstDate.year + index;
        final bool isSelected = year == widget.selectedFirstDate.year ||
            (widget.selectedLastDate != null &&
                year == widget.selectedLastDate!.year);
        final TextStyle? itemStyle = isSelected
            ? themeData.textTheme.headline1!
                .copyWith(color: themeData.primaryColor)
            : style;
        return InkWell(
          key: ValueKey<int>(year),
          onTap: () {
            List<DateTime?> changes;
            if (widget.selectedLastDate == null) {
              DateTime newDate = DateTime(year, widget.selectedFirstDate.month,
                  widget.selectedFirstDate.day);
              changes = [newDate, newDate];
            } else {
              changes = [
                DateTime(year, widget.selectedFirstDate.month,
                    widget.selectedFirstDate.day),
                null
              ];
            }
            widget.onChanged(changes);
          },
          child: Center(
            child: Semantics(
              selected: isSelected,
              child: Text(year.toString(), style: itemStyle),
            ),
          ),
        );
      },
    );
  }
}

class _DatePickerDialog extends StatefulWidget {
  const _DatePickerDialog({
    Key? key,
    this.initialFirstDate,
    this.initialLastDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.initialDatePickerMode,
  }) : super(key: key);

  final DateTime? initialFirstDate;
  final DateTime? initialLastDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final SelectableDayPredicate? selectableDayPredicate;
  final DatePickerMode? initialDatePickerMode;

  @override
  _DatePickerDialogState createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  @override
  void initState() {
    super.initState();
    _selectedFirstDate = widget.initialFirstDate;
    _selectedLastDate = widget.initialLastDate;
    _mode = widget.initialDatePickerMode;
  }

  bool _announcedInitialDate = false;

  late MaterialLocalizations localizations;
  late TextDirection textDirection;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    textDirection = Directionality.of(context);
    if (!_announcedInitialDate) {
      _announcedInitialDate = true;
      SemanticsService.announce(
        localizations.formatFullDate(_selectedFirstDate!),
        textDirection,
      );
      if (_selectedLastDate != null) {
        SemanticsService.announce(
          localizations.formatFullDate(_selectedLastDate!),
          textDirection,
        );
      }
    }
  }

  DateTime? _selectedFirstDate;
  DateTime? _selectedLastDate;
  DatePickerMode? _mode;
  final GlobalKey _pickerKey = GlobalKey();

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
        break;
      case TargetPlatform.linux:
        break;
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        break;
    }
  }

  void _handleModeChanged(DatePickerMode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_mode == DatePickerMode.day) {
        SemanticsService.announce(
            localizations.formatMonthYear(_selectedFirstDate!), textDirection);
        if (_selectedLastDate != null) {
          SemanticsService.announce(
              localizations.formatMonthYear(_selectedLastDate!), textDirection);
        }
      } else {
        SemanticsService.announce(
            localizations.formatYear(_selectedFirstDate!), textDirection);
        if (_selectedLastDate != null) {
          SemanticsService.announce(
              localizations.formatYear(_selectedLastDate!), textDirection);
        }
      }
    });
  }

  void _handleYearChanged(List<DateTime?> changes) {
    assert(changes.length == 2);
    _vibrate();
    setState(() {
      _mode = DatePickerMode.day;
      _selectedFirstDate = changes[0];
      _selectedLastDate = changes[1];
    });
  }

  void _handleDayChanged(List<DateTime?> changes) {
    assert(changes.length == 2);
    _vibrate();
    setState(() {
      _selectedFirstDate = changes[0];
      _selectedLastDate = changes[1];
    });
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    List<DateTime> result = [];
    if (_selectedFirstDate != null) {
      result.add(_selectedFirstDate!);
      if (_selectedLastDate != null) {
        result.add(_selectedLastDate!);
      }
    }
    Navigator.pop(context, result);
  }

  Widget? _buildPicker() {
    switch (_mode!) {
      case DatePickerMode.day:
        return MonthPicker(
          key: _pickerKey,
          selectedFirstDate: _selectedFirstDate!,
          selectedLastDate: _selectedLastDate,
          onChanged: _handleDayChanged,
          firstDate: widget.firstDate!,
          lastDate: widget.lastDate!,
          selectableDayPredicate: widget.selectableDayPredicate,
        );
      case DatePickerMode.year:
        return YearPicker(
          key: _pickerKey,
          selectedFirstDate: _selectedFirstDate!,
          selectedLastDate: _selectedLastDate,
          onChanged: _handleYearChanged,
          firstDate: widget.firstDate!,
          lastDate: widget.lastDate!,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget picker = Flexible(
      child: SizedBox(
        height: _kMaxDayPickerHeight,
        child: _buildPicker(),
      ),
    );
    final Widget actions = ButtonBarTheme(
      data: const ButtonBarThemeData(),
      child: ButtonBar(
        children: [
          TextButton(
            child: const Text("CANCEL"),
            onPressed: _handleCancel,
          ),
          TextButton(
            child: const Text("APPLY"),
            onPressed: _handleOk,
          ),
        ],
      ),
    );
    final Dialog dialog = Dialog(
      child: Builder(
        builder: (BuildContext context) {
          final Widget header = _DatePickerHeader(
            selectedFirstDate: _selectedFirstDate!,
            selectedLastDate: _selectedLastDate,
            mode: _mode!,
            onModeChanged: _handleModeChanged,
          );

          return SizedBox(
            width: _kMonthPickerPortraitWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    child: header),
                Container(
                  decoration: BoxDecoration(
                      color: theme.dialogBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      picker,
                      actions,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return Theme(
      data: theme.copyWith(
        dialogBackgroundColor: Colors.transparent,
      ),
      child: dialog,
    );
  }
}

typedef SelectableDayPredicate = bool Function(DateTime day);

Future<List<DateTime>?> showDatePicker({
  required BuildContext context,
  required DateTime initialFirstDate,
  required DateTime initialLastDate,
  required DateTime firstDate,
  required DateTime lastDate,
  SelectableDayPredicate? selectableDayPredicate,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  Locale? locale,
  TextDirection? textDirection,
}) async {
  Widget child = _DatePickerDialog(
    initialFirstDate: initialFirstDate,
    initialLastDate: initialLastDate,
    firstDate: firstDate,
    lastDate: lastDate,
    selectableDayPredicate: selectableDayPredicate,
    initialDatePickerMode: initialDatePickerMode,
  );

  if (textDirection != null) {
    child = Directionality(
      textDirection: textDirection,
      child: child,
    );
  }

  if (locale != null) {
    child = Localizations.override(
      context: context,
      locale: locale,
      child: child,
    );
  }

  return await showDialog<List<DateTime>>(
    context: context,
    builder: (BuildContext context) => child,
  );
}
