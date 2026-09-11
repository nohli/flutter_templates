import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendarView extends StatefulWidget {
  const CustomCalendarView({
    required this.initialStartDate,
    required this.initialEndDate,
    this.startEndDateChange,
    this.draftDateChange,
    this.minimumDate,
    this.maximumDate,
    super.key,
  });

  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime initialStartDate;
  final DateTime initialEndDate;

  final void Function(DateTime, DateTime)? startEndDateChange;
  final void Function(DateTime? startDate, DateTime? endDate)? draftDateChange;

  @override
  State<CustomCalendarView> createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  final _visibleDates = <DateTime>[];
  late DateTime _visibleMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _visibleMonth = _initialVisibleMonth();
    _populateVisibleDates(_visibleMonth);
  }

  void _populateVisibleDates(DateTime monthDate) {
    _visibleDates.clear();
    final newDate = DateTime(monthDate.year, monthDate.month, 0);
    var leadingDays = 0;
    if (newDate.weekday < 7) {
      leadingDays = newDate.weekday;
      for (var i = 1; i <= leadingDays; i++) {
        _visibleDates.add(newDate.subtract(Duration(days: leadingDays - i)));
      }
    }
    for (var i = 0; i < (42 - leadingDays); i++) {
      _visibleDates.add(newDate.add(Duration(days: i + 1)));
    }
  }

  DateTime _initialVisibleMonth() {
    var visibleDate = DateUtils.dateOnly(widget.initialStartDate);
    final configuredMinimum = widget.minimumDate;
    final configuredMaximum = widget.maximumDate;
    final minimumDate = configuredMinimum == null ? null : DateUtils.dateOnly(configuredMinimum);
    final maximumDate = configuredMaximum == null ? null : DateUtils.dateOnly(configuredMaximum);

    if (minimumDate != null && visibleDate.isBefore(minimumDate)) {
      visibleDate = minimumDate;
    }
    if (maximumDate != null && visibleDate.isAfter(maximumDate)) {
      visibleDate = maximumDate;
    }

    return DateTime(visibleDate.year, visibleDate.month);
  }

  bool _monthHasSelectableDate(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final configuredMinimum = widget.minimumDate;
    final configuredMaximum = widget.maximumDate;
    final minimumDate = configuredMinimum == null ? null : DateUtils.dateOnly(configuredMinimum);
    final maximumDate = configuredMaximum == null ? null : DateUtils.dateOnly(configuredMaximum);

    return (minimumDate == null || !lastDay.isBefore(minimumDate)) &&
        (maximumDate == null || !firstDay.isAfter(maximumDate));
  }

  void _showMonth(DateTime month) {
    setState(() {
      _visibleMonth = DateTime(month.year, month.month);
      _populateVisibleDates(_visibleMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final useAccessibleList = MediaQuery.sizeOf(context).width < 372 || MediaQuery.textScalerOf(context).scale(1) >= 2;
    return Material(
      color: colors.surface,
      child: Column(
        children: <Widget>[
          _buildMonthHeader(colors),
          if (useAccessibleList)
            _buildAccessibleDaysList(colors)
          else ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
              child: Row(children: _buildWeekdayHeaders()),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Column(children: _buildCalendarRows()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthHeader(ColorScheme colors) {
    final previousMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    final nextMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    final canShowPreviousMonth = _monthHasSelectableDate(previousMonth);
    final canShowNextMonth = _monthHasSelectableDate(nextMonth);
    final useStackedHeader = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final previousButton = IconButton.outlined(
      tooltip: 'Previous month',
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      style: IconButton.styleFrom(foregroundColor: colors.onSurfaceVariant),
      onPressed: canShowPreviousMonth ? () => _showMonth(previousMonth) : null,
      icon: const Icon(Icons.keyboard_arrow_left),
    );
    final nextButton = IconButton.outlined(
      tooltip: 'Next month',
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      style: IconButton.styleFrom(foregroundColor: colors.onSurfaceVariant),
      onPressed: canShowNextMonth ? () => _showMonth(nextMonth) : null,
      icon: const Icon(Icons.keyboard_arrow_right),
    );
    final monthLabel = Semantics(
      label: DateFormat('MMMM yyyy').format(_visibleMonth),
      header: true,
      child: ExcludeSemantics(
        child: Text(
          DateFormat(useStackedHeader ? 'MMM yyyy' : 'MMMM, yyyy').format(_visibleMonth),
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: colors.onSurface),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: useStackedHeader
          ? Column(
              children: <Widget>[
                monthLabel,
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[previousButton, nextButton]),
              ],
            )
          : Row(
              children: <Widget>[
                previousButton,
                Expanded(child: Center(child: monthLabel)),
                nextButton,
              ],
            ),
    );
  }

  Widget _buildAccessibleDaysList(ColorScheme colors) {
    final monthDates = _visibleDates.where((DateTime date) {
      return date.year == _visibleMonth.year && date.month == _visibleMonth.month;
    });

    return Column(
      key: const ValueKey<String>('calendar-accessible-day-list'),
      children: monthDates
          .map((DateTime date) {
            final isSelectable = _isDateSelectable(date);
            final isSelected = _isRangeBoundary(date);
            final isInRange = _isInSelectedRange(date);
            final backgroundColor = isSelected
                ? colors.primary
                : isInRange
                ? colors.primaryContainer
                : Colors.transparent;
            final foregroundColor = isSelected
                ? colors.onPrimary
                : isInRange
                ? colors.onPrimaryContainer
                : isSelectable
                ? colors.onSurface
                : colors.onSurfaceVariant.withValues(alpha: 0.6);
            final semanticsLabel = DateFormat('EEEE, d MMMM yyyy').format(date);

            return Semantics(
              key: ValueKey<String>('calendar-day-${DateFormat('yyyy-MM-dd').format(date)}'),
              button: true,
              enabled: isSelectable,
              selected: isSelected,
              label: semanticsLabel,
              onTap: isSelectable ? () => _selectDate(date) : null,
              child: ExcludeSemantics(
                child: Material(
                  color: backgroundColor,
                  child: InkWell(
                    onTap: isSelectable ? () => _selectDate(date) : null,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                DateFormat('EEEE, d MMMM').format(date),
                                style: TextStyle(color: foregroundColor, fontSize: 16),
                              ),
                            ),
                            if (isSelected) Icon(Icons.check, color: foregroundColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }

  List<Widget> _buildWeekdayHeaders() {
    final colors = Theme.of(context).colorScheme;
    return List<Widget>.generate(7, (int weekdayIndex) {
      return Expanded(
        child: Center(
          child: Text(
            DateFormat('EEE').format(_visibleDates[weekdayIndex]),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.secondary),
          ),
        ),
      );
    });
  }

  List<Widget> _buildCalendarRows() {
    final colors = Theme.of(context).colorScheme;
    final today = DateUtils.dateOnly(DateTime.now());
    final weekCount = _visibleDates.length ~/ 7;

    return List<Widget>.generate(weekCount, (int weekIndex) {
      final cells = List<Widget>.generate(7, (int weekdayIndex) {
        final date = _visibleDates[weekIndex * 7 + weekdayIndex];
        final isSelectable = _isDateSelectable(date);
        final isSelected = _isRangeBoundary(date);
        final isInRange = _isInSelectedRange(date);
        final startsRange = _startsRangeSegment(date);
        final endsRange = _endsRangeSegment(date);
        final isToday = DateUtils.isSameDay(today, date);

        return Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(startsRange ? 4 : 0, 5, endsRange ? 4 : 0, 5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _startDate != null && _endDate != null && (isSelected || isInRange)
                            ? colors.primaryContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(
                          left: startsRange ? const Radius.circular(24) : Radius.zero,
                          right: endsRange ? const Radius.circular(24) : Radius.zero,
                        ),
                      ),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  enabled: isSelectable,
                  selected: isSelected,
                  label: DateFormat('EEEE, d MMMM yyyy').format(date),
                  onTap: isSelectable ? () => _selectDate(date) : null,
                  child: ExcludeSemantics(
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                      onTap: isSelectable ? () => _selectDate(date) : null,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? colors.primary : Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                            border: Border.all(color: isSelected ? colors.onPrimary : Colors.transparent, width: 2),
                            boxShadow: isSelected
                                ? <BoxShadow>[BoxShadow(color: colors.shadow.withValues(alpha: 0.4), blurRadius: 4)]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? colors.onPrimary
                                    : _visibleMonth.month == date.month
                                    ? colors.onSurface
                                    : colors.onSurfaceVariant,
                                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 9,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: isToday
                          ? isSelected
                                ? colors.onPrimary
                                : isInRange
                                ? colors.onPrimaryContainer
                                : colors.secondary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });

      return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: cells);
    });
  }

  bool _isDateSelectable(DateTime date) {
    final isCurrentMonth = _visibleMonth.month == date.month && _visibleMonth.year == date.year;
    if (!isCurrentMonth) return false;

    final minimumDate = widget.minimumDate;
    final maximumDate = widget.maximumDate;
    final isAfterMinimum = minimumDate == null || !date.isBefore(DateUtils.dateOnly(minimumDate));
    final isBeforeMaximum = maximumDate == null || !date.isAfter(DateUtils.dateOnly(maximumDate));

    return isAfterMinimum && isBeforeMaximum;
  }

  bool _isInSelectedRange(DateTime date) {
    final startDate = _startDate;
    final endDate = _endDate;

    return startDate != null && endDate != null && date.isAfter(startDate) && date.isBefore(endDate);
  }

  bool _isRangeBoundary(DateTime date) => DateUtils.isSameDay(_startDate, date) || DateUtils.isSameDay(_endDate, date);

  bool _startsRangeSegment(DateTime date) {
    if (DateUtils.isSameDay(_startDate, date)) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool _endsRangeSegment(DateTime date) {
    if (DateUtils.isSameDay(_endDate, date)) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (DateUtils.isSameDay(_startDate, date)) {
        _startDate = null;
      } else if (DateUtils.isSameDay(_endDate, date)) {
        _endDate = null;
      } else if (_startDate == null) {
        _startDate = date;
      } else {
        _endDate ??= date;
      }
      final hasOnlyEndDate = _startDate == null && _endDate != null;

      if (hasOnlyEndDate) {
        _startDate = _endDate;
        _endDate = null;
      }
      final selectedStartDate = _startDate;
      final selectedEndDate = _endDate;
      if (selectedStartDate != null && selectedEndDate != null) {
        var startDate = selectedStartDate;
        var endDate = selectedEndDate;
        if (!endDate.isAfter(startDate)) {
          final previousStartDate = startDate;
          startDate = endDate;
          endDate = previousStartDate;
        }
        if (date.isBefore(startDate)) {
          startDate = date;
        } else if (date.isAfter(endDate)) {
          endDate = date;
        } else {
          final daysToStartDate = startDate.difference(date).inDays.abs();
          final daysToEndDate = endDate.difference(date).inDays.abs();
          if (daysToStartDate > daysToEndDate) {
            endDate = date;
          } else {
            startDate = date;
          }
        }
        _startDate = startDate;
        _endDate = endDate;
      }
    });

    final selectedStartDate = _startDate;
    final selectedEndDate = _endDate;
    widget.draftDateChange?.call(selectedStartDate, selectedEndDate);
    if (selectedStartDate != null && selectedEndDate != null) {
      widget.startEndDateChange?.call(selectedStartDate, selectedEndDate);
    }
  }
}
