import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/smart_home_app/models/smart_device.dart';
import 'package:templates/features/templates/smart_home_app/smart_home_screen.dart';
import 'package:templates/features/templates/smart_home_app/widgets/device_card.dart';
import 'package:templates/features/templates/smart_home_app/widgets/smart_home_bottom_bar.dart';
import 'package:templates/features/templates/smart_home_app/widgets/smart_home_gallery_preview.dart';

void main() {
  test('smart-home sample devices expose unique identifiers and valid power values', () {
    expect(SmartDevice.samples, hasLength(5));
    expect(SmartDevice.samples.map((SmartDevice device) => device.id).toSet(), hasLength(5));
    expect(SmartDevice.samples.every((SmartDevice device) => device.watts >= 0), isTrue);
    expect(SmartDevice.samples.first.copyWith(isOn: false).isOn, isFalse);
  });

  testWidgets('smart home toggles devices and applies complete scenes', (WidgetTester tester) async {
    await _pumpSmartHome(tester);

    expect(find.text('3 devices active · All systems normal'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Turn off Pendant lights'));
    await tester.pump();
    expect(find.text('2 devices active · All systems normal'), findsOneWidget);

    tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Night')).onSelected!(true);
    await tester.pump();
    final purifier = tester
        .widgetList<DeviceCard>(find.byType(DeviceCard))
        .singleWhere((DeviceCard card) => card.device.name == 'Air purifier');
    expect(purifier.device.isOn, isTrue);
    expect(find.text('2 devices active · All systems normal'), findsOneWidget);

    tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Focus')).onSelected!(true);
    await tester.pump();
    final focusedPendant = tester
        .widgetList<DeviceCard>(find.byType(DeviceCard))
        .singleWhere((DeviceCard card) => card.device.name == 'Pendant lights');
    expect(focusedPendant.device.isOn, isFalse);

    tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Arrive home')).onSelected!(true);
    await tester.pump();
    expect(find.text('3 devices active · All systems normal'), findsOneWidget);

    await tester.tap(find.byTooltip('Home notifications'));
    await tester.pump();
    expect(find.text('Your sample home is running smoothly.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('smart home filters room controls and keeps them interactive', (WidgetTester tester) async {
    await _pumpSmartHome(tester);

    await tester.tap(find.text('Rooms'));
    await tester.pump();
    tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Kitchen')).onSelected!(true);
    await tester.pump();
    expect(find.text('Coffee station'), findsOneWidget);
    expect(find.text('1 connected device'), findsOneWidget);

    final coffeeStation = tester
        .widgetList<DeviceCard>(find.byType(DeviceCard))
        .singleWhere((DeviceCard card) => card.device.name == 'Coffee station');
    coffeeStation.onChanged(true);
    await tester.pump();
    final updatedCoffeeStation = tester
        .widgetList<DeviceCard>(find.byType(DeviceCard))
        .singleWhere((DeviceCard card) => card.device.name == 'Coffee station');
    expect(updatedCoffeeStation.device.isOn, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('smart-home energy controls update visible local state', (WidgetTester tester) async {
    await _pumpSmartHome(tester);

    await tester.tap(find.text('Energy'));
    await tester.pump();
    expect(find.text('718 W'), findsOneWidget);

    tester.widget<Slider>(find.byType(Slider)).onChanged!(210);
    await tester.pump();
    expect(find.text('210 kWh'), findsOneWidget);

    final economyMode = find.widgetWithText(SwitchListTile, 'Economy mode');
    expect(tester.widget<SwitchListTile>(economyMode).value, isTrue);
    await tester.tap(economyMode);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(economyMode).value, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('smart-home gallery preview remains legible at compact card size', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: SmartHomeGalleryPreview())),
      ),
    );

    expect(find.text('HOMELINE'), findsOneWidget);
    expect(find.text('Everything feels just right.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('smart home remains usable on compact maximum-text layouts', (WidgetTester tester) async {
    await _pumpSmartHome(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['Rooms', 'Energy', 'Home']) {
      final navigationScroll = find.descendant(of: find.byType(SmartHomeBottomBar), matching: find.byType(Scrollable));
      await tester.scrollUntilVisible(find.text(label), 160, scrollable: navigationScroll);
      await tester.tap(find.text(label).hitTestable());
      await tester.pump();
      expect(tester.takeException(), isNull, reason: label);
    }

    await _pumpSmartHomeScreen(
      tester,
      SingleChildScrollView(
        child: DeviceCard(device: SmartDevice.samples.first, onChanged: (_) {}),
      ),
      size: const Size(320, 568),
      textScale: 3.2,
    );
    expect(find.text('Pendant lights'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpSmartHome(WidgetTester tester, {Size size = const Size(430, 932), double textScale = 1}) async {
  await _pumpSmartHomeScreen(tester, const SmartHomeScreen(), size: size, textScale: textScale);
}

Future<void> _pumpSmartHomeScreen(
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
