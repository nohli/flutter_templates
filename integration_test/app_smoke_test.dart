import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:templates/app/app_identity.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/features/templates/private_messenger/widgets/private_conversation_tile.dart';
import 'package:templates/features/templates/shared/animated_favorite_icon.dart';
import 'package:templates/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens every bundled template in light and dark mode', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);

    expect(find.text(AppIdentity.name), findsOneWidget);
    const templates = <({String cardLabel, String screenText})>[
      (cardLabel: 'Hotel Booking', screenText: 'Explore'),
      (cardLabel: 'Fitness App', screenText: 'My Diary'),
      (cardLabel: 'Design Course', screenText: 'Choose your'),
      (cardLabel: 'Personal Finance', screenText: 'Money and crypto, together'),
      (cardLabel: 'Dating & Social', screenText: 'CURATED CONNECTIONS / TONIGHT'),
      (cardLabel: 'Language Learning', screenText: 'Order food with confidence'),
      (cardLabel: 'Public Social Feed', screenText: 'SOCIAL FEED'),
      (cardLabel: 'Banking Super-App', screenText: 'TOTAL BALANCE'),
      (cardLabel: 'Channel Messenger', screenText: 'Channels'),
      (cardLabel: 'Private Messenger', screenText: 'Messages'),
    ];
    expect(
      templates.map((template) => template.cardLabel).toSet(),
      TemplateGalleryItem.items.map((item) => item.title).toSet(),
    );

    for (final appearance in <({Brightness brightness, String label})>[
      (brightness: Brightness.light, label: 'Light'),
      (brightness: Brightness.dark, label: 'Dark'),
    ]) {
      await _selectAppearance(tester, appearance.label);
      for (final template in templates) {
        await _openTemplate(
          tester,
          brightness: appearance.brightness,
          cardLabel: template.cardLabel,
          screenText: template.screenText,
        );
      }
    }
  });

  testWidgets('opens a dating conversation and sends a message', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);

    final card = find.bySemanticsLabel('Dating & Social');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await _finishAnimations(tester);

    await tester.tap(find.byTooltip('Open conversations'));
    await _finishAnimations(tester);
    expect(find.text('Messages'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Open conversation with Ari'));
    await _finishAnimations(tester);
    expect(find.text('You and Ari found a little common ground.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Coffee at six?');
    await tester.tap(find.byTooltip('Send message'));
    await _finishAnimations(tester);
    expect(find.text('Coffee at six?'), findsOneWidget);
  });

  testWidgets('completes a language lesson', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);
    await _openGalleryTemplate(tester, 'Language Learning');

    await tester.tap(find.byKey(const ValueKey<String>('language-current-lesson')));
    await _finishAnimations(tester);
    await tester.tap(find.text('Un café, s’il vous plaît.'));
    await tester.pump();
    expect(find.text('Perfect — that’s a polite way to order.'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await _finishAnimations(tester);
    expect(find.text('Order food with confidence'), findsOneWidget);
  });

  testWidgets('reacts and publishes in the social feed', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);
    await _openGalleryTemplate(tester, 'Public Social Feed');

    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(find.byTooltip('Create a post'));
    await _finishAnimations(tester);
    await tester.enterText(find.byKey(const ValueKey<String>('social-composer')), 'A clear idea from the road.');
    await tester.tap(find.text('Publish'));
    await _finishAnimations(tester);
    expect(find.text('A clear idea from the road.'), findsOneWidget);
  });

  testWidgets('favorites and unfavorites a hotel', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);
    await _openGalleryTemplate(tester, 'Hotel Booking');

    final favorite = find.byTooltip('Favorite Grand Royal Hotel').first;
    await tester.tap(favorite);
    await tester.pump(const Duration(milliseconds: 300));

    final removeFavorite = find.byTooltip('Remove Grand Royal Hotel from favorites').first;
    expect(removeFavorite, findsOneWidget);
    expect(
      tester.widget<Icon>(find.descendant(of: removeFavorite, matching: find.byIcon(Icons.favorite_rounded))),
      isA<Icon>().having((Icon icon) => icon.color, 'color', AnimatedFavoriteIcon.activeColor),
    );

    await tester.tap(removeFavorite);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byTooltip('Favorite Grand Royal Hotel'), findsWidgets);
  });

  testWidgets('sends money in the banking template', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);
    await _openGalleryTemplate(tester, 'Banking Super-App');

    await tester.tap(find.text('Send'));
    await _finishAnimations(tester);
    await tester.tap(find.text('Lea'));
    await tester.enterText(find.byKey(const ValueKey<String>('banking-transfer-amount')), '25');
    await tester.tap(find.text('Send to Lea'));
    await _finishAnimations(tester);
    expect(find.text('Money sent to Lea'), findsOneWidget);
  });

  testWidgets('opens and reacts to a channel', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);
    await _openGalleryTemplate(tester, 'Channel Messenger');

    await tester.tap(find.text('Channels'));
    await _finishAnimations(tester);
    await tester.tap(find.text('Design Dispatch'));
    await _finishAnimations(tester);
    await tester.tap(find.widgetWithText(ActionChip, '127'));
    await tester.pump();
    expect(find.text('128'), findsOneWidget);
  });

  testWidgets('opens a private chat and sends a message', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);
    await _openGalleryTemplate(tester, 'Private Messenger');

    for (final destination in <({String label, String content})>[
      (label: 'Updates', content: 'Status updates'),
      (label: 'Communities', content: 'Neighbourhood Garden'),
      (label: 'Calls', content: 'Group video'),
      (label: 'Chats', content: 'The garden table is booked 🌿'),
    ]) {
      await tester.tap(find.bySemanticsLabel(destination.label).last);
      await _finishAnimations(tester);
      expect(find.textContaining(destination.content), findsWidgets);
    }

    await tester.tap(find.byType(PrivateConversationTile).first);
    await _finishAnimations(tester);
    await tester.enterText(find.byKey(const ValueKey<String>('private-chat-composer')), 'The terrace sounds perfect.');
    await tester.tap(find.byTooltip('Send message'));
    await tester.pump();
    expect(find.text('The terrace sounds perfect.'), findsOneWidget);
  });
}

