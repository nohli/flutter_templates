import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/social_app/models/social_post.dart';
import 'package:templates/features/templates/social_app/social_home_screen.dart';
import 'package:templates/features/templates/social_app/widgets/social_action_bar.dart';
import 'package:templates/features/templates/social_app/widgets/social_gallery_preview.dart';

void main() {
  test('social sample posts expose stable identifiers and artwork', () {
    expect(SocialPost.samples, hasLength(3));
    expect(SocialPost.samples.map((SocialPost post) => post.id).toSet(), hasLength(3));
    expect(SocialPost.samples.map((SocialPost post) => post.artwork).toSet(), SocialPostArtwork.values.toSet());
  });

  testWidgets('social feed supports like, save, and preview actions', (WidgetTester tester) async {
    await _pumpSocial(tester);

    final post = SocialPost.samples.first;
    await tester.tap(find.byTooltip('Like ${post.author}’s post'));
    await tester.pump();
    expect(find.byTooltip('Unlike ${post.author}’s post'), findsOneWidget);
    expect(find.text('${post.likes + 1} appreciations'), findsOneWidget);

    await tester.tap(find.byTooltip('Save ${post.author}’s post'));
    await tester.pump();
    expect(find.byTooltip('Remove ${post.author}’s post from saved'), findsOneWidget);

    await tester.tap(find.byTooltip('Comment on ${post.author}’s post'));
    await tester.pump();
    expect(find.text('Comments are shown as an interface preview.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('social discovery and profile controls retain local state', (WidgetTester tester) async {
    await _pumpSocial(tester);

    await tester.tap(find.byTooltip('Discover'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Follow').first);
    await tester.pump();
    expect(find.widgetWithText(FilledButton, 'Following'), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pump();
    final privateProfile = find.widgetWithText(SwitchListTile, 'Private profile');
    expect(tester.widget<SwitchListTile>(privateProfile).value, isFalse);
    await tester.tap(privateProfile);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(privateProfile).value, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('social gallery preview uses an expressive collage composition', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: SocialGalleryPreview())),
      ),
    );

    expect(find.text('MINGLE!'), findsOneWidget);
    expect(find.text('GOOD PEOPLE / GOOD ENERGY'), findsOneWidget);
    expect(find.bySemanticsLabel('Mingle expressive social collage preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('social community remains usable at compact maximum text size', (WidgetTester tester) async {
    await _pumpSocial(tester, size: const Size(320, 568), textScale: 3.2);

    const sectionMarkers = <String, String>{
      'Discover': 'FIND YOUR\nPEOPLE.',
      'Profile': 'Ana Rivera',
      'Feed': 'Good people. Good energy.',
    };
    for (final MapEntry(key: label, value: marker) in sectionMarkers.entries) {
      await tester.tap(find.descendant(of: find.byType(SocialActionBar), matching: find.byTooltip(label)));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: label);
      expect(find.text(marker), findsOneWidget, reason: label);
    }
  });

  testWidgets('social action bar creates a sample post in the externally selected dark mode', (
    WidgetTester tester,
  ) async {
    await _pumpSocial(tester, appearance: AppAppearance.dark);

    await tester.tap(find.byTooltip('Create post'));
    await tester.pump();
    expect(find.text('Post creation is shown as an interface preview.'), findsOneWidget);

    expect(Theme.of(tester.element(find.text('Mingle'))).brightness, Brightness.dark);
  });

  testWidgets('social template returns to its gallery route', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) => TextButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SocialHomeScreen())),
            child: const Text('Open social template'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open social template'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back to template gallery'));
    await tester.pumpAndSettle();

    expect(find.text('Open social template'), findsOneWidget);
    expect(find.byType(SocialHomeScreen), findsNothing);
  });
}

Future<void> _pumpSocial(
  WidgetTester tester, {
  Size size = const Size(430, 932),
  double textScale = 1,
  AppAppearance appearance = AppAppearance.light,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: true);
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: mediaQuery,
        child: SocialHomeScreen(appearance: appearance),
      ),
    ),
  );
  await tester.pump();
}
