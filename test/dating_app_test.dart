import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/features/gallery/template_gallery_artwork.dart';
import 'package:templates/features/templates/dating_app/dating_app_theme.dart';
import 'package:templates/features/templates/dating_app/dating_chat_screen.dart';
import 'package:templates/features/templates/dating_app/dating_home_screen.dart';
import 'package:templates/features/templates/dating_app/dating_inbox_screen.dart';
import 'package:templates/features/templates/dating_app/models/dating_conversation.dart';
import 'package:templates/features/templates/dating_app/models/dating_profile.dart';
import 'package:templates/features/templates/dating_app/widgets/dating_action_bar.dart';
import 'package:templates/features/templates/dating_app/widgets/dating_conversation_tile.dart';

void main() {
  test('dating profiles have stable identities and complete prompts', () {
    expect(DatingProfile.samples, hasLength(4));
    expect(
      DatingProfile.samples.map((DatingProfile profile) => profile.id).toSet(),
      hasLength(DatingProfile.samples.length),
    );
    expect(
      DatingProfile.samples.every(
        (DatingProfile profile) =>
            profile.name.isNotEmpty && profile.answer.isNotEmpty && profile.interests.length >= 3,
      ),
      isTrue,
    );
    expect(DatingConversation.samples, hasLength(4));
    expect(DatingConversation.samples.every((conversation) => conversation.messages.isNotEmpty), isTrue);
    expect(DatingConversation.samples.map((conversation) => conversation.id).toSet(), hasLength(4));
    expect(DatingConversation.samples.first.copyWith().unreadCount, 2);
    expect(DatingConversation.samples.first.copyWith(unreadCount: 0).unreadCount, 0);
  });

  testWidgets('dating choices advance profiles and support one-step undo', (WidgetTester tester) async {
    await _pumpDating(tester);

    expect(find.text('Mina, 29'), findsOneWidget);
    await tester.tap(find.byTooltip('Like profile'));
    await tester.pumpAndSettle();
    expect(find.text('Noah, 31'), findsOneWidget);
    expect(find.text('You liked Mina. We’ll let you know if it’s mutual.'), findsOneWidget);

    await tester.tap(find.byTooltip('Undo last choice'));
    await tester.pumpAndSettle();
    expect(find.text('Mina, 29'), findsOneWidget);
    expect(find.text('Your last choice was restored.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating pass action is visible and chat sends a local message', (WidgetTester tester) async {
    await _pumpDating(tester, disableAnimations: false);

    final passIcon = tester.widget<Icon>(
      find.descendant(of: find.byType(DatingActionBar), matching: find.byIcon(Icons.close_rounded)),
    );
    expect(passIcon.color, DatingAppTheme.coral);
    final passButton = tester.widget<IconButton>(
      find.ancestor(of: find.byIcon(Icons.close_rounded), matching: find.byType(IconButton)).first,
    );
    expect(passButton.style?.shape?.resolve(<WidgetState>{}), isA<CircleBorder>());

    await tester.tap(find.byTooltip('Open conversations'));
    await tester.pumpAndSettle();
    expect(find.byType(DatingInboxScreen), findsOneWidget);
    expect(find.text('A little closer.'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Open conversation with Ari'));
    await tester.pumpAndSettle();
    expect(find.byType(DatingChatScreen), findsOneWidget);
    expect(find.text('Deal. I know exactly the place.'), findsOneWidget);
    await tester.tap(find.byTooltip('Conversation details'));
    await tester.pump();
    expect(find.text('Conversation details are ready to connect.'), findsOneWidget);

    final sendButton = find.byTooltip('Send message');
    final sendAction = find.ancestor(of: find.byIcon(Icons.arrow_upward_rounded), matching: find.byType(IconButton));
    expect(find.descendant(of: find.byType(TextField), matching: sendButton), findsNothing);
    expect(tester.getTopLeft(sendButton).dx, greaterThan(tester.getTopRight(find.byType(TextField)).dx));
    final disabledSend = tester.widget<IconButton>(sendAction);
    expect(disabledSend.onPressed, isNull);
    expect(disabledSend.style?.side?.resolve(<WidgetState>{WidgetState.disabled})?.width, 1);
    await tester.enterText(find.byType(TextField), 'Thursday works. See you there.');
    await tester.pump();
    expect(tester.widget<IconButton>(sendAction).onPressed, isNotNull);
    await tester.tap(sendButton);
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);
    expect(find.text('Thursday works. See you there.'), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back to conversations'));
    await tester.pumpAndSettle();
    expect(find.byType(DatingInboxScreen), findsOneWidget);
    final ariConversation = find.widgetWithText(DatingConversationTile, 'Ari');
    expect(find.descendant(of: ariConversation, matching: find.text('2')), findsNothing);
    await tester.tap(find.byTooltip('Back to discovery'));
    await tester.pumpAndSettle();
    expect(find.text('Mina, 29'), findsOneWidget);
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating chat remains usable at compact maximum text size', (WidgetTester tester) async {
    await _pumpDating(tester, size: const Size(320, 568), textScale: 3.2);

    await tester.tap(find.byTooltip('Open conversations'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Open conversation with Ari'));
    await tester.pumpAndSettle();
    expect(find.byType(DatingChatScreen), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.getRect(find.byType(TextField)).overlaps(const Rect.fromLTWH(0, 0, 320, 568)), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating profiles follow the drag, commit decisions, and spring back below the threshold', (
    WidgetTester tester,
  ) async {
    await _pumpDating(tester, disableAnimations: false);

    final mina = find.bySemanticsLabel('Swipe Mina left to pass or right to like');
    final profileName = find.text('Mina, 29');
    final restingPosition = tester.getTopLeft(profileName);
    final gesture = await tester.startGesture(tester.getCenter(mina));
    await gesture.moveBy(const Offset(-24, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-48, 0));
    await tester.pump();
    expect(tester.getTopLeft(profileName).dx, lessThan(restingPosition.dx - 30));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(profileName), restingPosition);
    expect(find.text('Mina, 29'), findsOneWidget);
    expect(find.textContaining('Passed on Mina'), findsNothing);

    await tester.drag(mina, const Offset(-180, 0));
    await tester.pumpAndSettle();
    expect(find.text('Noah, 31'), findsOneWidget);
    expect(find.text('Passed on Mina. Your next introduction is ready.'), findsOneWidget);

    final noah = find.bySemanticsLabel('Swipe Noah left to pass or right to like');
    await tester.drag(noah, const Offset(180, 0));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Swipe Eli left to pass or right to like'), findsOneWidget);
    expect(find.text('Eli, 28'), findsOneWidget);
    expect(find.text('You liked Noah. We’ll let you know if it’s mutual.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating actions report truthful state in host-selected appearances', (WidgetTester tester) async {
    await _pumpDating(tester);

    expect(Theme.of(tester.element(find.text('Dating'))).brightness, Brightness.dark);
    await tester.tap(find.byTooltip('Send a spark'));
    await tester.pumpAndSettle();
    expect(find.text('A spark was sent to Mina.'), findsOneWidget);

    await _pumpDating(tester, appearance: AppAppearance.light);
    expect(Theme.of(tester.element(find.text('Dating'))).brightness, Brightness.light);
    await tester.tap(find.byTooltip('Open conversations'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Open conversation with Ari'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('Ari'))).brightness, Brightness.light);
  });

  testWidgets('dating inbox lets people choose a conversation', (WidgetTester tester) async {
    await _pumpDating(tester);

    await tester.tap(find.byTooltip('Open conversations'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Open conversation with Ari'), findsOneWidget);
    expect(find.bySemanticsLabel('Open conversation with Mina'), findsOneWidget);
    expect(find.bySemanticsLabel('Open conversation with Noah'), findsOneWidget);
    expect(find.bySemanticsLabel('Open conversation with Zoë'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Open conversation with Noah'));
    await tester.pumpAndSettle();
    expect(find.byType(DatingChatScreen), findsOneWidget);
    expect(find.text('Noah'), findsOneWidget);
    expect(find.text('Save me the weirdest sleeve in the window.'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).decoration?.hintText, 'Message Noah');
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating gallery artwork uses its real editorial profile', (WidgetTester tester) async {
    final item = TemplateGalleryItem.items.singleWhere((item) => item.destination == TemplateGalleryDestination.dating);
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(width: 214, height: 143, child: TemplateGalleryArtwork(item: item)),
        ),
      ),
    );

    final imagePaths = tester
        .widgetList<Image>(find.descendant(of: find.byType(TemplateGalleryArtwork), matching: find.byType(Image)))
        .map((image) => (image.image as AssetImage).assetName);
    expect(imagePaths, everyElement('assets/gallery/dating-screen.png'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating profile content remains reachable at compact maximum text size', (WidgetTester tester) async {
    await _pumpDating(tester, size: const Size(320, 568), textScale: 3.2);

    final destination = find.text('Thursday social');
    final scrollable = find.descendant(
      of: find.byType(DatingHomeScreen),
      matching: find.byWidgetPredicate(
        (Widget widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    await tester.dragUntilVisible(destination, scrollable, const Offset(0, -260));
    await tester.pump();
    expect(destination, findsOneWidget);
    expect(tester.getRect(destination).overlaps(const Rect.fromLTWH(0, 0, 320, 568)), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating profile fits the iPhone 17 viewport in both appearances', (WidgetTester tester) async {
    for (final appearance in AppAppearance.values) {
      await _pumpDating(tester, size: const Size(402, 874), appearance: appearance);
      expect(find.text('Mina, 29'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

Future<void> _pumpDating(
  WidgetTester tester, {
  Size size = const Size(430, 932),
  double textScale = 1,
  AppAppearance appearance = AppAppearance.dark,
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
      home: MediaQuery(
        data: mediaQuery,
        child: DatingHomeScreen(appearance: appearance),
      ),
    ),
  );
  if (disableAnimations) {
    await tester.pump();
  } else {
    await tester.pumpAndSettle();
  }
}
