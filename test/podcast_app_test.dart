import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/podcast_app/models/podcast_show.dart';
import 'package:templates/features/templates/podcast_app/podcast_home_screen.dart';
import 'package:templates/features/templates/podcast_app/widgets/podcast_gallery_preview.dart';
import 'package:templates/features/templates/podcast_app/widgets/podcast_mini_player.dart';
import 'package:templates/features/templates/podcast_app/widgets/podcast_navigation_drawer.dart';
import 'package:templates/features/templates/shared/template_gallery_preview.dart';
import 'package:templates/features/templates/podcast_app/widgets/podcast_show_card.dart';

void main() {
  test('podcast samples expose unique identifiers and useful metadata', () {
    expect(PodcastShow.samples, hasLength(4));
    expect(PodcastShow.samples.map((PodcastShow show) => show.id).toSet(), hasLength(4));
    expect(PodcastShow.samples.every((PodcastShow show) => show.durationMinutes > 0), isTrue);
  });

  testWidgets('podcast discovery filters by category and search', (WidgetTester tester) async {
    await _pumpPodcast(tester);

    tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Science')).onSelected!(true);
    await tester.pump();
    expect(_showCard('Field Notes'), findsOneWidget);
    expect(_showCard('Small Wonders'), findsNothing);

    tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'All')).onSelected!(true);
    await tester.enterText(find.byType(TextField), 'cities');
    await tester.pump();
    expect(_showCard('After Hours'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pump();
    expect(find.text('No matching shows'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast library saves, downloads, and removes a show', (WidgetTester tester) async {
    await _pumpPodcast(tester);

    await tester.tap(find.byTooltip('Save Small Wonders to library'));
    await tester.pump();
    await _openMenuAndSelect(tester, 'Library');
    expect(_showCard('Small Wonders'), findsOneWidget);

    await tester.tap(find.text('Download sample'));
    await tester.pump();
    expect(find.text('Downloaded'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Small Wonders from library'));
    await tester.pump();
    expect(find.text('Build your listening queue'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast player exposes truthful local playback controls', (WidgetTester tester) async {
    await _pumpPodcast(tester);

    await tester.tap(find.byTooltip('Play Small Wonders'));
    await tester.pump();
    expect(find.text('Now playing'), findsOneWidget);
    expect(find.byTooltip('Pause episode'), findsOneWidget);

    tester.widget<Slider>(find.byType(Slider)).onChanged!(0.6);
    await tester.pump();
    expect(find.text('19 min'), findsOneWidget);

    await tester.tap(find.text('1.0×'));
    await tester.pump();
    expect(find.text('1.25×'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause episode'));
    await tester.pump();
    expect(find.byTooltip('Play episode'), findsOneWidget);

    await tester.tap(find.byTooltip('More playback options'));
    await tester.pump();
    expect(find.text('Playback options are shown as an interface preview.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast gallery preview remains legible at compact card size', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: PodcastGalleryPreview())),
      ),
    );

    expect(find.text('Wave'), findsOneWidget);
    expect(find.text('Small Wonders'), findsOneWidget);
    expect(find.byType(TemplatePreviewDevice), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast remains usable on compact maximum-text layouts', (WidgetTester tester) async {
    await _pumpPodcast(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['Library', 'Now playing', 'Discover']) {
      await _openMenuAndSelect(tester, label);
      expect(tester.takeException(), isNull, reason: label);
    }

    await _pumpPodcastScreen(
      tester,
      SingleChildScrollView(
        child: PodcastShowCard(show: PodcastShow.samples.first, isSaved: false, onPlay: () {}, onToggleSaved: () {}),
      ),
      size: const Size(320, 568),
      textScale: 3.2,
    );
    expect(_showCard('Small Wonders'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast drawer and mini player preserve playback context', (WidgetTester tester) async {
    await _pumpPodcast(tester);

    await tester.tap(find.byTooltip('Play Small Wonders'));
    await tester.pump();
    await _openMenuAndSelect(tester, 'Discover');

    expect(find.byType(PodcastMiniPlayer), findsOneWidget);
    expect(find.byTooltip('Pause mini player'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause mini player'));
    await tester.pump();
    expect(find.byTooltip('Play mini player'), findsOneWidget);
  });

  testWidgets('podcast appearance can switch to dark mode', (WidgetTester tester) async {
    await _pumpPodcast(tester);

    await tester.tap(find.byTooltip('Appearance: Light'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    expect(Theme.of(tester.element(find.text('Wave'))).brightness, Brightness.dark);
  });
}

Finder _showCard(String title) {
  return find.byWidgetPredicate((Widget widget) => widget is PodcastShowCard && widget.show.title == title);
}

Future<void> _openMenuAndSelect(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip('Open listening menu'));
  await tester.pumpAndSettle();
  expect(find.byType(PodcastNavigationDrawer), findsOneWidget);
  final scaffold = find.descendant(of: find.byType(PodcastHomeScreen), matching: find.byType(Scaffold));
  expect(PrimaryScrollController.of(tester.element(scaffold)).positions, hasLength(1));
  final drawerScroll = find.descendant(of: find.byType(PodcastNavigationDrawer), matching: find.byType(Scrollable));
  final destination = find.descendant(of: find.byType(PodcastNavigationDrawer), matching: find.text(label));
  await tester.scrollUntilVisible(destination, 120, scrollable: drawerScroll);
  final destinationTile = find.ancestor(of: destination, matching: find.byType(ListTile));
  for (var attempt = 0; attempt < 8; attempt++) {
    final viewport = tester.getRect(drawerScroll);
    final center = tester.getCenter(destinationTile);
    if (viewport.contains(center)) {
      break;
    }
    await tester.drag(drawerScroll, Offset(0, center.dy > viewport.bottom ? -120 : 120));
    await tester.pumpAndSettle();
  }
  expect(tester.getRect(drawerScroll).contains(tester.getCenter(destinationTile)), isTrue);
  await tester.tapAt(tester.getCenter(destinationTile));
  await tester.pumpAndSettle();
  expect(find.byType(PodcastNavigationDrawer), findsNothing);
}

Future<void> _pumpPodcast(WidgetTester tester, {Size size = const Size(430, 932), double textScale = 1}) async {
  await _pumpPodcastScreen(tester, const PodcastHomeScreen(), size: size, textScale: textScale);
}

Future<void> _pumpPodcastScreen(
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
