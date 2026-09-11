import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/shared/template_gallery_preview.dart';
import 'package:templates/features/templates/travel_app/models/travel_day.dart';
import 'package:templates/features/templates/travel_app/travel_home_screen.dart';
import 'package:templates/features/templates/travel_app/widgets/travel_gallery_preview.dart';

void main() {
  test('travel itinerary samples have stable unique stops', () {
    final stops = TravelDay.samples.expand((TravelDay day) => day.stops).toList(growable: false);

    expect(TravelDay.samples, hasLength(3));
    expect(stops.map((TravelStop stop) => stop.id).toSet(), hasLength(stops.length));
    expect(stops.every((TravelStop stop) => stop.time.isNotEmpty && stop.place.isNotEmpty), isTrue);
  });

  testWidgets('travel planner switches days and saves itinerary stops', (WidgetTester tester) async {
    await _pumpTravel(tester);

    await tester.tap(find.text('Sat'));
    await tester.pumpAndSettle();
    expect(find.text('Cloud forest to the Atlantic'), findsOneWidget);
    expect(find.text('Sunrise above the clouds'), findsOneWidget);

    await tester.tap(find.byTooltip('Save Sunrise above the clouds'));
    await tester.pump();
    expect(find.byTooltip('Remove Sunrise above the clouds from saved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('travel map and appearance controls remain truthful', (WidgetTester tester) async {
    await _pumpTravel(tester);

    await tester.tap(find.byTooltip('Open trip map'));
    await tester.pump();
    expect(find.text('The trip map is shown as an interface preview.'), findsOneWidget);

    await tester.tap(find.byTooltip('Appearance: Light'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('Roam'))).brightness, Brightness.dark);
  });

  testWidgets('travel gallery preview uses its own map composition', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: TravelGalleryPreview())),
      ),
    );

    expect(find.text('Roam'), findsOneWidget);
    expect(find.byType(TravelGalleryPreview), findsOneWidget);
    expect(find.byType(TemplatePreviewDevice), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('travel timeline remains usable at compact maximum text size', (WidgetTester tester) async {
    await _pumpTravel(tester, size: const Size(320, 568), textScale: 3.2);

    final lastStop = find.text('Dinner above the harbour');
    final itinerary = find.descendant(
      of: find.byType(TravelHomeScreen),
      matching: find.byWidgetPredicate(
        (Widget widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    await tester.dragUntilVisible(lastStop, itinerary, const Offset(0, -240));
    await tester.pump();
    expect(lastStop, findsOneWidget);
    expect(tester.getRect(lastStop).overlaps(const Rect.fromLTWH(0, 0, 320, 568)), isTrue);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpTravel(WidgetTester tester, {Size size = const Size(430, 932), double textScale = 1}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: true);
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(data: mediaQuery, child: const TravelHomeScreen()),
    ),
  );
  await tester.pump();
}
