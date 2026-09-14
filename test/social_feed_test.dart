import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/social_feed/social_compose_screen.dart';
import 'package:templates/features/templates/social_feed/social_feed_home_screen.dart';
import 'package:templates/features/templates/social_feed/social_feed_theme.dart';
import 'package:templates/features/templates/social_feed/social_thread_screen.dart';

void main() {
  test('social feed palettes keep readable text and controls', () {
    for (final brightness in Brightness.values) {
      final colors = SocialFeedTheme.build(brightness).colorScheme;
      expect(_contrastRatio(colors.onSurface, colors.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(colors.outline, colors.surface), greaterThanOrEqualTo(3));
    }
  });

  testWidgets('social feed supports tabs, reactions, threads, replies, and publishing', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: SocialFeedHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('What people are building right now.'), findsOneWidget);
    await tester.tap(find.text('Following'));
    await tester.pumpAndSettle();
    expect(find.text('The latest from people you chose.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(
      find.text('Small interfaces become memorable when every motion explains where the content came from.'),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SocialThreadScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Exactly. Motion should clarify.');
    await tester.tap(find.byTooltip('Send reply'));
    await tester.pump();
    expect(find.text('Reply published'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Create a post'));
    await tester.pumpAndSettle();
    expect(find.byType(SocialComposeScreen), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey<String>('social-composer')), 'A new idea, shared clearly.');
    await tester.pump();
    await tester.tap(find.text('Publish'));
    await tester.pumpAndSettle();
    expect(find.text('A new idea, shared clearly.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('social feed follows its requested dark appearance', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SocialFeedHomeScreen(appearance: AppAppearance.dark)));
    await tester.pump();

    expect(Theme.of(tester.element(find.text('SOCIAL FEED'))).brightness, Brightness.dark);

    await tester.tap(
      find.text('Small interfaces become memorable when every motion explains where the content came from.'),
    );
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('Thread'))).brightness, Brightness.dark);
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = math.max(foreground.computeLuminance(), background.computeLuminance());
  final darker = math.min(foreground.computeLuminance(), background.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}