Future<void> _openGalleryTemplate(WidgetTester tester, String cardLabel) async {
  final card = find.bySemanticsLabel(cardLabel);
  await tester.ensureVisible(card);
  await tester.tap(card);
  await _finishAnimations(tester);
}

Future<void> _openTemplate(
  WidgetTester tester, {
  required Brightness brightness,
  required String cardLabel,
  required String screenText,
}) async {
  final card = find.bySemanticsLabel(cardLabel);
  await tester.ensureVisible(card);
  await tester.tap(card);
  await _finishAnimations(tester);

  final screenContent = find.text(screenText);
  expect(screenContent, findsOneWidget);
  expect(Theme.of(tester.element(screenContent)).brightness, brightness);

  await tester.binding.handlePopRoute();
  await _finishAnimations(tester);
  expect(find.bySemanticsLabel(cardLabel), findsOneWidget);
}

Future<void> _selectAppearance(WidgetTester tester, String label) async {
  final appearanceButton = find.byTooltip(RegExp(r'^Appearance: '));
  await tester.tap(appearanceButton);
  await _finishAnimations(tester);
  await tester.tap(find.byKey(ValueKey<String>('appearance-${label.toLowerCase()}')));
  await _finishAnimations(tester);
  expect(find.byTooltip('Appearance: $label'), findsOneWidget);
}

Future<void> _finishAnimations(WidgetTester tester) async {
  for (var frame = 0; frame < 40; frame++) {
    await tester.pump(const Duration(milliseconds: 25));
  }
  await tester.pump(const Duration(seconds: 2));
  await tester.pump(const Duration(milliseconds: 16));
}
