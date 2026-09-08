import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:templates/hotel_booking/calendar_popup_view.dart';
import 'package:templates/hotel_booking/custom_calendar.dart';
import 'package:templates/hotel_booking/hotel_app_theme.dart';
import 'package:templates/hotel_booking/hotel_list_view.dart';
import 'package:templates/hotel_booking/model/hotel_list_data.dart';

void main() {
  test('Hotel theme keeps mint surfaces and uses an accessible action foreground', () {
    final colors = HotelAppTheme.build().colorScheme;

    expect(colors.primary, HotelAppTheme.seedColor);
    expect(colors.primaryContainer, HotelAppTheme.rangeColor);
    expect(colors.secondary, HotelAppTheme.actionColor);
    expect(_contrastRatio(colors.secondary, colors.surface), greaterThanOrEqualTo(4.5));
    expect(_contrastRatio(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
  });

  testWidgets('calendar exposes an incomplete draft and cannot apply stale dates', (WidgetTester tester) async {
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 5);
    final initialEnd = DateTime(now.year, now.month, 10);
    final replacementEnd = DateTime(now.year, now.month, 20);
    DateTime? appliedStart;
    DateTime? appliedEnd;

    await _pumpHotelWidget(
      tester,
      CalendarPopupView(
        initialStartDate: initialStart,
        initialEndDate: initialEnd,
        onApplyClick: (DateTime start, DateTime end) {
          appliedStart = start;
          appliedEnd = end;
        },
      ),
    );

    await tester.tap(find.bySemanticsLabel(_fullDate(initialEnd)));
    await tester.pump();

    expect(find.text('Select date'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Apply')).onPressed, isNull);

    await tester.tap(find.bySemanticsLabel(_fullDate(replacementEnd)));
    await tester.pump();

    expect(find.text(DateFormat('EEE, dd MMM').format(replacementEnd)), findsOneWidget);
    final applyButton = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Apply'));
    expect(applyButton.onPressed, isNotNull);
    applyButton.onPressed!();
    await tester.pump();

    expect(appliedStart, initialStart);
    expect(appliedEnd, replacementEnd);
  });

  testWidgets('calendar rejects initial ranges outside its inclusive bounds', (WidgetTester tester) async {
    final now = DateTime.now();
    final minimumDate = DateTime(now.year, now.month, 5);
    final maximumDate = DateTime(now.year, now.month, 20);
    final cases = <({DateTime end, String key, DateTime replacement, DateTime start})>[
      (
        key: 'before-minimum',
        start: DateTime(now.year, now.month, 4),
        end: DateTime(now.year, now.month, 10),
        replacement: minimumDate,
      ),
      (
        key: 'after-maximum',
        start: DateTime(now.year, now.month, 10),
        end: DateTime(now.year, now.month, 21),
        replacement: maximumDate,
      ),
    ];

    for (final testCase in cases) {
      await _pumpHotelWidget(
        tester,
        CalendarPopupView(
          key: ValueKey<String>(testCase.key),
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          initialStartDate: testCase.start,
          initialEndDate: testCase.end,
          onApplyClick: (_, _) {},
        ),
      );

      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Apply')).onPressed, isNull);

      await tester.tap(find.bySemanticsLabel(_fullDate(testCase.replacement)));
      await tester.pump();

      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Apply')).onPressed, isNotNull);
    }
  });

  testWidgets('calendar rejects a reversed initial range and applies an ordered correction', (
    WidgetTester tester,
  ) async {
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 10);
    final initialEnd = DateTime(now.year, now.month, 9);
    final replacementEnd = DateTime(now.year, now.month, 12);
    DateTime? appliedStart;
    DateTime? appliedEnd;

    await _pumpHotelWidget(
      tester,
      CalendarPopupView(
        initialStartDate: initialStart,
        initialEndDate: initialEnd,
        onApplyClick: (DateTime start, DateTime end) {
          appliedStart = start;
          appliedEnd = end;
        },
      ),
    );

    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Apply')).onPressed, isNull);

    await tester.tap(find.bySemanticsLabel(_fullDate(replacementEnd)));
    await tester.pump();
    final applyButton = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Apply'));
    expect(applyButton.onPressed, isNotNull);
    applyButton.onPressed!();
    await tester.pump();

    expect(appliedStart, initialEnd);
    expect(appliedEnd, replacementEnd);
  });

  testWidgets('calendar opens on its selected month and bounds unavailable navigation', (WidgetTester tester) async {
    final now = DateTime.now();
    final selectedStart = DateTime(now.year, now.month + 2, 5);
    final selectedEnd = DateTime(now.year, now.month + 2, 10);
    final minimumDate = DateTime(selectedStart.year, selectedStart.month);
    final maximumDate = DateTime(selectedStart.year, selectedStart.month + 1, 0);

    await _pumpHotelWidget(
      tester,
      CustomCalendarView(
        initialStartDate: selectedStart,
        initialEndDate: selectedEnd,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
      ),
    );

    expect(find.text(DateFormat('MMMM, yyyy').format(selectedStart)), findsOneWidget);
    expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.keyboard_arrow_left)).onPressed, isNull);
    expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.keyboard_arrow_right)).onPressed, isNull);
  });

  testWidgets('calendar navigates to both bounded months and keeps boundary dates selectable', (
    WidgetTester tester,
  ) async {
    final now = DateTime.now();
    final minimumDate = DateTime(now.year, now.month, 5);
    final initialStart = DateTime(now.year, now.month + 1, 7);
    final initialEnd = DateTime(now.year, now.month + 1, 10);
    final maximumDate = DateTime(now.year, now.month + 2, 20);

    await _pumpHotelWidget(
      tester,
      CustomCalendarView(
        initialStartDate: initialStart,
        initialEndDate: initialEnd,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
      ),
    );

    final previousButton = find.widgetWithIcon(IconButton, Icons.keyboard_arrow_left);
    final nextButton = find.widgetWithIcon(IconButton, Icons.keyboard_arrow_right);
    expect(tester.widget<IconButton>(previousButton).onPressed, isNotNull);
    expect(tester.widget<IconButton>(nextButton).onPressed, isNotNull);

    await tester.tap(nextButton);
    await tester.pump();
    expect(find.text(DateFormat('MMMM, yyyy').format(maximumDate)), findsOneWidget);
    expect(tester.widget<IconButton>(nextButton).onPressed, isNull);
    expect(
      tester.getSemantics(find.bySemanticsLabel(_fullDate(maximumDate))).flagsCollection.isEnabled,
      Tristate.isTrue,
    );

    await tester.tap(previousButton);
    await tester.pump();
    await tester.tap(previousButton);
    await tester.pump();
    expect(find.text(DateFormat('MMMM, yyyy').format(minimumDate)), findsOneWidget);
    expect(tester.widget<IconButton>(previousButton).onPressed, isNull);
    expect(
      tester.getSemantics(find.bySemanticsLabel(_fullDate(minimumDate))).flagsCollection.isEnabled,
      Tristate.isTrue,
    );
  });

  testWidgets('calendar content stays open while the real modal barrier dismisses the route', (
    WidgetTester tester,
  ) async {
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 5);
    final initialEnd = DateTime(now.year, now.month, 10);

    await _pumpHotelWidget(
      tester,
      Builder(
        builder: (BuildContext context) => FilledButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => CalendarPopupView(
                initialStartDate: initialStart,
                initialEndDate: initialEnd,
                onApplyClick: (_, _) {},
              ),
            );
          },
          child: const Text('Open calendar'),
        ),
      ),
    );

    await tester.tap(find.text('Open calendar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('From'));
    await tester.pump();
    expect(find.byType(CalendarPopupView), findsOneWidget);

    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarPopupView), findsNothing);
  });

  testWidgets('compact large-text calendar keeps full-size dates and an anchored action', (WidgetTester tester) async {
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 5);
    final initialEnd = DateTime(now.year, now.month, 10);

    await _pumpHotelWidget(
      tester,
      CalendarPopupView(initialStartDate: initialStart, initialEndDate: initialEnd, onApplyClick: (_, _) {}),
      size: const Size(320, 568),
      textScale: 3.2,
    );

    expect(find.byKey(const ValueKey<String>('calendar-accessible-day-list')), findsOneWidget);
    expect(tester.getRect(find.byKey(_calendarDayKey(initialStart))).height, greaterThanOrEqualTo(48));
    expect(tester.getRect(find.widgetWithText(FilledButton, 'Apply')).bottom, lessThanOrEqualTo(568));
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar semantic actions select dates in both visual layouts', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 5);
    final initialEnd = DateTime(now.year, now.month, 10);
    final replacementEnd = DateTime(now.year, now.month, 15);
    final unavailable = DateTime(now.year, now.month, 25);

    for (final scenario in <({String key, Size size, double textScale})>[
      (key: 'grid', size: const Size(430, 932), textScale: 1),
      (key: 'accessible-list', size: const Size(320, 568), textScale: 3.2),
    ]) {
      DateTime? selectedStart;
      DateTime? selectedEnd;
      await _pumpHotelWidget(
        tester,
        SingleChildScrollView(
          child: CustomCalendarView(
            key: ValueKey<String>(scenario.key),
            minimumDate: DateTime(now.year, now.month, 1),
            maximumDate: DateTime(now.year, now.month, 20),
            initialStartDate: initialStart,
            initialEndDate: initialEnd,
            startEndDateChange: (DateTime start, DateTime end) {
              selectedStart = start;
              selectedEnd = end;
            },
          ),
        ),
        size: scenario.size,
        textScale: scenario.textScale,
      );

      tester.semantics.tap(find.semantics.byLabel(_fullDate(replacementEnd)));
      await tester.pump();

      expect(selectedStart, initialStart, reason: scenario.key);
      expect(selectedEnd, replacementEnd, reason: scenario.key);
      final unavailableSemantics = tester.getSemantics(find.bySemanticsLabel(_fullDate(unavailable)));
      expect(unavailableSemantics.getSemanticsData().hasAction(SemanticsAction.tap), isFalse, reason: scenario.key);
    }
    semantics.dispose();
  });

  testWidgets('calendar can start a fresh range and move an existing start earlier', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 5);
    final initialEnd = DateTime(now.year, now.month, 10);
    final replacementStart = DateTime(now.year, now.month, 12);
    final replacementEnd = DateTime(now.year, now.month, 15);
    DateTime? completedStart;
    DateTime? completedEnd;
    await _pumpHotelWidget(
      tester,
      CustomCalendarView(
        initialStartDate: initialStart,
        initialEndDate: initialEnd,
        startEndDateChange: (DateTime start, DateTime end) {
          completedStart = start;
          completedEnd = end;
        },
      ),
    );

    tester.semantics.tap(find.semantics.byLabel(_fullDate(initialEnd)));
    await tester.pump();
    tester.semantics.tap(find.semantics.byLabel(_fullDate(initialStart)));
    await tester.pump();
    tester.semantics.tap(find.semantics.byLabel(_fullDate(replacementStart)));
    await tester.pump();
    tester.semantics.tap(find.semantics.byLabel(_fullDate(replacementEnd)));
    await tester.pump();

    expect(completedStart, replacementStart);
    expect(completedEnd, replacementEnd);

    final earlierStart = DateTime(now.year, now.month, 3);
    await _pumpHotelWidget(
      tester,
      CustomCalendarView(
        key: const ValueKey<String>('move-start-earlier'),
        initialStartDate: initialStart,
        initialEndDate: initialEnd,
        startEndDateChange: (DateTime start, DateTime end) {
          completedStart = start;
          completedEnd = end;
        },
      ),
    );
    tester.semantics.tap(find.semantics.byLabel(_fullDate(earlierStart)));
    await tester.pump();

    expect(completedStart, earlierStart);
    expect(completedEnd, initialEnd);
    semantics.dispose();
  });

  testWidgets('hotel cards preserve ordinary phone geometry and expand accessibility text', (
    WidgetTester tester,
  ) async {
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);
    final hotel = HotelListData.samples.first;
    final card = HotelListView(
      hotelData: hotel,
      isFavorite: false,
      onFavoriteChanged: () {},
      animationController: controller,
      animation: controller,
    );

    await _pumpHotelWidget(tester, SingleChildScrollView(child: card));

    final normalDetailsLayout = find.ancestor(of: find.text(hotel.title), matching: find.byType(Flex));
    expect(find.text(hotel.location), findsOneWidget);
    expect(find.text('${hotel.distanceKm.toStringAsFixed(1)} km to city'), findsOneWidget);
    expect(tester.widget<Flex>(normalDetailsLayout).direction, Axis.horizontal);

    await _pumpHotelWidget(tester, SingleChildScrollView(child: card), size: const Size(320, 568), textScale: 3.2);

    final location = find.text('${hotel.location} · ${hotel.distanceKm.toStringAsFixed(1)} km to city');
    final detailsLayout = find.ancestor(of: location, matching: find.byType(Flex));
    final reviews = find.text(' ${hotel.reviews} Reviews');
    expect(tester.widget<Flex>(detailsLayout).direction, Axis.vertical);
    expect(tester.widget<Text>(location).maxLines, isNull);
    expect(tester.widget<Text>(location).overflow, TextOverflow.visible);
    expect(tester.widget<Text>(reviews).maxLines, isNull);
    expect(tester.widget<Text>(reviews).overflow, TextOverflow.visible);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpHotelWidget(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(430, 932),
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  final mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(disableAnimations: true, textScaler: TextScaler.linear(textScale));

  await tester.pumpWidget(
    MaterialApp(
      theme: HotelAppTheme.build(),
      home: MediaQuery(
        data: mediaQuery,
        child: Scaffold(body: child),
      ),
    ),
  );
  await tester.pump();
}

String _fullDate(DateTime date) => DateFormat('EEEE, d MMMM yyyy').format(date);

ValueKey<String> _calendarDayKey(DateTime date) {
  return ValueKey<String>('calendar-day-${DateFormat('yyyy-MM-dd').format(date)}');
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance >= secondLuminance ? firstLuminance : secondLuminance;
  final darker = firstLuminance >= secondLuminance ? secondLuminance : firstLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}
