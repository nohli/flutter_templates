import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:templates/app/app_identity.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens every bundled template', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);

    expect(find.text(AppIdentity.name), findsOneWidget);
    const templates = <({String cardLabel, String screenText})>[
      (cardLabel: 'Hotel Booking', screenText: 'Explore'),
      (cardLabel: 'Fitness App', screenText: 'My Diary'),
      (cardLabel: 'Design Course', screenText: 'Choose your'),
      (cardLabel: 'Personal Finance', screenText: 'Money and crypto, together'),
      (cardLabel: 'E-commerce Store', screenText: 'Curated objects for calmer spaces.'),
      (cardLabel: 'Project Planner', screenText: 'Make space for what matters.'),
      (cardLabel: 'Food Delivery', screenText: 'Good food, right on time.'),
      (cardLabel: 'Podcast Player', screenText: 'Stories worth your time.'),
      (cardLabel: 'Social Community', screenText: 'Share what feels alive.'),
      (cardLabel: 'Travel Planner', screenText: 'Madeira, mapped beautifully.'),
      (cardLabel: 'AI Assistant', screenText: 'What can I help you create?'),
      (cardLabel: 'Dating & Social', screenText: 'Tonight’s people'),
    ];
    expect(
      templates.map((template) => template.cardLabel).toSet(),
      TemplateGalleryItem.items.map((item) => item.title).toSet(),
    );

    for (final template in templates) {
      await _openTemplate(tester, cardLabel: template.cardLabel, screenText: template.screenText);
    }
  });
}

Future<void> _openTemplate(WidgetTester tester, {required String cardLabel, required String screenText}) async {
  final card = find.bySemanticsLabel(cardLabel);
  await tester.ensureVisible(card);
  await tester.tap(card);
  await _finishAnimations(tester);

  expect(find.text(screenText), findsOneWidget);

  await tester.binding.handlePopRoute();
  await _finishAnimations(tester);
  expect(find.bySemanticsLabel(cardLabel), findsOneWidget);
}

Future<void> _finishAnimations(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 3));
}
