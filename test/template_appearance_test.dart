import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/features/gallery/template_gallery_artwork.dart';
import 'package:templates/features/templates/ai_assistant_app/widgets/assistant_gallery_preview.dart';
import 'package:templates/features/templates/dating_app/widgets/dating_gallery_preview.dart';
import 'package:templates/features/templates/finance_app/finance_home_screen.dart';
import 'package:templates/features/templates/shared/template_appearance.dart';
import 'package:templates/features/templates/travel_app/widgets/travel_gallery_preview.dart';
import 'package:templates/main.dart';

void main() {
  testWidgets('controlled template appearance follows the selected mode', (WidgetTester tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

    await tester.pumpWidget(
      MaterialApp(
        home: TemplateAppearanceShell(
          appearance: AppAppearance.system,
          themeBuilder: (Brightness brightness) => ThemeData(brightness: brightness),
          builder: (BuildContext context) => const Scaffold(body: Text('Preview')),
        ),
      ),
    );
    expect(Theme.of(tester.element(find.text('Preview'))).brightness, Brightness.dark);

    await tester.pumpWidget(
      MaterialApp(
        home: TemplateAppearanceShell(
          appearance: AppAppearance.light,
          themeBuilder: (Brightness brightness) => ThemeData(brightness: brightness),
          builder: (BuildContext context) => const Scaffold(body: Text('Preview')),
        ),
      ),
    );
    expect(Theme.of(tester.element(find.text('Preview'))).brightness, Brightness.light);
  });

  testWidgets('the gallery owns one appearance control for every new template', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const UiTemplatesApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.byTooltip('Appearance: System'), findsOneWidget);
    await tester.tap(find.byTooltip('Appearance: System'));
    await tester.pumpAndSettle();
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);

    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Appearance: Dark'), findsOneWidget);

    final financeCard = find.bySemanticsLabel('Personal Finance');
    final galleryScroll = find.descendant(of: find.byType(GridView), matching: find.byType(Scrollable));
    await tester.scrollUntilVisible(financeCard, 240, scrollable: galleryScroll);
    await tester.tap(financeCard);
    await tester.pumpAndSettle();

    expect(find.byType(FinanceHomeScreen), findsOneWidget);
    expect(Theme.of(tester.element(find.text('Overview'))).brightness, Brightness.dark);
    expect(find.byTooltip('Appearance: Dark'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every gallery artwork follows the selected appearance', (WidgetTester tester) async {
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          themeAnimationDuration: Duration.zero,
          home: const Column(
            children: <Widget>[
              Expanded(
                child: TemplateGalleryArtwork(
                  item: TemplateGalleryItem(title: 'Travel', destination: TemplateGalleryDestination.travel),
                ),
              ),
              Expanded(
                child: TemplateGalleryArtwork(
                  item: TemplateGalleryItem(title: 'Assistant', destination: TemplateGalleryDestination.aiAssistant),
                ),
              ),
              Expanded(
                child: TemplateGalleryArtwork(
                  item: TemplateGalleryItem(title: 'Dating', destination: TemplateGalleryDestination.dating),
                ),
              ),
            ],
          ),
        ),
      );

      expect(tester.widget<TravelGalleryPreview>(find.byType(TravelGalleryPreview)).brightness, brightness);
      expect(tester.widget<AssistantGalleryPreview>(find.byType(AssistantGalleryPreview)).brightness, brightness);
      expect(tester.widget<DatingGalleryPreview>(find.byType(DatingGalleryPreview)).brightness, brightness);
      expect(tester.takeException(), isNull);
    }
  });
}
