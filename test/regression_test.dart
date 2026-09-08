import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:templates/about_screen.dart';
import 'package:templates/app_drawer.dart';
import 'package:templates/app_shell.dart';
import 'package:templates/app_identity.dart';
import 'package:templates/design_course/course_info_screen.dart';
import 'package:templates/design_course/design_course_app_theme.dart';
import 'package:templates/design_course/home_design_course.dart';
import 'package:templates/design_course/models/category.dart';
import 'package:templates/feedback_screen.dart';
import 'package:templates/fitness_app/bottom_navigation_view/bottom_bar_view.dart';
import 'package:templates/fitness_app/fitness_app_home_screen.dart';
import 'package:templates/fitness_app/fitness_app_theme.dart';
import 'package:templates/fitness_app/training/training_screen.dart';
import 'package:templates/fitness_app/ui_view/area_list_view.dart';
import 'package:templates/fitness_app/ui_view/glass_view.dart';
import 'package:templates/fitness_app/ui_view/workout_view.dart';
import 'package:templates/help_screen.dart';
import 'package:templates/home_screen.dart';
import 'package:templates/hotel_booking/calendar_popup_view.dart';
import 'package:templates/hotel_booking/custom_calendar.dart';
import 'package:templates/hotel_booking/filters_screen.dart';
import 'package:templates/hotel_booking/hotel_home_screen.dart';
import 'package:templates/hotel_booking/hotel_list_view.dart';
import 'package:templates/hotel_booking/model/hotel_list_data.dart';
import 'package:templates/hotel_booking/range_slider_view.dart';
import 'package:templates/hotel_booking/slider_view.dart';
import 'package:templates/hotel_booking/smooth_star_rating.dart';
import 'package:templates/invite_friend_screen.dart';
import 'package:templates/main.dart' as app;

