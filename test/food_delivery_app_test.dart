import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/food_delivery_app/food_delivery_home_screen.dart';
import 'package:templates/features/templates/food_delivery_app/models/meal.dart';
import 'package:templates/features/templates/food_delivery_app/sections/delivery_basket_section.dart';
import 'package:templates/features/templates/food_delivery_app/widgets/delivery_bottom_bar.dart';
import 'package:templates/features/templates/food_delivery_app/widgets/delivery_basket_item.dart';
import 'package:templates/features/templates/food_delivery_app/widgets/delivery_gallery_preview.dart';

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
    await tester.tap(find.text('Basket'));
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

  testWidgets('delivery order journey exposes its state transition', (WidgetTester tester) async {
    await _pumpDelivery(tester);

    await tester.tap(find.text('Order'));
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
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: DeliveryGalleryPreview())),
      ),
    );

    expect(find.text('SAVOR'), findsOneWidget);
    expect(find.text('Good food, right on time.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('delivery remains usable on compact maximum-text layouts', (WidgetTester tester) async {
    await _pumpDelivery(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['Order', 'Basket', 'Discover']) {
      final navigationScroll = find.descendant(of: find.byType(DeliveryBottomBar), matching: find.byType(Scrollable));
      await tester.scrollUntilVisible(find.textContaining(label), 160, scrollable: navigationScroll);
      await tester.tap(find.textContaining(label).hitTestable());
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
}

Future<void> _pumpDelivery(WidgetTester tester, {Size size = const Size(430, 932), double textScale = 1}) async {
  await _pumpDeliveryScreen(tester, const FoodDeliveryHomeScreen(), size: size, textScale: textScale);
}

Future<void> _pumpDeliveryScreen(
  WidgetTester tester,
  Widget screen, {
  required Size size,
  required double textScale,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(tester.view).copyWith(textScaler: TextScaler.linear(textScale));
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(data: mediaQuery, child: screen),
    ),
  );
  await tester.pumpAndSettle();
}
