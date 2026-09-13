import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/language_learning/language_learning_home_screen.dart';
import 'package:templates/features/templates/language_learning/language_learning_theme.dart';
import 'package:templates/features/templates/language_learning/language_lesson_screen.dart';

void main() {
  test('language palettes keep readable text and controls', () {
    for (final brightness in Brightness.values) {
      final colors = LanguageLearningTheme.build(brightness).colorScheme;
      expect(_contrastRatio(colors.onSurface, colors.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.outline, colors.surface), greaterThanOrEqualTo(3));
    }
  });

  testWidgets('language path opens a lesson and completes the correct reply', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: LanguageLearningHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Order food with confidence'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('language-current-lesson')));
    await tester.pumpAndSettle();

    expect(find.byType(LanguageLessonScreen), findsOneWidget);
    await tester.tap(find.text('Où est la gare?'));
    await tester.pump();
    expect(find.text('Almost. Pick the reply that orders a coffee.'), findsOneWidget);

    await tester.tap(find.text('Un café, s’il vous plaît.'));
    await tester.pump();
    expect(find.text('Perfect — that’s a polite way to order.'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(LanguageLessonScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('language template follows its requested dark appearance', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LanguageLearningHomeScreen(appearance: AppAppearance.dark)));
    await tester.pump();

    expect(Theme.of(tester.element(find.text('Order food with confidence'))).brightness, Brightness.dark);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = math.max(foreground.computeLuminance(), background.computeLuminance());
  final darker = math.min(foreground.computeLuminance(), background.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}
