import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../motion_preferences.dart';
import 'custom_calendar.dart';
import 'hotel_app_theme.dart';

class CalendarPopupView extends StatefulWidget {
  const CalendarPopupView({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onApplyClick,
    this.minimumDate,
    this.maximumDate,
    super.key,
  });

  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final void Function(DateTime, DateTime) onApplyClick;
  @override
  State<CalendarPopupView> createState() => _CalendarPopupViewState();
}

class _CalendarPopupViewState extends State<CalendarPopupView> with TickerProviderStateMixin {
  DateTime? _startDate;
  DateTime? _endDate;
  late final AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startEntranceAnimation(context, animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HotelAppTheme.build();
    final colors = theme.colorScheme;
    final opacityDuration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 100);
    final useStackedLayout = MediaQuery.sizeOf(context).width < 372 || MediaQuery.textScalerOf(context).scale(1) >= 2;
    final dialogInset = useStackedLayout ? 8.0 : 24.0;

    return Theme(
      data: theme,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(dialogInset),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, _) {
            return AnimatedOpacity(
              duration: opacityDuration,
              opacity: animationController.value,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final availableHeight = constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : MediaQuery.sizeOf(context).height;
                  final dialogHeight = useStackedLayout
                      ? availableHeight
                      : availableHeight.clamp(0.0, 640.0).toDouble();

                  return Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: dialogHeight,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHigh,
                          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: 0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SingleChildScrollView(
                                key: const ValueKey<String>('calendar-scroll-view'),
                                child: Column(
                                  children: <Widget>[
                                    _buildDateSummary(colors, stacked: useStackedLayout),
                                    const Divider(height: 1),
                                    CustomCalendarView(
                                      minimumDate: widget.minimumDate,
                                      maximumDate: widget.maximumDate,
                                      initialEndDate: widget.initialEndDate,
                                      initialStartDate: widget.initialStartDate,
                                      draftDateChange: (DateTime? start, DateTime? end) {
                                        setState(() {
                                          _startDate = start;
                                          _endDate = end;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _buildApplyButton(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateSummary(ColorScheme colors, {required bool stacked}) {
    if (stacked) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildStackedDateSummaryValue(colors, label: 'From', date: _startDate),
            const SizedBox(height: 12),
            _buildStackedDateSummaryValue(colors, label: 'To', date: _endDate),
          ],
        ),
      );
    }

    final from = _buildDateSummaryValue(colors, label: 'From', date: _startDate);
    final to = _buildDateSummaryValue(colors, label: 'To', date: _endDate);

    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: from),
          ),
        ),
        Container(height: 74, width: 1, color: colors.outlineVariant),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: to),
          ),
        ),
      ],
    );
  }

  Widget _buildStackedDateSummaryValue(ColorScheme colors, {required String label, required DateTime? date}) {
    final value = date == null ? 'Select date' : DateFormat('EEE, dd MMM').format(date);

    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildDateSummaryValue(ColorScheme colors, {required String label, required DateTime? date}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16, color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          date == null ? 'Select date' : DateFormat('EEE, dd MMM').format(date),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    final selectedStartDate = _startDate;
    final selectedEndDate = _endDate;
    final selectionIsValid = _selectionIsValid(selectedStartDate, selectedEndDate);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), shape: const StadiumBorder()),
          onPressed: !selectionIsValid
              ? null
              : () {
                  assert(selectedStartDate != null && selectedEndDate != null);
                  widget.onApplyClick(selectedStartDate!, selectedEndDate!);
                  Navigator.pop(context);
                },
          child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ),
      ),
    );
  }

  bool _selectionIsValid(DateTime? selectedStartDate, DateTime? selectedEndDate) {
    if (selectedStartDate == null || selectedEndDate == null) return false;

    final start = DateUtils.dateOnly(selectedStartDate);
    final end = DateUtils.dateOnly(selectedEndDate);
    final minimum = widget.minimumDate == null ? null : DateUtils.dateOnly(widget.minimumDate!);
    final maximum = widget.maximumDate == null ? null : DateUtils.dateOnly(widget.maximumDate!);

    return !end.isBefore(start) &&
        (minimum == null || !start.isBefore(minimum)) &&
        (maximum == null || !end.isAfter(maximum));
  }
}
