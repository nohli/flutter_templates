import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/design_course/course_info_screen.dart';
import 'package:templates/design_course/home_design_course.dart';
import 'package:templates/design_course/models/category.dart' as course_model;
import 'package:templates/fitness_app/fitness_app_home_screen.dart';
import 'package:templates/fitness_app/my_diary/meals_list_view.dart';
import 'package:templates/fitness_app/ui_view/area_list_view.dart';
import 'package:templates/fitness_app/ui_view/wave_view.dart';
import 'package:templates/home_screen.dart';
import 'package:templates/hotel_booking/calendar_popup_view.dart';
import 'package:templates/hotel_booking/hotel_home_screen.dart';

void main() {
  testWidgets('reduced motion settles gallery, course, hotel, and calendar entrances', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
      'assets/design_course/interFace1.png',
      'assets/design_course/interFace2.png',
      'assets/design_course/interFace3.png',
      'assets/design_course/interFace4.png',
      'assets/design_course/userImage.png',
      'assets/hotel/hotel_1.png',
      'assets/hotel/hotel_2.png',
      'assets/hotel/hotel_3.png',
      'assets/hotel/hotel_4.png',
      'assets/hotel/hotel_5.png',
    ]);

    await _pumpScreen(tester, const MyHomePage(), disableAnimations: true);
    _expectStableEndState(tester);
    _expectCompleteFadeTransitions(tester);
    final initialGalleryCard = tester.getRect(find.bySemanticsLabel('Hotel Booking'));
    await tester.pump(const Duration(seconds: 5));
    expect(tester.getRect(find.bySemanticsLabel('Hotel Booking')), initialGalleryCard);
    _expectStableEndState(tester);

    await _pumpScreen(tester, const DesignCourseHomeScreen(), disableAnimations: true);
    _expectStableEndState(tester);
    _expectCompleteFadeTransitions(tester);
    final courseCard = find.bySemanticsLabel(RegExp(r'^Open App Design Course sample course,'));
    final initialCourseCard = tester.getRect(courseCard.first);
    await tester.pump(const Duration(seconds: 5));
    expect(tester.getRect(courseCard.first), initialCourseCard);
    _expectStableEndState(tester);

    await _pumpScreen(tester, const HotelHomeScreen(), disableAnimations: true);
    _expectStableEndState(tester);
    _expectCompleteFadeTransitions(tester);
    final initialHotelCard = tester.getRect(find.text('Grand Royal Hotel').first);
    await tester.pump(const Duration(seconds: 5));
    expect(tester.getRect(find.text('Grand Royal Hotel').first), initialHotelCard);
    _expectStableEndState(tester);

    final now = DateTime.now();
    await _pumpScreen(
      tester,
      CalendarPopupView(
        initialStartDate: now,
        initialEndDate: now.add(const Duration(days: 2)),
        onApplyClick: (_, _) {},
      ),
      disableAnimations: true,
    );
    final popupOpacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(popupOpacity.duration, Duration.zero);
    expect(popupOpacity.opacity, 1);
    _expectStableEndState(tester);
    await tester.pump(const Duration(seconds: 5));
    expect(tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity, 1);
    _expectStableEndState(tester);
  });

  testWidgets('reduced motion settles fitness transitions, nested entrances, and water waves', (
    WidgetTester tester,
  ) async {
    _evictAssets(<String>[
      'assets/fitness_app/eaten.png',
      'assets/fitness_app/burned.png',
      'assets/fitness_app/breakfast.png',
      'assets/fitness_app/lunch.png',
      'assets/fitness_app/snack.png',
      'assets/fitness_app/dinner.png',
      'assets/fitness_app/tab_1.png',
      'assets/fitness_app/tab_1s.png',
      'assets/fitness_app/tab_2.png',
      'assets/fitness_app/tab_2s.png',
      'assets/fitness_app/tab_3.png',
      'assets/fitness_app/tab_3s.png',
      'assets/fitness_app/tab_4.png',
      'assets/fitness_app/tab_4s.png',
      'assets/fitness_app/area1.png',
      'assets/fitness_app/area2.png',
      'assets/fitness_app/area3.png',
      'assets/fitness_app/bottle.png',
    ]);

    await _pumpScreen(tester, const FitnessAppHomeScreen(), disableAnimations: true);
    _expectStableEndState(tester);
    await tester.tap(find.bySemanticsLabel('Training').first);
    await tester.pump();
    await tester.pump();
    expect(find.text('Your program'), findsOneWidget);
    _expectStableEndState(tester);

    final parentController = AnimationController(vsync: tester)..value = 1;
    addTearDown(parentController.dispose);
    await _pumpScreen(tester, MealsListView(mainScreenAnimation: parentController), disableAnimations: true);
    _expectStableEndState(tester);
    _expectCompleteFadeTransitions(tester);
    await tester.pump(const Duration(seconds: 5));
    _expectStableEndState(tester);

    await _pumpScreen(tester, AreaListView(mainScreenAnimation: parentController), disableAnimations: true);
    _expectStableEndState(tester);
    _expectCompleteFadeTransitions(tester);
    await tester.pump(const Duration(seconds: 5));
    _expectStableEndState(tester);

    await _pumpScreen(
      tester,
      const SizedBox.square(dimension: 180, child: WaveView(percentageValue: 60)),
      disableAnimations: true,
    );
    final initialWave = _firstWaveOffset(tester);
    final waveScaleTransitions = find.descendant(of: find.byType(WaveView), matching: find.byType(ScaleTransition));
    expect(
      tester.widgetList<ScaleTransition>(waveScaleTransitions).map((widget) => widget.scale.value),
      everyElement(1),
    );
    _expectStableEndState(tester);
    await tester.pump(const Duration(seconds: 5));
    expect(_firstWaveOffset(tester), initialWave);
    _expectStableEndState(tester);
  });

  testWidgets('water waves keep their repeating motion when animations are enabled', (WidgetTester tester) async {
    _evictAssets(<String>['assets/fitness_app/bottle.png']);
    await _pumpScreen(tester, const SizedBox.square(dimension: 180, child: WaveView(percentageValue: 60)));
    final initialWave = _firstWaveOffset(tester);

    expect(tester.hasRunningAnimations, isTrue);
    await tester.pump(const Duration(milliseconds: 500));
    expect(_firstWaveOffset(tester), isNot(initialWave));
    expect(tester.hasRunningAnimations, isTrue);

    await _pumpScreen(tester, const SizedBox());
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('course detail scrolls and preserves full copy at compact maximum text scale', (
    WidgetTester tester,
  ) async {
    _evictAssets(<String>['assets/design_course/interFace4.png']);
    await _pumpScreen(
      tester,
      CourseInfoScreen(course: course_model.Category.popularCourseList[1]),
      size: const Size(320, 568),
      textScale: 3.2,
      disableAnimations: true,
    );

    expect(find.text('Web Design Course'), findsOneWidget);
    expect(find.text('2 hours'), findsOneWidget);
    expect(find.text('Seats'), findsOneWidget);
    final description = tester.widget<Text>(
      find.text('This fictional course demonstrates the course-details interface.'),
    );
    expect(description.maxLines, isNull);
    expect(description.overflow, isNull);
    final opacities = tester.widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity)).toList(growable: false);
    expect(opacities, hasLength(3));
    expect(opacities.map((widget) => widget.duration), everyElement(Duration.zero));
    expect(opacities.map((widget) => widget.opacity), everyElement(1));
    _expectStableEndState(tester);

    final preview = find.text('Preview only — enrollment is not available.');
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.position.maxScrollExtent, greaterThan(0));
    final panelTop = 320 / 1.2 - 24;
    final previewStartOffset = (tester.getRect(preview).top - panelTop)
        .clamp(0.0, scrollable.position.maxScrollExtent)
        .toDouble();
    scrollable.position.jumpTo(previewStartOffset);
    await tester.pump();
    expect(tester.getRect(preview).top, closeTo(panelTop, 1));

    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pump();
    final previewRect = tester.getRect(preview);
    expect(previewRect.bottom, lessThanOrEqualTo(568));
    expect(tester.takeException(), isNull);

    final stablePreviewRect = tester.getRect(preview);
    await tester.pump(const Duration(seconds: 5));
    expect(tester.getRect(preview), stablePreviewRect);
    _expectStableEndState(tester);
  });
}

double _firstWaveOffset(WidgetTester tester) {
  final clipPath = tester.widget<ClipPath>(find.byType(ClipPath).first);
  final clipper = clipPath.clipper! as WaveClipper;

  return clipper.verticalOffset;
}

void _expectStableEndState(WidgetTester tester) {
  expect(tester.hasRunningAnimations, isFalse);
  expect(tester.takeException(), isNull);
}

void _expectCompleteFadeTransitions(WidgetTester tester) {
  for (final fadeTransition in tester.widgetList<FadeTransition>(find.byType(FadeTransition))) {
    expect(fadeTransition.opacity.value, 1);
  }
}

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(430, 932),
  double textScale = 1,
  bool disableAnimations = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  final mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: disableAnimations);

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
