import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/channel_messenger/channel_detail_screen.dart';
import 'package:templates/features/templates/channel_messenger/channel_messenger_home_screen.dart';
import 'package:templates/features/templates/channel_messenger/channel_messenger_theme.dart';

void main() {
  test('channel messenger palettes keep readable text and controls', () {
    for (final brightness in Brightness.values) {
      final colors = ChannelMessengerTheme.build(brightness).colorScheme;
      expect(_contrastRatio(colors.onSurface, colors.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.outline, colors.surface), greaterThanOrEqualTo(3));
    }
  });

  testWidgets('channel messenger filters folders and opens an interactive channel', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: ChannelMessengerHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Studio Crew'), findsOneWidget);
    await tester.tap(find.ancestor(of: find.text('Channels').last, matching: find.byType(InkWell)));
    await tester.pumpAndSettle();
    expect(find.text('Design Dispatch'), findsOneWidget);
    expect(find.text('City Signals'), findsOneWidget);
    expect(find.text('Studio Crew'), findsNothing);

    await tester.tap(find.text('Design Dispatch'));
    await tester.pumpAndSettle();
    expect(find.byType(ChannelDetailScreen), findsOneWidget);
    expect(find.text('127'), findsOneWidget);
    await tester.tap(find.widgetWithText(ActionChip, '127'));
    await tester.pump();
    expect(find.text('128'), findsOneWidget);
    await tester.tap(find.text('Subscribed'));
    await tester.pump();
    expect(find.text('Subscribe'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('channel messenger exposes new conversation choices', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChannelMessengerHomeScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('New message'));
    await tester.pumpAndSettle();
    expect(find.text('Start a conversation'), findsOneWidget);
    expect(find.text('New group'), findsOneWidget);
    expect(find.text('New channel'), findsOneWidget);
  });

  testWidgets('channel messenger follows its requested dark appearance', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChannelMessengerHomeScreen(appearance: AppAppearance.dark)));
    await tester.pump();

    expect(Theme.of(tester.element(find.text('Channels').first)).brightness, Brightness.dark);

    await tester.tap(find.ancestor(of: find.text('Channels').last, matching: find.byType(InkWell)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Design Dispatch'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('12.8K subscribers'))).brightness, Brightness.dark);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = math.max(foreground.computeLuminance(), background.computeLuminance());
  final darker = math.min(foreground.computeLuminance(), background.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}
