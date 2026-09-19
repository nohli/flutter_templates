import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:templates/app/app_appearance.dart';
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
      (cardLabel: 'Channel Messenger', screenText: 'Archived chats'),
      (cardLabel: 'Private Messenger', screenText: 'The garden table is booked 🌿'),
    ];
    expect(
      templates.map((template) => template.cardLabel).toSet(),
      TemplateGalleryItem.items.map((item) => item.title).toSet(),
    );

    for (final appearance in <({Brightness brightness, String label})>[
      (brightness: Brightness.light, label: 'Light'),
      (brightness: Brightness.dark, label: 'Dark'),
    ]) {
      debugPrint('  Select ${appearance.label.toLowerCase()} appearance...');
      await _selectAppearance(tester, appearance.label);
      debugPrint('✓ Selected ${appearance.label.toLowerCase()} appearance');
      await _scrollGalleryToStart(tester, templates.first.cardLabel);
      for (final template in templates) {
        debugPrint('  Open ${template.cardLabel}...');
        await _openTemplate(
          tester,
          brightness: appearance.brightness,
          cardLabel: template.cardLabel,
          screenText: template.screenText,
        );
        debugPrint('✓ Opened ${template.cardLabel}');
      }
    }
  });

  testWidgets('keeps support actions aligned and dark feedback keyboard surroundings themed', (
    WidgetTester tester,
  ) async {
    app.main();
    await _finishAnimations(tester);
    await _selectAppearance(tester, 'Dark');

    double? actionBottom;
    for (final destination in <String>['Help', 'Feedback', 'Invite friends']) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await _finishAnimations(tester);
      await tester.tap(find.text(destination));
      await _finishAnimations(tester);

      final action = find.byType(FilledButton);
      expect(action.hitTestable(), findsOneWidget, reason: destination);
      final actionBounds = tester.getRect(action);
      final screen = find.ancestor(of: action, matching: find.byType(ColoredBox));
      expect(screen, findsOneWidget, reason: destination);
      final screenBounds = tester.getRect(screen);
      actionBottom ??= actionBounds.bottom;
      expect(actionBounds.center.dx, screenBounds.center.dx, reason: destination);
      expect(actionBounds.bottom, actionBottom, reason: destination);
    }

    await tester.tap(find.byTooltip('Open navigation menu'));
    await _finishAnimations(tester);
    await tester.tap(find.text('Feedback'));
    await _finishAnimations(tester);
    await tester.tap(find.byType(TextField));
    await _finishAnimations(tester);

    final colors = Theme.of(tester.element(find.byType(TextField))).colorScheme;
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    final composerSurface = Color.alphaBlend(colors.onSurface.withValues(alpha: 0.16), colors.surface);
    final elevatedComposer = find.byWidgetPredicate((Widget widget) {
      if (widget is! Container) return false;
      final decoration = widget.decoration;
      return decoration is BoxDecoration &&
          decoration.color == composerSurface &&
          decoration.border == null &&
          decoration.boxShadow?.isNotEmpty == true;
    });
    expect(scaffold.backgroundColor, colors.surface);
    expect(elevatedComposer, findsOneWidget);
    expect(find.text('Tell us what you liked or what we could improve.'), findsOneWidget);
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

    await tester.tap(find.widgetWithText(InkWell, 'Channels'));
    await _finishAnimations(tester);
    await tester.tap(find.text('Design Dispatch'));
    await _finishAnimations(tester);
    final reaction = find.widgetWithText(ActionChip, '127');
    await tester.ensureVisible(reaction);
    await _finishAnimations(tester);
    expect(reaction.hitTestable(), findsOneWidget);
    await tester.tap(reaction.hitTestable());
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
  await _tapGalleryCard(tester, cardLabel);
  await _finishAnimations(tester);
}

Future<void> _openTemplate(
  WidgetTester tester, {
  required Brightness brightness,
  required String cardLabel,
  required String screenText,
}) async {
  await _tapGalleryCard(tester, cardLabel);
  await _finishAnimations(tester);

  final screenContent = find.text(screenText);
  expect(screenContent, findsOneWidget);
  expect(Theme.of(tester.element(screenContent)).brightness, brightness);

  await tester.binding.handlePopRoute();
  await _finishAnimations(tester);
  expect(find.bySemanticsLabel(cardLabel), findsOneWidget);
}

Future<void> _tapGalleryCard(WidgetTester tester, String cardLabel) async {
  final card = find.bySemanticsLabel(cardLabel);
  final galleryScroll = find.descendant(of: find.byType(GridView), matching: find.byType(Scrollable)).first;
  await tester.scrollUntilVisible(card, 240, scrollable: galleryScroll);
  await _finishAnimations(tester);

  expect(card.hitTestable(), findsOneWidget);
  await tester.tap(card.hitTestable());
}

Future<void> _scrollGalleryToStart(WidgetTester tester, String firstCardLabel) async {
  final galleryScroll = find.descendant(of: find.byType(GridView), matching: find.byType(Scrollable)).first;
  await tester.scrollUntilVisible(find.bySemanticsLabel(firstCardLabel), -240, scrollable: galleryScroll);
  await _finishAnimations(tester);
}

Future<void> _selectAppearance(WidgetTester tester, String label) async {
  final appearanceButton = find.descendant(of: find.byType(AppAppearanceButton), matching: find.byType(IconButton));
  expect(appearanceButton.hitTestable(), findsOneWidget);
  await tester.tap(appearanceButton.hitTestable());
  await _finishAnimations(tester);
  final option = find.byKey(ValueKey<String>('appearance-${label.toLowerCase()}'));
  expect(option.hitTestable(), findsOneWidget);
  await tester.tap(option.hitTestable());
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
