import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/banking_super_app/banking_app_theme.dart';
import 'package:templates/features/templates/banking_super_app/banking_home_screen.dart';
import 'package:templates/features/templates/banking_super_app/banking_transfer_screen.dart';

void main() {
  test('banking palettes keep readable text and controls', () {
    for (final brightness in Brightness.values) {
      final colors = BankingAppTheme.build(brightness).colorScheme;
      expect(_contrastRatio(colors.onSurface, colors.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.outline, colors.surface), greaterThanOrEqualTo(3));
    }
  });

  testWidgets('banking template hides balances, sends money, and freezes a card', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: BankingHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Banking'), findsOneWidget);
    expect(find.text('€8,942.70'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pumpAndSettle();
    expect(find.text('€••••••'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(find.byType(BankingTransferScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Lea'));
    await tester.enterText(find.byKey(const ValueKey<String>('banking-transfer-amount')), '25');
    await tester.tap(find.text('Send to Lea'));
    await tester.pumpAndSettle();
    expect(find.text('Money sent to Lea'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.credit_card_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Cards'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Freeze card'));
    await tester.pumpAndSettle();
    expect(find.text('Payments are paused'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('banking template follows its requested dark appearance', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BankingHomeScreen(appearance: AppAppearance.dark)));
    await tester.pump();

    expect(Theme.of(tester.element(find.text('TOTAL BALANCE'))).brightness, Brightness.dark);

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('Send money'))).brightness, Brightness.dark);
  });

  testWidgets('banking dashboard fits a 390-point phone', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: BankingHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('€8,942.70'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('banking transfer stays usable above the keyboard', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(402, 874)
      ..viewInsets = const FakeViewPadding(bottom: 350);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: BankingTransferScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lea'));
    await tester.enterText(find.byKey(const ValueKey<String>('banking-transfer-amount')), '25');
    final sendButton = find.widgetWithText(FilledButton, 'Send to Lea');

    expect(sendButton.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = math.max(foreground.computeLuminance(), background.computeLuminance());
  final darker = math.min(foreground.computeLuminance(), background.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}
