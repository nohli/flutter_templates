import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/app/app_theme.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/features/gallery/template_gallery_artwork.dart';
import 'package:templates/features/support/about_screen.dart';
import 'package:templates/features/support/feedback_screen.dart';
import 'package:templates/features/support/help_screen.dart';
import 'package:templates/features/support/invite_friend_screen.dart';
import 'package:templates/features/templates/design_course/course_info_screen.dart';
import 'package:templates/features/templates/design_course/design_course_app_theme.dart';
import 'package:templates/features/templates/design_course/home_design_course.dart';
import 'package:templates/features/templates/design_course/models/category.dart';
import 'package:templates/features/templates/finance_app/finance_home_screen.dart';
import 'package:templates/features/templates/shared/template_appearance.dart';
import 'package:templates/main.dart';

void main() {
  testWidgets('controlled template appearance follows the selected mode', (WidgetTester tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

    await tester.pumpWidget(
      MaterialApp(
        home: TemplateAppearanceShell(
          appearance: AppAppearance.system,
          themeBuilder: (Brightness brightness) => ThemeData(brightness: brightness),
          builder: (BuildContext context) => const Scaffold(body: Text('Preview')),
        ),
      ),
    );
    expect(Theme.of(tester.element(find.text('Preview'))).brightness, Brightness.dark);

    await tester.pumpWidget(
      MaterialApp(
        home: TemplateAppearanceShell(
          appearance: AppAppearance.light,
          themeBuilder: (Brightness brightness) => ThemeData(brightness: brightness),
          builder: (BuildContext context) => const Scaffold(body: Text('Preview')),
        ),
      ),
    );
    expect(Theme.of(tester.element(find.text('Preview'))).brightness, Brightness.light);
  });

  testWidgets('template detail routes preserve the active template theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TemplateAppearanceShell(
          appearance: AppAppearance.dark,
          themeBuilder: (Brightness brightness) => ThemeData(
            brightness: brightness,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: brightness),
          ),
          builder: (BuildContext context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                templatePageRoute<void>(
                  context: context,
                  builder: (_) => const Scaffold(body: Text('Detail')),
                ),
              ),
              child: const Text('Open detail'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();

    final detailContext = tester.element(find.text('Detail'));
    expect(Theme.of(detailContext).brightness, Brightness.dark);
    expect(
      Theme.of(detailContext).colorScheme.primary,
      ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark).primary,
    );
  });

  test('Design Course dark palette keeps its cyan identity and accessible semantic colors', () {
    final theme = DesignCourseAppTheme.build(Brightness.dark);
    final colors = theme.colorScheme;

    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, DesignCourseAppTheme.darkBackground);
    expect(colors.surface, DesignCourseAppTheme.darkSurface);
    expect(_contrastRatio(colors.onSurface, colors.surface), greaterThanOrEqualTo(4.5));
    expect(_contrastRatio(colors.onPrimary, colors.primary), greaterThanOrEqualTo(4.5));
    expect(_contrastRatio(colors.outline, colors.surface), greaterThanOrEqualTo(3));
  });

  testWidgets('Design Course home and detail render the selected dark appearance', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);
    final mediaQuery = MediaQueryData.fromView(tester.view).copyWith(disableAnimations: true);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: mediaQuery,
          child: const DesignCourseHomeScreen(appearance: AppAppearance.dark),
        ),
      ),
    );
    await tester.pump();

    expect(Theme.of(tester.element(find.text('Category'))).brightness, Brightness.dark);

    await tester.tap(find.bySemanticsLabel(Category.categoryList.first.accessibilityLabel));
    await tester.pumpAndSettle();

    expect(find.byType(CourseInfoScreen), findsOneWidget);
    expect(Theme.of(tester.element(find.text(Category.categoryList.first.title))).brightness, Brightness.dark);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the gallery owns one appearance control for every new template', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 932);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const UiTemplatesApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.byTooltip('Appearance: System'), findsOneWidget);
    await tester.tap(find.byTooltip('Appearance: System'));
    await tester.pumpAndSettle();
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    final menuItems = find.byType(MenuItemButton);
    expect(menuItems, findsNWidgets(3));
    for (var index = 0; index < 3; index += 1) {
      expect(tester.getSize(menuItems.at(index)).height, 48);
      if (index > 0) {
        expect(tester.getTopLeft(menuItems.at(index)).dy, tester.getBottomLeft(menuItems.at(index - 1)).dy);
      }
    }
    final selectedItem = tester.widget<MenuItemButton>(find.byKey(const ValueKey<String>('appearance-system')));
    expect(selectedItem.style?.backgroundColor?.resolve(<WidgetState>{}), Colors.transparent);
    final selectedLabel = tester.widget<Text>(
      find.descendant(of: find.byKey(const ValueKey<String>('appearance-system')), matching: find.text('System')),
    );
    expect(selectedLabel.style?.color, Theme.of(tester.element(find.text('System'))).colorScheme.primary);

    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Appearance: Dark'), findsOneWidget);

    final financeCard = find.bySemanticsLabel('Personal Finance');
    final galleryScroll = find.descendant(of: find.byType(GridView), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(financeCard, 240, scrollable: galleryScroll);
    await tester.tap(financeCard);
    await tester.pumpAndSettle();

    expect(find.byType(FinanceHomeScreen), findsOneWidget);
    expect(Theme.of(tester.element(find.text('Overview'))).brightness, Brightness.dark);
    expect(find.byTooltip('Appearance: Dark'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every app section follows the selected light and dark appearance', (WidgetTester tester) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(800, 600);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const UiTemplatesApp());
    await tester.pump(const Duration(seconds: 2));

    final scenarios = <({String label, Finder screen, String heading})>[
      (label: 'Help', screen: find.byType(HelpScreen), heading: 'How can we help you?'),
      (label: 'Feedback', screen: find.byType(FeedbackScreen), heading: 'Your Feedback'),
      (label: 'Invite friends', screen: find.byType(InviteFriendScreen), heading: 'Invite Your Friends'),
      (label: 'About', screen: find.byType(AboutScreen), heading: 'UI Templates'),
    ];

    for (final appearance in <({Brightness brightness, String label})>[
      (brightness: Brightness.light, label: 'Light'),
      (brightness: Brightness.dark, label: 'Dark'),
    ]) {
      await _selectAppAppearance(tester, appearance.label);
      for (final scenario in scenarios) {
        await _openAppSection(tester, scenario.label);
        final headingContext = tester.element(find.text(scenario.heading));
        final colors = AppTheme.build(appearance.brightness).colorScheme;
        final background = tester.widget<ColoredBox>(
          find.descendant(of: scenario.screen, matching: find.byType(ColoredBox)).first,
        );

        expect(Theme.of(headingContext).brightness, appearance.brightness, reason: scenario.label);
        expect(background.color, colors.surface, reason: scenario.label);
      }
      await _openAppSection(tester, 'Home');
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('system appearance shows the effective sun or moon icon', (WidgetTester tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    for (final brightness in Brightness.values) {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      await tester.pumpWidget(KeyedSubtree(key: ValueKey<Brightness>(brightness), child: const UiTemplatesApp()));
      await tester.pump();

      final button = find.byTooltip('Appearance: System');
      expect(
        find.descendant(
          of: button,
          matching: find.byIcon(brightness == Brightness.light ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.brightness_auto_rounded), findsNothing);
    }
  });

  testWidgets('every gallery artwork follows the selected appearance', (WidgetTester tester) async {
    for (final brightness in Brightness.values) {
      for (final item in TemplateGalleryItem.items) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: brightness),
            themeAnimationDuration: Duration.zero,
            home: TemplateGalleryArtwork(item: item),
          ),
        );

        final expectedPath = item.destination.galleryPreviewPath(dark: brightness == Brightness.dark);
        final artworkImages = tester.widgetList<Image>(
          find.descendant(of: find.byType(TemplateGalleryArtwork), matching: find.byType(Image)),
        );
        final assetPaths = artworkImages.map((image) => (image.image as AssetImage).assetName).toSet();

        expect(artworkImages, hasLength(3), reason: item.title);
        expect(assetPaths, <String>{expectedPath}, reason: item.title);
        expect(tester.takeException(), isNull);
      }
    }
  });
}

double _contrastRatio(Color foreground, Color background) {
  final lighter = math.max(foreground.computeLuminance(), background.computeLuminance());
  final darker = math.min(foreground.computeLuminance(), background.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}

Future<void> _selectAppAppearance(WidgetTester tester, String label) async {
  final button = find.descendant(of: find.byType(AppAppearanceButton), matching: find.byType(IconButton));
  await tester.tap(button.hitTestable());
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey<String>('appearance-${label.toLowerCase()}')).hitTestable());
  await tester.pumpAndSettle();
}

Future<void> _openAppSection(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip('Open navigation menu').hitTestable());
  await tester.pumpAndSettle();
  final menu = find.bySemanticsLabel('Navigation menu');
  final destination = find.descendant(of: menu, matching: find.text(label));
  await tester.tap(destination.hitTestable());
  await tester.pumpAndSettle();
}
