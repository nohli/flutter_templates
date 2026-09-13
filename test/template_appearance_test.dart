import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/features/gallery/template_gallery_artwork.dart';
import 'package:templates/features/templates/banking_super_app/widgets/banking_gallery_preview.dart';
import 'package:templates/features/templates/channel_messenger/widgets/channel_messenger_gallery_preview.dart';
import 'package:templates/features/templates/dating_app/widgets/dating_gallery_preview.dart';
import 'package:templates/features/templates/design_course/course_info_screen.dart';
import 'package:templates/features/templates/design_course/design_course_app_theme.dart';
import 'package:templates/features/templates/design_course/home_design_course.dart';
import 'package:templates/features/templates/design_course/models/category.dart';
import 'package:templates/features/templates/finance_app/finance_home_screen.dart';
import 'package:templates/features/templates/finance_app/widgets/finance_gallery_preview.dart';
import 'package:templates/features/templates/language_learning/widgets/language_learning_gallery_preview.dart';
import 'package:templates/features/templates/private_messenger/widgets/private_messenger_gallery_preview.dart';
import 'package:templates/features/templates/shared/template_appearance.dart';
import 'package:templates/features/templates/social_feed/widgets/social_feed_gallery_preview.dart';
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
    final generatedItems = TemplateGalleryItem.items.where((TemplateGalleryItem item) => item.imagePath == null);

    for (final brightness in Brightness.values) {
      for (final item in generatedItems) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: brightness),
            themeAnimationDuration: Duration.zero,
            home: TemplateGalleryArtwork(item: item),
          ),
        );

        expect(_galleryPreviewBrightness(tester, item.destination), brightness, reason: item.title);
        expect(tester.takeException(), isNull);
      }
    }
  });
}

Brightness _galleryPreviewBrightness(WidgetTester tester, TemplateGalleryDestination destination) =>
    switch (destination) {
      TemplateGalleryDestination.personalFinance =>
        tester.widget<FinanceGalleryPreview>(find.byType(FinanceGalleryPreview)).brightness,
      TemplateGalleryDestination.dating =>
        tester.widget<DatingGalleryPreview>(find.byType(DatingGalleryPreview)).brightness,
      TemplateGalleryDestination.languageLearning =>
        tester.widget<LanguageLearningGalleryPreview>(find.byType(LanguageLearningGalleryPreview)).brightness,
      TemplateGalleryDestination.socialFeed =>
        tester.widget<SocialFeedGalleryPreview>(find.byType(SocialFeedGalleryPreview)).brightness,
      TemplateGalleryDestination.bankingSuperApp =>
        tester.widget<BankingGalleryPreview>(find.byType(BankingGalleryPreview)).brightness,
      TemplateGalleryDestination.channelMessenger =>
        tester.widget<ChannelMessengerGalleryPreview>(find.byType(ChannelMessengerGalleryPreview)).brightness,
      TemplateGalleryDestination.privateMessenger =>
        tester.widget<PrivateMessengerGalleryPreview>(find.byType(PrivateMessengerGalleryPreview)).brightness,
      TemplateGalleryDestination.hotelBooking ||
      TemplateGalleryDestination.fitness ||
      TemplateGalleryDestination.designCourse => throw StateError(
        'Static artwork does not expose a selected appearance.',
      ),
    };

double _contrastRatio(Color foreground, Color background) {
  final lighter = math.max(foreground.computeLuminance(), background.computeLuminance());
  final darker = math.min(foreground.computeLuminance(), background.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}
