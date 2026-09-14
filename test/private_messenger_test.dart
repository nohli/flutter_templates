import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/private_messenger/private_chat_screen.dart';
import 'package:templates/features/templates/private_messenger/private_messenger_home_screen.dart';
import 'package:templates/features/templates/private_messenger/private_messenger_theme.dart';
import 'package:templates/features/templates/private_messenger/widgets/private_conversation_tile.dart';

void main() {
  test('private messenger palettes keep text and controls readable', () {
    for (final brightness in Brightness.values) {
      final colors = PrivateMessengerTheme.build(brightness).colorScheme;
      expect(_contrastRatio(colors.onSurface, colors.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.outline, colors.surface), greaterThanOrEqualTo(3));
    }
  });

  testWidgets('private messenger opens a chat and sends a message', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: PrivateMessengerHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Messages'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsNothing);
    await tester.tap(find.byType(PrivateConversationTile).first);
    await tester.pumpAndSettle();

    expect(find.byType(PrivateChatScreen), findsOneWidget);
    expect(find.text('The garden table is booked 🌿'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey<String>('private-chat-composer')), 'I’ll see you at seven.');
    await tester.pump();
    expect(find.byIcon(Icons.send_rounded), findsOneWidget);
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();

    expect(find.text('I’ll see you at seven.'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('private messenger switches between its main destinations', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: PrivateMessengerHomeScreen()));
    await tester.pumpAndSettle();

    for (final destination in <({String label, String content})>[
      (label: 'Updates', content: 'Status updates'),
      (label: 'Communities', content: 'Neighbourhood Garden'),
      (label: 'Calls', content: 'Group video'),
      (label: 'Chats', content: 'Jules'),
    ]) {
      final destinationTab = find.bySemanticsLabel(destination.label).last;
      await tester.tap(destinationTab);
      await tester.pumpAndSettle();
      expect(find.textContaining(destination.content), findsWidgets);
      expect(
        tester.getSemantics(destinationTab),
        matchesSemantics(
          label: destination.label,
          hasSelectedState: true,
          isSelected: true,
          isButton: true,
          hasTapAction: true,
        ),
      );
      expect(tester.takeException(), isNull);
    }
    semantics.dispose();
  });

  testWidgets('private messenger follows its requested dark appearance', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrivateMessengerHomeScreen(appearance: AppAppearance.dark)));
    await tester.pump();

    expect(Theme.of(tester.element(find.text('Messages'))).brightness, Brightness.dark);

    await tester.tap(find.byType(PrivateConversationTile).first);
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('online'))).brightness, Brightness.dark);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = math.max(foreground.computeLuminance(), background.computeLuminance());
  final darker = math.min(foreground.computeLuminance(), background.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}
