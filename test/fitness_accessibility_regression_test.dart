import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/fitness_app/fitness_app_theme.dart';
import 'package:templates/fitness_app/models/meals_list_data.dart';
import 'package:templates/fitness_app/my_diary/meals_list_view.dart';
import 'package:templates/fitness_app/training/training_screen.dart';
import 'package:templates/fitness_app/ui_view/area_list_view.dart';
import 'package:templates/fitness_app/ui_view/body_measurement.dart';
import 'package:templates/fitness_app/ui_view/mediterranean_diet_view.dart';
import 'package:templates/fitness_app/ui_view/sample_date_header.dart';
import 'package:templates/fitness_app/ui_view/wave_view.dart';

void main() {
  testWidgets('sample date header fits the original phone composition', (WidgetTester tester) async {
    await _pumpFitnessScreen(
      tester,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'My Diary',
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SampleDateHeader(),
          ],
        ),
      ),
      size: const Size(402, 874),
      disableAnimations: true,
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('diet summary fits the original phone composition', (WidgetTester tester) async {
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);
    _evictAssets(<String>['assets/fitness_app/eaten.png', 'assets/fitness_app/burned.png']);

    await _pumpFitnessScreen(
      tester,
      SingleChildScrollView(
        child: MediterraneanDietView(animationController: controller, animation: controller),
      ),
      size: const Size(402, 874),
      disableAnimations: true,
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('body measurements honor every enlarged text scale without shrinking it', (WidgetTester tester) async {
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);

    for (final textScale in <double>[1.3, 1.9, 3.2]) {
      await _pumpFitnessScreen(
        tester,
        SingleChildScrollView(
          child: BodyMeasurementView(animationController: controller, animation: controller),
        ),
        size: const Size(320, 900),
        textScale: textScale,
        disableAnimations: true,
      );

      expect(find.text('206.8'), findsOneWidget);
      expect(find.text('lbs'), findsOneWidget);
      expect(find.text('27.3 BMI'), findsOneWidget);
      expect(find.text('Connected smart scale'), findsOneWidget);
      expect(find.byType(FittedBox), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('meal cards preserve the original open gradients at the default text size', (WidgetTester tester) async {
    final roboto = FontLoader('Roboto')..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    await roboto.load();
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);
    _evictAssets(<String>['assets/fitness_app/breakfast.png']);

    await _pumpFitnessScreen(
      tester,
      SizedBox(
        width: 160,
        height: 240,
        child: MealsView(
          mealsListData: MealsListData.samples.first,
          animationController: controller,
          animation: controller,
        ),
      ),
    );

    final darkScrim = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == const Color(0xFF263238),
    );
    expect(darkScrim, findsNothing);
    expect(tester.widget<Text>(find.text('Breakfast')).style?.color, FitnessAppTheme.white);
    final breakfastTitle = tester.renderObject<RenderParagraph>(find.text('Breakfast'));
    expect(
      breakfastTitle.getBoxesForSelection(const TextSelection(baseOffset: 0, extentOffset: 'Breakfast'.length)),
      hasLength(1),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('large-text meal cards retain the accessible contrast surface', (WidgetTester tester) async {
    final roboto = FontLoader('Roboto')..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    await roboto.load();
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);
    _evictAssets(<String>['assets/fitness_app/breakfast.png']);

    await _pumpFitnessScreen(
      tester,
      SizedBox(
        width: 320,
        height: 600,
        child: MealsView(
          mealsListData: MealsListData.samples.first,
          animationController: controller,
          animation: controller,
        ),
      ),
      size: const Size(320, 700),
      textScale: 3.2,
      disableAnimations: true,
    );

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    expect(tester.takeException(), isNull);
  });

  testWidgets('meal list renders every declared sample through its real horizontal catalog', (
    WidgetTester tester,
  ) async {
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);
    _evictAssets(MealsListData.samples.map((MealsListData meal) => meal.imagePath));

    await _pumpFitnessScreen(
      tester,
      SizedBox(
        width: 320,
        child: MealsListView(mainScreenAnimationController: controller, mainScreenAnimation: controller),
      ),
      disableAnimations: true,
    );

    final horizontalList = find.byWidgetPredicate(
      (Widget widget) => widget is Scrollable && widget.axisDirection == AxisDirection.right,
    );
    expect(horizontalList, findsOneWidget);
    for (final MealsListData meal in MealsListData.samples) {
      await tester.scrollUntilVisible(find.text(meal.title), 180, scrollable: horizontalList);
      expect(find.text(meal.title), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    expect(find.text('kcal'), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.add), findsAtLeastNWidgets(1));
  });

  testWidgets('large-text snack and dinner cards expand without shrinking their content', (WidgetTester tester) async {
    final controller = AnimationController(vsync: tester, value: 1);
    addTearDown(controller.dispose);
    final recommendations = MealsListData.samples.where((MealsListData meal) => meal.kcal == 0);
    _evictAssets(recommendations.map((MealsListData meal) => meal.imagePath));

    for (final meal in recommendations) {
      await _pumpFitnessScreen(
        tester,
        SizedBox(
          width: 320,
          height: 700,
          child: MealsView(
            key: ValueKey<String>(meal.title),
            mealsListData: meal,
            animationController: controller,
            animation: controller,
          ),
        ),
        textScale: 3.2,
        disableAnimations: true,
      );

      final mealCard = find.byType(MealsView);
      expect(
        find.descendant(of: mealCard, matching: find.byType(FittedBox)),
        findsNothing,
        reason: meal.title,
      );
      final addIcon = tester.widget<Icon>(find.descendant(of: mealCard, matching: find.byIcon(Icons.add)));
      expect(addIcon.color, FitnessAppTheme.build().colorScheme.primary, reason: meal.title);
      expect(find.text(meal.title), findsOneWidget);
      expect(tester.takeException(), isNull, reason: meal.title);
    }
  });

  testWidgets('training schedules every entrance before the final frame', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/fitness_app/runner.png',
      'assets/fitness_app/back.png',
      'assets/fitness_app/area1.png',
      'assets/fitness_app/area2.png',
      'assets/fitness_app/area3.png',
    ]);
    final controller = AnimationController(vsync: tester)..value = 0.9;
    addTearDown(controller.dispose);

    await _pumpFitnessScreen(tester, TrainingScreen(animationController: controller), size: const Size(430, 1800));

    final Finder area = find.byType(AreaListView);
    expect(area, findsOneWidget);
    final FadeTransition entrance = tester.widget<FadeTransition>(
      find.descendant(of: area, matching: find.byType(FadeTransition)).first,
    );
    expect(entrance.opacity.value, greaterThan(0));
    expect(entrance.opacity.value, lessThan(1));

    final Transform translation = tester.widget<Transform>(
      find.descendant(of: area, matching: find.byType(Transform)).first,
    );
    expect(translation.transform.getTranslation().y, greaterThan(0));

    controller.value = 1;
    await tester.pump();

    final FadeTransition settledEntrance = tester.widget<FadeTransition>(
      find.descendant(of: area, matching: find.byType(FadeTransition)).first,
    );
    final Transform settledTranslation = tester.widget<Transform>(
      find.descendant(of: area, matching: find.byType(Transform)).first,
    );
    expect(settledEntrance.opacity.value, 1);
    expect(settledTranslation.transform.getTranslation().y, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('water wave completes a full sinusoidal phase inside its bottle', (WidgetTester tester) async {
    _evictAssets(<String>['assets/fitness_app/bottle.png']);
    await _pumpFitnessScreen(tester, const SizedBox(width: 60, height: 160, child: WaveView(percentageValue: 60)));

    final double initialY = _firstWaveY(tester);
    await tester.pump(const Duration(milliseconds: 500));
    final double quarterCycleY = _firstWaveY(tester);
    await tester.pump(const Duration(milliseconds: 500));
    final double halfCycleY = _firstWaveY(tester);
    await tester.pump(const Duration(milliseconds: 500));
    final double threeQuarterCycleY = _firstWaveY(tester);
    await tester.pump(const Duration(milliseconds: 500));
    final double fullCycleY = _firstWaveY(tester);

    expect(quarterCycleY - initialY, closeTo(4, 0.3));
    expect(halfCycleY, closeTo(initialY, 0.3));
    expect(threeQuarterCycleY - initialY, closeTo(-4, 0.3));
    expect(fullCycleY, closeTo(initialY, 0.3));
    expect(<double>[
      initialY,
      quarterCycleY,
      halfCycleY,
      threeQuarterCycleY,
      fullCycleY,
    ], everyElement(inInclusiveRange(0, 160)));
    expect(tester.takeException(), isNull);

    await _pumpFitnessScreen(tester, const SizedBox());
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('reduced-motion water level updates with a changed percentage', (WidgetTester tester) async {
    _evictAssets(<String>['assets/fitness_app/bottle.png']);
    var percentage = 60.0;
    late StateSetter updateHost;
    await _pumpFitnessScreen(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          updateHost = setState;
          return SizedBox(
            width: 60,
            height: 160,
            child: WaveView(key: const ValueKey<String>('water-level'), percentageValue: percentage),
          );
        },
      ),
      disableAnimations: true,
    );

    expect(_firstWaveY(tester), closeTo(64, 0.01));
    updateHost(() => percentage = 80);
    await tester.pump();

    expect(find.text('80'), findsOneWidget);
    expect(_firstWaveY(tester), closeTo(32, 0.01));
    expect(tester.takeException(), isNull);
  });
}

double _firstWaveY(WidgetTester tester) {
  final ClipPath clipPath = tester.widget<ClipPath>(find.byType(ClipPath).first);
  final clipper = clipPath.clipper! as WaveClipper;

  return clipper.verticalOffset;
}

Future<void> _pumpFitnessScreen(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(430, 932),
  double textScale = 1,
  bool disableAnimations = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  final MediaQueryData mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: disableAnimations);

  await tester.pumpWidget(
    MaterialApp(
      theme: FitnessAppTheme.build(),
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
