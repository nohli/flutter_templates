import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/planner_app/models/planner_task.dart';
import 'package:templates/features/templates/planner_app/planner_app_theme.dart';
import 'package:templates/features/templates/planner_app/planner_home_screen.dart';
import 'package:templates/features/templates/planner_app/widgets/planner_day_rail.dart';
import 'package:templates/features/templates/planner_app/widgets/planner_gallery_preview.dart';

void main() {
  test('planner keeps its expressive display face out of body copy', () {
    final theme = PlannerAppTheme.build();

    expect(theme.textTheme.headlineLarge?.fontFamily, PlannerAppTheme.displayFontName);
    expect(theme.textTheme.bodyMedium?.fontFamily, PlannerAppTheme.fontName);
    expect(PlannerAppTheme.fontName, isNot(PlannerAppTheme.displayFontName));
  });

  test('planner tasks copy state without losing stable identity', () {
    final original = PlannerTask.samples.first;
    final completed = original.copyWith(status: PlannerTaskStatus.done);

    expect(completed.id, original.id);
    expect(completed.title, original.title);
    expect(completed.status, PlannerTaskStatus.done);
  });

  testWidgets('planner completes and captures tasks with visible progress', (WidgetTester tester) async {
    await _pumpPlanner(tester);

    expect(find.text('TIME MAP / TODAY'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    await tester.tap(find.byTooltip('Complete Review the launch flow'));
    await tester.pumpAndSettle();
    expect(find.text('50%'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Prepare the prototype');
    await tester.tap(find.byTooltip('Add task'));
    await tester.pump();
    expect(find.text('Prepare the prototype'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('planner exposes a truthful empty capture state', (WidgetTester tester) async {
    await _pumpPlanner(tester);

    await tester.tap(find.byTooltip('Add task'));
    await tester.pump();
    expect(find.text('Write a task before adding it.'), findsOneWidget);
  });

  testWidgets('planner board and focus mode reflect current state', (WidgetTester tester) async {
    await _pumpPlanner(tester);

    await tester.tap(find.byTooltip('Board'));
    await tester.pump();
    expect(find.text('Projects in motion'), findsOneWidget);
    expect(find.text('Next up'), findsOneWidget);
    expect(find.text('In progress'), findsOneWidget);

    await tester.tap(find.byTooltip('Focus'));
    await tester.pump();
    expect(find.text('READY'), findsOneWidget);
    await tester.tap(find.text('Start focus'));
    await tester.pump();
    expect(find.text('FOCUSING'), findsOneWidget);
    expect(find.text('Pause preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('planner gallery preview remains legible at compact card size', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: PlannerGalleryPreview())),
      ),
    );

    expect(find.text('DAYMARK  /  THURSDAY'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    for (final time in <String>['09:30', '11:00', '14:00']) {
      expect(find.text(time), findsOneWidget);
    }
    expect(find.bySemanticsLabel('Daymark graphic daily planner preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('planner remains usable on compact maximum-text layouts', (WidgetTester tester) async {
    await _pumpPlanner(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['Board', 'Focus', 'Today']) {
      await tester.tap(find.descendant(of: find.byType(PlannerDayRail), matching: find.byTooltip(label)));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: label);
    }
  });

  testWidgets('planner supports an externally selected dark appearance', (WidgetTester tester) async {
    await _pumpPlanner(tester, appearance: AppAppearance.dark);

    expect(Theme.of(tester.element(find.text('Daymark'))).brightness, Brightness.dark);

    final completedTitle = tester.widget<Text>(find.text('Shape next sprint'));
    final completedTile = tester.widget<AnimatedContainer>(
      find.ancestor(of: find.text('Shape next sprint'), matching: find.byType(AnimatedContainer)).first,
    );
    final completedDecoration = completedTile.decoration! as BoxDecoration;
    final colors = Theme.of(tester.element(find.text('Shape next sprint'))).colorScheme;
    expect(completedDecoration.color, colors.secondary);
    expect(completedTitle.style?.color, colors.onSecondary);
  });
}

Future<void> _pumpPlanner(
  WidgetTester tester, {
  Size size = const Size(430, 932),
  double textScale = 1,
  AppAppearance appearance = AppAppearance.light,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(tester.view).copyWith(textScaler: TextScaler.linear(textScale));
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: mediaQuery,
        child: PlannerHomeScreen(appearance: appearance),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
