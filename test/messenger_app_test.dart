import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/messenger_app/conversation_screen.dart';
import 'package:templates/features/templates/messenger_app/messenger_home_screen.dart';
import 'package:templates/features/templates/messenger_app/models/conversation.dart';
import 'package:templates/features/templates/messenger_app/widgets/messenger_bottom_bar.dart';
import 'package:templates/features/templates/messenger_app/widgets/messenger_gallery_preview.dart';

void main() {
  test('messenger sample conversations have unique stable identifiers', () {
    expect(Conversation.samples, hasLength(4));
    expect(Conversation.samples.map((Conversation conversation) => conversation.id).toSet(), hasLength(4));
    expect(Conversation.samples.where((Conversation conversation) => conversation.isOnline), hasLength(2));
  });

  testWidgets('messenger filters conversations and exposes an empty state', (WidgetTester tester) async {
    await _pumpMessenger(tester);

    await tester.enterText(find.byType(TextField), 'coffee');
    await tester.pump();
    expect(find.text('Sam Okafor'), findsWidgets);
    expect(find.text('Product team'), findsNothing);

    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pump();
    expect(find.text('No conversations found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('messenger opens a conversation and sends a local message', (WidgetTester tester) async {
    await _pumpMessenger(tester);

    await tester.tap(find.bySemanticsLabel(RegExp(r'^Open conversation with Maya Chen')).first);
    await tester.pumpAndSettle();
    expect(find.byType(ConversationScreen), findsOneWidget);
    expect(find.text('The new direction feels exactly right ✨'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Looks great from here');
    await tester.tap(find.byTooltip('Send message'));
    await tester.pump();
    expect(find.text('Looks great from here'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('messenger people and profile surfaces remain interactive', (WidgetTester tester) async {
    await _pumpMessenger(tester);

    await tester.tap(find.text('People'));
    await tester.pump();
    expect(find.text('A reusable contact directory with presence cues.'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pump();
    final quietHours = find.widgetWithText(SwitchListTile, 'Quiet hours');
    expect(tester.widget<SwitchListTile>(quietHours).value, isFalse);
    await tester.tap(quietHours);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(quietHours).value, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('messenger gallery preview remains legible at compact card size', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: MessengerGalleryPreview())),
      ),
    );

    expect(find.text('LUMA'), findsOneWidget);
    expect(find.text('MC'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('messenger remains usable on compact maximum-text layouts', (WidgetTester tester) async {
    await _pumpMessenger(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['People', 'Profile', 'Chats']) {
      final navigationScroll = find.descendant(of: find.byType(MessengerBottomBar), matching: find.byType(Scrollable));
      await tester.scrollUntilVisible(find.text(label), 160, scrollable: navigationScroll);
      await tester.tap(find.text(label).hitTestable());
      await tester.pump();
      expect(tester.takeException(), isNull, reason: label);
    }

    await _pumpMessengerScreen(
      tester,
      ConversationScreen(conversation: Conversation.samples.first),
      size: const Size(320, 568),
      textScale: 3.2,
    );
    expect(find.byType(ConversationScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpMessenger(WidgetTester tester, {Size size = const Size(430, 932), double textScale = 1}) async {
  await _pumpMessengerScreen(tester, const MessengerHomeScreen(), size: size, textScale: textScale);
}

Future<void> _pumpMessengerScreen(
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