void main() {
  testWidgets('root app uses the adaptive shell', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    app.main();
    await tester.pump();

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.useMaterial3, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('local template content is present on the first rendered frame', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/design_course/interFace1.png',
      'assets/design_course/interFace2.png',
      'assets/design_course/interFace3.png',
      'assets/design_course/interFace4.png',
      'assets/design_course/userImage.png',
      'assets/fitness_app/eaten.png',
      'assets/fitness_app/burned.png',
      'assets/fitness_app/breakfast.png',
      'assets/fitness_app/tab_1.png',
      'assets/fitness_app/tab_1s.png',
      'assets/fitness_app/tab_2.png',
      'assets/fitness_app/tab_2s.png',
      'assets/fitness_app/tab_3.png',
      'assets/fitness_app/tab_3s.png',
      'assets/fitness_app/tab_4.png',
      'assets/fitness_app/tab_4s.png',
    ]);
    await _pumpScreen(tester, const DesignCourseHomeScreen());

    expect(find.text('User Interface Design'), findsOneWidget);
    expect(find.text('App Design Course'), findsWidgets);

    await _pumpScreen(tester, const FitnessAppHomeScreen());

    expect(find.text('My Diary'), findsOneWidget);
    expect(find.text('Mediterranean diet'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Training').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    await tester.pump();

    expect(find.text('Training'), findsWidgets);
    expect(find.text('Your program'), findsOneWidget);

    await _pumpScreen(tester, const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('course details and staged actions render without layout errors', (WidgetTester tester) async {
    _evictAssets(<String>['assets/design_course/interFace4.png']);
    await _pumpScreen(tester, CourseInfoScreen(course: Category.popularCourseList[1]));

    expect(find.text('Web Design Course'), findsOneWidget);
    expect(find.text('Preview only — enrollment is not available.'), findsOneWidget);
    expect(find.text('Join Course'), findsNothing);

    await tester.pump(const Duration(milliseconds: 650));
    expect(find.text('28'), findsOneWidget);
    expect(find.text('24'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('2 hours'), findsOneWidget);
    expect(tester.getRect(find.byTooltip('Back')).left, greaterThanOrEqualTo(8));
    expect(tester.takeException(), isNull);

    await _pumpScreen(tester, const SizedBox());
  });

  testWidgets('course selection opens the matching sample details', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/design_course/interFace1.png',
      'assets/design_course/interFace2.png',
      'assets/design_course/interFace3.png',
      'assets/design_course/interFace4.png',
      'assets/design_course/userImage.png',
    ]);
    await _pumpScreen(tester, const DesignCourseHomeScreen(), disableAnimations: true);

    await tester.tap(find.bySemanticsLabel(RegExp(r'^Open Web Design Course sample course,')).first);
    await tester.pumpAndSettle();

    expect(find.byType(CourseInfoScreen), findsOneWidget);
    expect(find.text('Web Design Course'), findsOneWidget);
    expect(find.text('\$208'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('28'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('featured course selection opens the exact tapped sample', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/design_course/interFace1.png',
      'assets/design_course/interFace2.png',
      'assets/design_course/interFace3.png',
      'assets/design_course/interFace4.png',
      'assets/design_course/userImage.png',
    ]);
    await _pumpScreen(tester, const DesignCourseHomeScreen(), disableAnimations: true);

    final secondFeaturedCourse = find.bySemanticsLabel(
      RegExp(r'^Open User Experience Research sample course, 22 lessons,'),
    );
    await tester.ensureVisible(secondFeaturedCourse);
    await tester.pump();
    await tester.tap(secondFeaturedCourse);
    await tester.pumpAndSettle();

    expect(find.byType(CourseInfoScreen), findsOneWidget);
    expect(find.text('User Experience Research'), findsOneWidget);
    expect(find.text('\$18'), findsOneWidget);
    expect(find.text('4.6'), findsOneWidget);
    expect(find.text('22'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('water reminder card follows its supplied animation', (WidgetTester tester) async {
    _evictAssets(<String>['assets/fitness_app/glass.png']);
    final controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: tester);
    addTearDown(controller.dispose);

    await _pumpScreen(tester, GlassView(animationController: controller, animation: controller));
    controller.value = 1;
    await tester.pump();

    expect(find.text('Prepare your stomach for lunch with one or two glass of water'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar updates and applies a newly selected end date', (WidgetTester tester) async {
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 5);
    final initialEnd = DateTime(now.year, now.month, 10);
    final selectedEnd = DateTime(now.year, now.month, 20);
    DateTime? appliedStart;
    DateTime? appliedEnd;

    await _pumpScreen(
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

    await tester.tap(find.text('${selectedEnd.day}'));
    await tester.pump();

    expect(find.text(DateFormat('EEE, dd MMM').format(selectedEnd)), findsOneWidget);

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(appliedStart, initialStart);
    expect(appliedEnd, selectedEnd);
    expect(tester.takeException(), isNull);
  });

  testWidgets('calendar distinguishes matching days from different years', (WidgetTester tester) async {
    final now = DateTime.now();
    final previousStart = DateTime(now.year - 1, now.month, 5);
    final previousEnd = DateTime(now.year - 1, now.month, 10);
    DateTime? selectedStart;
    DateTime? selectedEnd;

    await _pumpScreen(
      tester,
      CustomCalendarView(
        initialStartDate: previousStart,
        initialEndDate: previousEnd,
        startEndDateChange: (DateTime start, DateTime end) {
          selectedStart = start;
          selectedEnd = end;
        },
      ),
    );

    for (var month = 0; month < 12; month += 1) {
      await tester.tap(find.widgetWithIcon(IconButton, Icons.keyboard_arrow_right));
      await tester.pump();
    }
    final matchingCurrentDate = find.bySemanticsLabel(
      DateFormat('EEEE, d MMMM yyyy').format(DateTime(now.year, now.month, 5)),
    );
    await tester.tap(matchingCurrentDate);
    await tester.pump();

    expect(selectedStart, previousStart);
    expect(selectedEnd, DateTime(now.year, now.month, 5));
  });

  testWidgets('calendar compares selected days independently of their time', (WidgetTester tester) async {
    final now = DateTime.now();
    final initialStart = DateTime(now.year, now.month, 5, 9);
    final initialEnd = DateTime(now.year, now.month, 10, 18);
    var completedRanges = 0;

    await _pumpScreen(
      tester,
      CustomCalendarView(
        initialStartDate: initialStart,
        initialEndDate: initialEnd,
        startEndDateChange: (_, _) => completedRanges += 1,
      ),
    );

    await tester.tap(find.text('${initialStart.day}').first);
    await tester.pump();
    await tester.tap(find.text('${initialEnd.day}').first);
    await tester.pump();

    expect(completedRanges, 0);
  });

  testWidgets('filter edits do not mutate the defaults of a fresh screen', (WidgetTester tester) async {
    await _pumpScreen(tester, const FiltersScreen());

    Finder freeBreakfastControl() => find.widgetWithText(CheckboxListTile, 'Free Breakfast');

    expect(tester.widget<CheckboxListTile>(freeBreakfastControl()).value, isFalse);
    await tester.tap(find.text('Free Breakfast'));
    await tester.pump();
    expect(tester.widget<CheckboxListTile>(freeBreakfastControl()).value, isTrue);

    await _pumpScreen(tester, const FiltersScreen(key: ValueKey<String>('fresh-filters')));

    expect(tester.widget<CheckboxListTile>(freeBreakfastControl()).value, isFalse);
  });

  testWidgets('drawer restores the original avatar without fake account actions', (WidgetTester tester) async {
    await _pumpScreen(tester, const AppShell());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    final Finder avatar = find.descendant(
      of: find.byType(AppDrawer),
      matching: find.byWidgetPredicate(
        (Widget widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/userImage.png',
      ),
    );
    expect(avatar, findsOneWidget);
    expect(find.descendant(of: find.byType(AppDrawer), matching: find.text('Shaquille Oatmeal')), findsOneWidget);
    expect(find.byTooltip('Close navigation menu'), findsOneWidget);
    expect(find.text('Sign Out'), findsNothing);

    await tester.tap(find.text('Feedback'));
    await tester.pumpAndSettle();
    expect(find.text('Your Feedback'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);

    await _pumpScreen(tester, const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('drawer opens every app section', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
      'assets/images/helpImage.png',
      'assets/images/inviteImage.png',
    ]);
    await _pumpScreen(tester, const AppShell());

    for (final (String destination, String content) in <(String, String)>[
      ('Help', 'How can we help you?'),
      ('Invite friends', 'Invite Your Friends'),
      ('About', 'Open source'),
    ]) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(destination));
      await tester.pumpAndSettle();
      expect(find.text(content), findsOneWidget);
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('home templates and layout control expose accessible labels', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(tester, const AppShell());

    expect(find.bySemanticsLabel('Hotel Booking'), findsOneWidget);
    expect(find.bySemanticsLabel('Fitness App'), findsOneWidget);
    expect(find.bySemanticsLabel('Design Course'), findsOneWidget);
    expect(find.byTooltip('Show one column'), findsOneWidget);
    final Finder homeTitle = find.descendant(of: find.byType(MyHomePage), matching: find.text(AppIdentity.name));
    final Rect initialTitleBounds = tester.getRect(homeTitle);
    expect(initialTitleBounds.top, greaterThanOrEqualTo(0));

    await tester.tap(find.byTooltip('Show one column'));
    await tester.pump();

    expect(find.byTooltip('Show multiple columns'), findsOneWidget);
    expect(tester.getRect(homeTitle), initialTitleBounds);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Help'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Show multiple columns'), findsOneWidget);
    expect(
      (tester.widget<GridView>(find.byType(GridView)).gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
          .crossAxisCount,
      1,
    );
  });

  testWidgets('every gallery card opens its declared template at the original text scale', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(tester, const MyHomePage(), textScale: 2, disableAnimations: true);

    for (final scenario in <({Type destination, String title})>[
      (title: 'Hotel Booking', destination: HotelHomeScreen),
      (title: 'Fitness App', destination: FitnessAppHomeScreen),
      (title: 'Design Course', destination: DesignCourseHomeScreen),
    ]) {
      await tester.tap(find.bySemanticsLabel(scenario.title));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(scenario.destination), findsOneWidget, reason: scenario.title);
      expect(
        MediaQuery.textScalerOf(tester.element(find.byType(scenario.destination))).scale(1),
        1,
        reason: scenario.title,
      );
      Navigator.of(tester.element(find.byType(scenario.destination))).pop();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('template detail routes keep the original text scale', (WidgetTester tester) async {
    await _pumpScreen(tester, const MyHomePage(), textScale: 2, disableAnimations: true);

    await tester.tap(find.bySemanticsLabel('Design Course'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel(RegExp(r'^Open User Interface Design sample course,')).first);
    await tester.pumpAndSettle();

    expect(MediaQuery.textScalerOf(tester.element(find.byType(CourseInfoScreen))).scale(1), 1);

    Navigator.of(tester.element(find.byType(CourseInfoScreen))).pop();
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(DesignCourseHomeScreen))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Hotel Booking'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();

    expect(MediaQuery.textScalerOf(tester.element(find.byType(FiltersScreen))).scale(1), 1);

    Navigator.of(tester.element(find.byType(FiltersScreen))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose date'));
    await tester.pumpAndSettle();

    expect(MediaQuery.textScalerOf(tester.element(find.byType(CalendarPopupView))).scale(1), 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home template grid uses all three columns on tablet widths', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(tester, const MyHomePage(), disableAnimations: true);

    expect(
      (tester.widget<GridView>(find.byType(GridView)).gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
          .crossAxisCount,
      2,
    );

    await _pumpScreen(tester, const MyHomePage(), size: const Size(1024, 1366), disableAnimations: true);

    expect(
      (tester.widget<GridView>(find.byType(GridView)).gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
          .crossAxisCount,
      3,
    );
  });

  testWidgets('featured course artwork never covers its title', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/design_course/interFace1.png',
      'assets/design_course/interFace2.png',
      'assets/design_course/interFace3.png',
      'assets/design_course/interFace4.png',
      'assets/design_course/userImage.png',
    ]);
    await _pumpScreen(tester, const DesignCourseHomeScreen(), size: const Size(402, 874), disableAnimations: true);

    final Finder firstCourseImage = find
        .byWidgetPredicate(
          (Widget widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == 'assets/design_course/interFace1.png',
        )
        .first;
    final Rect imageBounds = tester.getRect(firstCourseImage);
    final Rect titleBounds = tester.getRect(find.text('User Interface Design').first);
    final Rect featuredCardBounds = tester.getRect(
      find.bySemanticsLabel(RegExp(r'^Open User Interface Design sample course,')).first,
    );
    final Rect popularCardBounds = tester.getRect(
      find.bySemanticsLabel(RegExp(r'^Open App Design Course sample course,')).first,
    );

    expect(featuredCardBounds.width, closeTo(280, 0.01));
    expect(featuredCardBounds.height, closeTo(134, 0.01));
    expect(imageBounds.size, const Size(86, 86));
    expect(titleBounds.left, greaterThanOrEqualTo(imageBounds.right + 8));
    expect(popularCardBounds.width / popularCardBounds.height, closeTo(0.8, 0.01));
    expect(
      find.descendant(
        of: find.bySemanticsLabel(RegExp(r'^Open User Interface Design sample course,')).first,
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is DecoratedBox &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == DesignCourseAppTheme.cardBackground,
        ),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.add), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('fitness templates preserve the original normal-size composition', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/fitness_app/eaten.png',
      'assets/fitness_app/burned.png',
      'assets/fitness_app/breakfast.png',
      'assets/fitness_app/runner.png',
      'assets/fitness_app/back.png',
      'assets/fitness_app/area1.png',
      'assets/fitness_app/area2.png',
      'assets/fitness_app/area3.png',
      'assets/fitness_app/tab_1.png',
      'assets/fitness_app/tab_1s.png',
      'assets/fitness_app/tab_2.png',
      'assets/fitness_app/tab_2s.png',
      'assets/fitness_app/tab_3.png',
      'assets/fitness_app/tab_3s.png',
      'assets/fitness_app/tab_4.png',
      'assets/fitness_app/tab_4s.png',
    ]);
    await _pumpScreen(tester, const FitnessAppHomeScreen(), size: const Size(402, 874), disableAnimations: true);

    final diaryTitleSurface = find.ancestor(
      of: find.text('Mediterranean diet'),
      matching: find.byWidgetPredicate(
        (Widget widget) => widget is Material && widget.color == FitnessAppTheme.background,
      ),
    );
    expect(diaryTitleSurface, findsWidgets);
    expect(find.text('15 May'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.bySemanticsLabel('Training').first);
    await tester.pump();

    final workout = find.byType(WorkoutView);
    final playIcon = find.descendant(of: workout, matching: find.byIcon(Icons.arrow_right));
    expect(tester.getCenter(playIcon).dx, greaterThan(300));
    expect(find.byIcon(Icons.arrow_forward), findsAtLeastNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('fitness content scrolls fully clear of its navigation bar', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/fitness_app/eaten.png',
      'assets/fitness_app/burned.png',
      'assets/fitness_app/breakfast.png',
      'assets/fitness_app/glass.png',
      'assets/fitness_app/tab_1.png',
      'assets/fitness_app/tab_1s.png',
      'assets/fitness_app/tab_2.png',
      'assets/fitness_app/tab_2s.png',
      'assets/fitness_app/tab_3.png',
      'assets/fitness_app/tab_3s.png',
      'assets/fitness_app/tab_4.png',
      'assets/fitness_app/tab_4s.png',
    ]);
    await _pumpScreen(tester, const FitnessAppHomeScreen(), disableAnimations: true);

    final Finder verticalScrollable = find
        .byWidgetPredicate((Widget widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down)
        .first;
    await tester.drag(verticalScrollable, const Offset(0, -5000));
    await tester.pumpAndSettle();

    final Finder reminder = find.text('Prepare your stomach for lunch with one or two glass of water');
    expect(reminder, findsOneWidget);
    expect(tester.getRect(reminder).bottom, lessThan(tester.getRect(find.byType(BottomBarView)).top));

    await tester.tap(find.bySemanticsLabel('Training').first);
    await tester.pump();
    final Finder trainingScrollable = find
        .descendant(
          of: find.byType(TrainingScreen),
          matching: find.byWidgetPredicate(
            (Widget widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
          ),
        )
        .first;
    final ScrollableState trainingScrollState = tester.state<ScrollableState>(trainingScrollable);
    trainingScrollState.position.jumpTo(trainingScrollState.position.maxScrollExtent);
    await tester.pump();

    expect(find.byType(AreaListView), findsOneWidget);
    expect(tester.getRect(find.byType(AreaListView)).bottom, lessThan(tester.getRect(find.byType(BottomBarView)).top));
    expect(tester.takeException(), isNull);
  });

  testWidgets('app navigation remains usable at maximum text size', (WidgetTester tester) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(tester, const AppShell(), size: const Size(320, 568), textScale: 3.2, disableAnimations: true);

    final Finder galleryTitle = find.descendant(of: find.byType(MyHomePage), matching: find.text(AppIdentity.name));
    expect(galleryTitle, findsOneWidget);
    _expectFullTextHeight(tester, galleryTitle);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Close navigation menu'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final Finder drawerScrollable = find.descendant(of: find.byType(AppDrawer), matching: find.byType(Scrollable));
    await tester.dragUntilVisible(find.text('Invite friends'), drawerScrollable, const Offset(0, -100));
    await tester.ensureVisible(find.text('Invite friends'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.text('Invite friends'), findsOneWidget);
    expect(tester.getCenter(find.text('Invite friends')).dy, lessThan(568));
    _expectFullTextHeight(tester, find.text('Invite friends'));
    final Rect inviteLabelBounds = tester.getRect(find.text('Invite friends'));
    final Rect inviteItemBounds = tester.getRect(find.bySemanticsLabel('Invite friends'));
    expect(inviteItemBounds.top, lessThanOrEqualTo(inviteLabelBounds.top));
    expect(inviteItemBounds.bottom, greaterThanOrEqualTo(inviteLabelBounds.bottom));
    await tester.tap(find.text('Invite friends'));
    await tester.pumpAndSettle();
    expect(find.text('Invite Your Friends'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    expect(find.semantics.byLabel('Navigation menu'), findsNothing);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('drawer exposes selected semantics and closes on the system back action', (WidgetTester tester) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(tester, const AppShell(), disableAnimations: true);

    expect(find.bySemanticsLabel('Hotel Booking'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.semantics.byLabel('Navigation menu'), findsOneWidget);
    expect(find.semantics.byLabel('Close navigation menu'), findsOneWidget);
    expect(find.semantics.byLabel('Hotel Booking'), findsNothing);
    final SemanticsNode homeNode = tester.getSemantics(find.bySemanticsLabel('Home'));
    expect(homeNode.flagsCollection.isSelected, Tristate.isTrue);
    expect(homeNode.flagsCollection.isButton, isTrue);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.semantics.byLabel('Navigation menu'), findsNothing);
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    expect(find.semantics.byLabel('Hotel Booking'), findsOneWidget);
    expect(find.byType(AppShell), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('drawer releases settle by position and deliberate fling direction', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(tester, const AppShell());
    final Offset dragStart = tester.getBottomLeft(find.byType(AppShell)) + const Offset(24, -100);
    final Finder galleryTitle = find.descendant(of: find.byType(MyHomePage), matching: find.text(AppIdentity.name));
    final double closedTitleLeft = tester.getTopLeft(galleryTitle).dx;
    final double drawerWidth = tester.getSize(find.byType(AppShell)).width * 0.75;

    await tester.timedDragFrom(dragStart, const Offset(80, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);

    await tester.timedDragFrom(dragStart, const Offset(200, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Close navigation menu'), findsOneWidget);

    await tester.tap(find.byTooltip('Close navigation menu'));
    await tester.pumpAndSettle();
    await tester.flingFrom(dragStart, const Offset(60, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Close navigation menu'), findsOneWidget);

    final openDragStart = Offset(drawerWidth + 40, dragStart.dy);
    await tester.flingFrom(openDragStart, const Offset(-60, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    expect(tester.getTopLeft(galleryTitle).dx, closeTo(closedTitleLeft, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion opens and closes the drawer at its final positions', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(tester, const AppShell(), disableAnimations: true);
    final Finder galleryTitle = find.descendant(of: find.byType(MyHomePage), matching: find.text(AppIdentity.name));
    final double closedTitleLeft = tester.getTopLeft(galleryTitle).dx;
    final double drawerWidth = tester.getSize(find.byType(AppShell)).width * 0.75;

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();

    expect(tester.getTopLeft(galleryTitle).dx, closeTo(closedTitleLeft + drawerWidth, 0.01));
    expect(find.byTooltip('Close navigation menu'), findsOneWidget);

    await tester.tap(find.byTooltip('Close navigation menu'));
    await tester.pump();

    expect(tester.getTopLeft(galleryTitle).dx, closeTo(closedTitleLeft, 0.01));
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('enabling reduced motion mid-transition snaps the drawer to its nearest endpoint', (
    WidgetTester tester,
  ) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);
    var reduceMotion = false;
    late StateSetter updateMediaQuery;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            updateMediaQuery = setState;
            final data = MediaQueryData.fromView(tester.view).copyWith(disableAnimations: reduceMotion);
            return MediaQuery(
              data: data,
              child: const Scaffold(body: AppShell()),
            );
          },
        ),
      ),
    );

    final Finder galleryTitle = find.descendant(of: find.byType(MyHomePage), matching: find.text(AppIdentity.name));
    final double closedTitleLeft = tester.getTopLeft(galleryTitle).dx;
    final double drawerWidth = tester.getSize(find.byType(AppShell)).width * 0.75;
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getTopLeft(galleryTitle).dx, inExclusiveRange(closedTitleLeft, closedTitleLeft + drawerWidth));

    updateMediaQuery(() => reduceMotion = true);
    await tester.pump();

    expect(tester.getTopLeft(galleryTitle).dx, closeTo(closedTitleLeft + drawerWidth, 0.01));
    expect(find.byTooltip('Close navigation menu'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('app shell handles landscape safe areas', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
    ]);
    await _pumpScreen(
      tester,
      const AppShell(),
      size: const Size(932, 430),
      textScale: 2,
      disableAnimations: true,
      padding: const EdgeInsets.symmetric(horizontal: 44),
    );

    expect(find.descendant(of: find.byType(MyHomePage), matching: find.text(AppIdentity.name)), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Close navigation menu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('course details keep their content panel inside landscape viewports', (WidgetTester tester) async {
    _evictAssets(<String>['assets/design_course/interFace4.png']);
    await _pumpScreen(
      tester,
      CourseInfoScreen(course: Category.popularCourseList[1]),
      size: const Size(932, 430),
      disableAnimations: true,
      padding: const EdgeInsets.only(left: 44, right: 36),
    );

    expect(find.text('Web Design Course'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Web Design Course')).dy, lessThan(430));
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(tester.getRect(find.byTooltip('Back')).left, greaterThanOrEqualTo(52));
    expect(tester.getRect(find.bySemanticsLabel('Save sample course')).right, lessThanOrEqualTo(861));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ratings are read-only unless a callback is supplied', (WidgetTester tester) async {
    var rating = 0.0;
    await _pumpScreen(
      tester,
      Column(
        children: <Widget>[
          const SmoothStarRating(rating: 4.5),
          SmoothStarRating(onRatingChanged: (double value) => rating = value),
        ],
      ),
    );

    expect(find.byType(GestureDetector), findsOneWidget);
    await tester.tapAt(tester.getTopLeft(find.byType(SmoothStarRating).last) + const Offset(70, 12));

    expect(rating, 3);

    await tester.dragFrom(
      tester.getTopLeft(find.byType(SmoothStarRating).last) + const Offset(12, 12),
      const Offset(100, 0),
    );

    expect(rating, 4.5);
  });

  testWidgets('hotel details preserve the accepted ordinary-phone composition', (WidgetTester tester) async {
    _evictAssets(<String>['assets/hotel/hotel_1.png']);
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);
    final Widget hotelCard = HotelListView(
      hotelData: HotelListData.samples.first,
      isFavorite: false,
      onFavoriteChanged: () {},
      animationController: controller,
      animation: controller,
    );

    await _pumpScreen(tester, hotelCard);

    final Finder location = find.text('Wembley, London');
    expect(find.text('2.0 km to city'), findsOneWidget);
    expect(tester.widget<Flex>(find.ancestor(of: location, matching: find.byType(Flex))).direction, Axis.horizontal);
    expect(tester.takeException(), isNull);

    await _pumpScreen(tester, hotelCard, size: const Size(1024, 1366));

    expect(tester.widget<Flex>(find.ancestor(of: location, matching: find.byType(Flex))).direction, Axis.horizontal);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hotel controls update through their rendered callbacks and dispose cleanly', (
    WidgetTester tester,
  ) async {
    RangeValues? rangeValues;
    double? distance;

    await _pumpScreen(
      tester,
      Column(
        children: <Widget>[
          RangeSliderView(
            values: const RangeValues(100, 600),
            onChangeRangeValues: (RangeValues values) => rangeValues = values,
          ),
          SliderView(distanceValue: 50, onDistanceChanged: (double value) => distance = value),
        ],
      ),
    );

    tester.widget<RangeSlider>(find.byType(RangeSlider)).onChanged!(const RangeValues(200, 700));
    tester.widget<Slider>(find.byType(Slider)).onChanged!(75);
    await tester.pump();

    expect(rangeValues, const RangeValues(200, 700));
    expect(distance, 75);

    await _pumpScreen(tester, const HotelHomeScreen());
    await tester.tap(find.text('Choose date'));
    await tester.pump();
    expect(find.byType(CalendarPopupView), findsOneWidget);
    Navigator.of(tester.element(find.byType(CalendarPopupView))).pop();
    await tester.pump();

    expect(find.text('Sample guests'), findsOneWidget);
    expect(find.text('1 room · 2 adults'), findsOneWidget);
    await tester.tap(find.text('Sample guests'));
    await tester.pump();
    expect(find.byType(CalendarPopupView), findsNothing);
    await _pumpScreen(tester, const SizedBox());
    expect(tester.takeException(), isNull);
  });

  testWidgets('hotel date selection updates the visible stay summary', (WidgetTester tester) async {
    final now = DateTime.now();
    final replacementEnd = DateTime(now.year, now.month + 1, 20);
    _evictAssets(HotelListData.samples.map((HotelListData hotel) => hotel.imagePath));
    await _pumpScreen(tester, const HotelHomeScreen(), disableAnimations: true);

    await tester.tap(find.text('Choose date'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithIcon(IconButton, Icons.keyboard_arrow_right));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel(DateFormat('EEEE, d MMMM yyyy').format(replacementEnd)));
    await tester.pump();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(find.textContaining(DateFormat('dd, MMM').format(replacementEnd)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('support and sharing screens remain usable in a compact accessible viewport', (
    WidgetTester tester,
  ) async {
    _evictAssets(<String>[
      'assets/images/feedbackImage.png',
      'assets/images/helpImage.png',
      'assets/images/inviteImage.png',
    ]);
    final scenarios = <({Widget screen, Finder Function() action})>[
      (screen: HelpScreen(launcher: (_) async => false), action: () => find.widgetWithText(FilledButton, 'Email Us')),
      (screen: FeedbackScreen(launcher: (_) async => false), action: () => find.widgetWithText(FilledButton, 'Send')),
      (screen: InviteFriend(sharer: (_, _) async {}), action: () => find.widgetWithText(FilledButton, 'Share')),
      (screen: const AboutScreen(), action: () => find.widgetWithText(TextButton, 'Developer portfolio')),
    ];

    for (final scenario in scenarios) {
      await _pumpScreen(tester, scenario.screen, size: const Size(320, 568), textScale: 3.2);
      final Finder action = scenario.action();
      expect(action, findsOneWidget);

      await tester.ensureVisible(action);
      await tester.pump();

      expect(action.hitTestable(), findsOneWidget);
      expect(tester.getRect(action).height, greaterThanOrEqualTo(48));
      expect(tester.takeException(), isNull);
    }
  });
}

void _expectFullTextHeight(WidgetTester tester, Finder finder) {
  final RenderBox textBox = tester.renderObject<RenderBox>(finder);
  final double fullHeight = textBox.getMaxIntrinsicHeight(textBox.size.width);
  expect(textBox.size.height, greaterThanOrEqualTo(fullHeight - 0.01));
}

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(430, 932),
  double textScale = 1,
  bool disableAnimations = false,
  EdgeInsets padding = EdgeInsets.zero,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  final MediaQueryData mediaQuery = MediaQueryData.fromView(tester.view).copyWith(
    textScaler: TextScaler.linear(textScale),
    disableAnimations: disableAnimations,
    padding: padding,
    viewPadding: padding,
  );

  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: mediaQuery,
        child: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pump();
}

void _evictAssets(Iterable<String> assets) {
  for (final asset in assets) {
    rootBundle.evict(asset);
  }
}
