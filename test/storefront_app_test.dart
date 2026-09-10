import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/storefront_app/models/store_product.dart';
import 'package:templates/features/templates/storefront_app/storefront_home_screen.dart';
import 'package:templates/features/templates/storefront_app/widgets/storefront_bottom_bar.dart';
import 'package:templates/features/templates/storefront_app/widgets/storefront_gallery_preview.dart';

void main() {
  test('storefront sample products have stable unique identifiers', () {
    expect(StoreProduct.samples, hasLength(4));
    expect(StoreProduct.samples.map((StoreProduct product) => product.id).toSet(), hasLength(4));
    expect(StoreProduct.samples.every((StoreProduct product) => product.price > 0), isTrue);
  });

  testWidgets('storefront filters products by category and search', (WidgetTester tester) async {
    await _pumpStorefront(tester);

    expect(find.text('Nest Chair'), findsOneWidget);
    expect(find.text('Quiet One'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Audio'));
    await tester.pump();
    expect(find.text('Quiet One'), findsOneWidget);
    expect(find.text('Nest Chair'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.enterText(find.byType(TextField), 'halo');
    await tester.pump();
    expect(find.text('Halo Lamp'), findsOneWidget);
    expect(find.text('Quiet One'), findsNothing);

    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pump();
    expect(find.text('No sample products match that search.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('storefront preserves saved items and bag state across tabs', (WidgetTester tester) async {
    await _pumpStorefront(tester);

    await tester.tap(find.byTooltip('Save Nest Chair'));
    await tester.tap(find.byTooltip('Add Quiet One to bag'));
    await tester.pump();
    expect(find.text('Quiet One added to the sample bag.'), findsOneWidget);

    await tester.tap(find.text('Saved'));
    await tester.pump();
    expect(find.text('Nest Chair'), findsOneWidget);

    await tester.tap(find.text('Bag'));
    await tester.pump();
    expect(find.text('Quiet One'), findsOneWidget);
    expect(find.text('Sample total'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Quiet One from bag'));
    await tester.pump();
    expect(find.text('Your bag is ready'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('storefront gallery preview stays legible at compact card size', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: StorefrontGalleryPreview())),
      ),
    );

    expect(find.text('NEST'), findsOneWidget);
    expect(find.text('Calm living'), findsOneWidget);
    expect(find.text('SHOP'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('storefront remains usable on compact and large-text layouts', (WidgetTester tester) async {
    await _pumpStorefront(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['Saved', 'Bag', 'Shop']) {
      final navigationScroll = find.descendant(of: find.byType(StorefrontBottomBar), matching: find.byType(Scrollable));
      await tester.scrollUntilVisible(find.text(label), 160, scrollable: navigationScroll);
      await tester.tap(find.text(label).hitTestable());
      await tester.pump();
      expect(tester.takeException(), isNull, reason: label);
    }
  });
}

Future<void> _pumpStorefront(WidgetTester tester, {Size size = const Size(430, 932), double textScale = 1}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(tester.view).copyWith(textScaler: TextScaler.linear(textScale));
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(data: mediaQuery, child: const StorefrontHomeScreen()),
    ),
  );
  await tester.pumpAndSettle();
}
