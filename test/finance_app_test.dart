import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/finance_app/finance_home_screen.dart';
import 'package:templates/features/templates/finance_app/models/finance_transaction.dart';
import 'package:templates/features/templates/finance_app/models/spending_category.dart';
import 'package:templates/features/templates/finance_app/widgets/finance_bottom_bar.dart';
import 'package:templates/features/templates/finance_app/widgets/finance_entrance.dart';
import 'package:templates/features/templates/finance_app/widgets/finance_gallery_preview.dart';
import 'package:templates/features/templates/finance_app/widgets/spending_overview.dart';
import 'package:templates/features/templates/shared/template_gallery_preview.dart';

void main() {
  test('finance sample models expose stable values and bounded progress', () {
    expect(FinanceTransaction.samples.map((FinanceTransaction transaction) => transaction.id).toSet(), hasLength(5));
    expect(FinanceTransaction.samples.first.isIncome, isTrue);
    expect(FinanceTransaction.samples.last.isIncome, isFalse);

    const overBudget = SpendingCategory(label: 'Sample', spent: 120, budget: 100, kind: SpendingCategoryKind.food);
    const noBudget = SpendingCategory(label: 'Sample', spent: 0, budget: 0, kind: SpendingCategoryKind.home);
    expect(overBudget.progress, 1);
    expect(noBudget.progress, 0);
  });

  testWidgets('finance overview presents the complete sample dashboard without layout errors', (
    WidgetTester tester,
  ) async {
    await _pumpFinance(tester);

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Good morning, Alex'), findsOneWidget);
    expect(find.text('Money and crypto, together'), findsOneWidget);
    expect(find.text('Total balance'), findsOneWidget);
    expect(find.text('12.4% this month'), findsOneWidget);
    expect(find.text('Spending'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Crypto'),
      300,
      scrollable: find.descendant(of: find.byType(FinanceHomeScreen), matching: find.byType(Scrollable)).first,
    );

    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('Ethereum'), findsOneWidget);
    expect(find.text('Solana'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Recent activity'),
      300,
      scrollable: find.descendant(of: find.byType(FinanceHomeScreen), matching: find.byType(Scrollable)).first,
    );

    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('finance gallery preview stays legible at its compact card size', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: FinanceGalleryPreview())),
      ),
    );

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.byType(TemplatePreviewDevice), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('finance balance privacy and quick actions provide visible feedback', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    await _pumpFinance(tester);

    expect(
      tester.getSemantics(find.bySemanticsLabel('Send')),
      matchesSemantics(label: 'Send', isButton: true, hasTapAction: true),
    );
    expect(find.textContaining('24,860'), findsOneWidget);
    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pumpAndSettle();

    expect(find.text('••••••'), findsOneWidget);
    expect(find.byTooltip('Show balance'), findsOneWidget);

    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(find.text('Send is shown as an interface preview.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('finance renders the externally selected dark theme', (WidgetTester tester) async {
    await _pumpFinance(tester, appearance: AppAppearance.dark);

    final theme = Theme.of(tester.element(find.text('Overview')));
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, const Color(0xFF0E1118));
    expect(tester.takeException(), isNull);
  });

  testWidgets('finance content enters progressively and replays when sections change', (WidgetTester tester) async {
    await _pumpFinance(tester, settle: false);

    final greetingEntrance = find.ancestor(of: find.text('Good morning, Alex'), matching: find.byType(FinanceEntrance));
    final greetingFade = find.descendant(of: greetingEntrance, matching: find.byType(FadeTransition));
    expect(tester.widget<FadeTransition>(greetingFade).opacity.value, 0);

    final progressIndicators = find.descendant(
      of: find.byType(SpendingOverview),
      matching: find.byType(LinearProgressIndicator),
    );
    expect(
      tester.widgetList<LinearProgressIndicator>(progressIndicators).map((indicator) => indicator.value),
      everyElement(0),
    );

    await tester.pumpAndSettle();
    expect(tester.widget<FadeTransition>(greetingFade).opacity.value, 1);
    expect(
      tester.widgetList<LinearProgressIndicator>(progressIndicators).map((indicator) => indicator.value),
      everyElement(greaterThan(0)),
    );

    await tester.tap(find.text('Cards'));
    await tester.pump();

    final cardEntrance = find.ancestor(
      of: find.text('Manage your sample cards and limits.'),
      matching: find.byType(FinanceEntrance),
    );
    final cardFade = find.descendant(of: cardEntrance, matching: find.byType(FadeTransition));
    expect(tester.widget<FadeTransition>(cardFade).opacity.value, lessThan(1));

    await tester.pumpAndSettle();
    expect(tester.widget<FadeTransition>(cardFade).opacity.value, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('finance activity filters the rendered transactions', (WidgetTester tester) async {
    await _pumpFinance(tester);

    await tester.scrollUntilVisible(
      find.text('See all'),
      300,
      scrollable: find.descendant(of: find.byType(FinanceHomeScreen), matching: find.byType(Scrollable)).first,
    );
    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();

    expect(find.text('Activity'), findsWidgets);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Green Market'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Income'));
    await tester.pumpAndSettle();

    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Green Market'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Spending'));
    await tester.pumpAndSettle();

    expect(find.text('Salary'), findsNothing);
    expect(find.text('Green Market'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('finance card and profile controls retain their state across navigation', (WidgetTester tester) async {
    await _pumpFinance(tester);

    await tester.tap(find.text('Cards'));
    await tester.pumpAndSettle();
    expect(find.text('Active'), findsOneWidget);

    await tester.tap(find.text('Lock sample card'));
    await tester.pumpAndSettle();
    expect(find.text('Locked'), findsOneWidget);
    expect(find.text('Unlock sample card'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(SwitchListTile, 'Biometric sign-in'));
    await tester.pump();

    expect(tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'Biometric sign-in')).value, isTrue);

    await tester.tap(find.text('Cards'));
    await tester.pumpAndSettle();

    expect(find.text('Locked'), findsOneWidget);
    expect(find.text('Unlock sample card'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('finance template remains usable on compact phone layouts', (WidgetTester tester) async {
    await _pumpFinance(tester, size: const Size(320, 568));

    for (final label in <String>['Activity', 'Cards', 'Profile', 'Home']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: label);
    }
  });

  testWidgets('finance template remains usable at compact maximum text size', (WidgetTester tester) async {
    await _pumpFinance(tester, size: const Size(320, 568), textScale: 3.2);

    const destinations = <String, String>{
      'Activity': 'A clear view of every sample transaction.',
      'Cards': 'Manage your sample cards and limits.',
      'Profile': 'Alex Rivera',
      'Home': 'Good morning, Alex',
    };
    for (final destination in destinations.entries) {
      final navigationScroll = find.descendant(of: find.byType(FinanceBottomBar), matching: find.byType(Scrollable));
      await tester.scrollUntilVisible(find.text(destination.key), 160, scrollable: navigationScroll);
      await tester.tap(find.text(destination.key).hitTestable());
      await tester.pump();
      expect(find.text(destination.value), findsOneWidget);
      expect(tester.takeException(), isNull, reason: destination.key);
    }
  });

  testWidgets('finance template honors reduced motion', (WidgetTester tester) async {
    await _pumpFinance(tester, disableAnimations: true);

    expect(
      tester.widgetList<AnimatedSwitcher>(find.byType(AnimatedSwitcher)).map((switcher) => switcher.duration),
      everyElement(Duration.zero),
    );
    expect(
      tester
          .widgetList<FadeTransition>(
            find.descendant(of: find.byType(FinanceEntrance), matching: find.byType(FadeTransition)),
          )
          .map((transition) => transition.opacity.value),
      everyElement(1),
    );
    await tester.tap(find.text('Cards'));
    await tester.pump();
    expect(tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).duration, Duration.zero);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpFinance(
  WidgetTester tester, {
  Size size = const Size(430, 932),
  double textScale = 1,
  AppAppearance appearance = AppAppearance.light,
  bool disableAnimations = false,
  bool settle = true,
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
        child: FinanceHomeScreen(appearance: appearance),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  }
}
