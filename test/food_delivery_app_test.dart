import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/food_delivery_app/food_delivery_app_theme.dart';
import 'package:templates/features/templates/food_delivery_app/food_delivery_home_screen.dart';
import 'package:templates/features/templates/food_delivery_app/models/meal.dart';
import 'package:templates/features/templates/food_delivery_app/sections/delivery_basket_section.dart';
import 'package:templates/features/templates/food_delivery_app/widgets/delivery_action_dock.dart';
import 'package:templates/features/templates/food_delivery_app/widgets/delivery_basket_item.dart';
import 'package:templates/features/templates/food_delivery_app/widgets/delivery_gallery_preview.dart';
import 'package:templates/features/templates/food_delivery_app/widgets/meal_card.dart';

void main() {
  test('delivery sample meals expose unique identifiers and valid values', () {
    expect(Meal.samples, hasLength(4));
    expect(Meal.samples.map((Meal meal) => meal.id).toSet(), hasLength(4));
    expect(Meal.samples.every((Meal meal) => meal.price > 0 && meal.rating >= 0 && meal.rating <= 5), isTrue);
  });

  testWidgets('delivery filters meals by category and search', (WidgetTester tester) async {
    await _pumpDelivery(tester);

    await tester.tap(find.text('Pizza'));
    await tester.pump();
    expect(find.text('Garden pizza'), findsOneWidget);
    expect(find.text('Sunset bowl'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.enterText(find.byType(TextField), 'daybreak');
    await tester.pump();
    expect(find.text('Avocado toast'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pump();
    expect(find.text('No matching meals'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('delivery adds, increments, and removes basket quantities', (WidgetTester tester) async {
    await _pumpDelivery(tester);

    await tester.tap(find.byTooltip('Add Sunset bowl to basket'));
    await tester.pump();
    await tester.tap(find.byTooltip('Basket, 1 item'));
    await tester.pump();
    expect(find.text('Sunset bowl'), findsOneWidget);
    expect(find.descendant(of: find.byType(DeliveryBasketSection), matching: find.text('1')), findsOneWidget);

    await tester.tap(find.byTooltip('Add one Sunset bowl'));
    await tester.pump();
    expect(find.descendant(of: find.byType(DeliveryBasketSection), matching: find.text('2')), findsOneWidget);

    await tester.tap(find.text('Preview checkout'));
    await tester.pump();
    expect(find.text('Checkout is shown as an interface preview.'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove one Sunset bowl'));
    await tester.tap(find.byTooltip('Remove one Sunset bowl'));
    await tester.pump();
    expect(find.text('Your basket is waiting'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('delivery uses soft meal cards and animates basket feedback', (WidgetTester tester) async {
    await _pumpDelivery(tester, disableAnimations: false);

    final mealCard = find.byType(MealCard).first;
    final cardMaterial = tester.widget<Material>(find.descendant(of: mealCard, matching: find.byType(Material)).first);
    expect((cardMaterial.shape! as RoundedRectangleBorder).borderRadius, FoodDeliveryAppTheme.cardRadius);

    await tester.tap(find.byTooltip('Add Sunset bowl to basket'));
    await tester.pump();
    final basket = find.byTooltip('Basket, 1 item');
    final badgeMotion = tester.widget<AnimatedSwitcher>(
      find.descendant(of: basket, matching: find.byType(AnimatedSwitcher)),
    );
    expect(badgeMotion.duration, const Duration(milliseconds: 260));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('delivery order journey exposes its state transition', (WidgetTester tester) async {
    await _pumpDelivery(tester);

    await tester.tap(find.text('Order status'));
    await tester.pump();
    expect(find.text('Arriving in 8–12 min'), findsOneWidget);
    await tester.tap(find.byTooltip('Contact sample courier'));
    await tester.pump();
    expect(find.text('Courier contact is not connected in this template.'), findsOneWidget);
    await tester.tap(find.text('Mark sample delivered'));
    await tester.pump();
    expect(find.text('Order delivered'), findsOneWidget);
    expect(find.text('Reset sample journey'), findsOneWidget);
    await tester.tap(find.text('Reset sample journey'));
    await tester.pump();
    expect(find.text('Arriving in 8–12 min'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('delivery gallery preview remains legible at compact card size', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: DeliveryGalleryPreview())),
      ),
    );

    expect(find.text('SAVOR!'), findsOneWidget);
    expect(find.text('18 MIN'), findsOneWidget);
    expect(find.bySemanticsLabel('Savor illustrated food delivery menu preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('delivery remains usable on compact maximum-text layouts', (WidgetTester tester) async {
    await _pumpDelivery(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['Order', 'Basket', 'Discover']) {
      final finder = label == 'Order'
          ? find.descendant(of: find.byType(DeliveryActionDock), matching: find.textContaining('Order'))
          : find.descendant(of: find.byType(DeliveryActionDock), matching: find.byTooltip(label));
      await tester.tap(finder);
      await tester.pump();
      expect(tester.takeException(), isNull, reason: label);
    }

    await _pumpDeliveryScreen(
      tester,
      SingleChildScrollView(
        child: DeliveryBasketItem(meal: Meal.samples.first, quantity: 1, onAdd: () {}, onRemove: () {}),
      ),
      size: const Size(320, 568),
      textScale: 3.2,
    );
    expect(find.text('Sunset bowl'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('delivery supports an externally selected dark mode', (WidgetTester tester) async {
    await _pumpDelivery(tester, appearance: AppAppearance.dark);

    expect(Theme.of(tester.element(find.text('Savor'))).brightness, Brightness.dark);
  });

  testWidgets('delivery returns to its gallery route', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) => TextButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const FoodDeliveryHomeScreen())),
            child: const Text('Open delivery template'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open delivery template'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back to template gallery'));
    await tester.pumpAndSettle();

    expect(find.text('Open delivery template'), findsOneWidget);
    expect(find.byType(FoodDeliveryHomeScreen), findsNothing);
  });
}

Future<void> _pumpDelivery(
  WidgetTester tester, {
  Size size = const Size(430, 932),
  double textScale = 1,
  AppAppearance appearance = AppAppearance.light,
  bool disableAnimations = true,
}) async {
  await _pumpDeliveryScreen(
    tester,
    FoodDeliveryHomeScreen(appearance: appearance),
    size: size,
    textScale: textScale,
    disableAnimations: disableAnimations,
  );
}

Future<void> _pumpDeliveryScreen(
  WidgetTester tester,
  Widget screen, {
  required Size size,
  required double textScale,
  bool disableAnimations = true,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: disableAnimations);
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(data: mediaQuery, child: screen),
    ),
  );
  await tester.pumpAndSettle();
}
