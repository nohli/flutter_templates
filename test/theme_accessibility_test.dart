import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app_shell.dart';
import 'package:templates/app_theme.dart';
import 'package:templates/design_course/design_course_app_theme.dart';
import 'package:templates/design_course/home_design_course.dart';
import 'package:templates/fitness_app/fitness_app_home_screen.dart';
import 'package:templates/fitness_app/fitness_app_theme.dart';
import 'package:templates/hotel_booking/hotel_app_theme.dart';
import 'package:templates/hotel_booking/filters_screen.dart';
import 'package:templates/hotel_booking/hotel_home_screen.dart';
import 'package:templates/main.dart';

void main() {
  test('template themes preserve their accepted light palettes and accessible semantic roles', () {
    final cases = <({String name, String font, ThemeData Function() build, Color primary, Color scaffold})>[
      (
        name: 'App',
        font: AppTheme.fontName,
        build: AppTheme.build,
        primary: Colors.blue,
        scaffold: AppTheme.nearlyWhite,
      ),
      (
        name: 'Design Course',
        font: DesignCourseAppTheme.fontName,
        build: DesignCourseAppTheme.build,
        primary: DesignCourseAppTheme.nearlyBlue,
        scaffold: DesignCourseAppTheme.nearlyWhite,
      ),
      (
        name: 'Hotel',
        font: 'WorkSans',
        build: HotelAppTheme.build,
        primary: HotelAppTheme.seedColor,
        scaffold: const Color(0xFFF6F6F6),
      ),
      (
        name: 'Fitness',
        font: FitnessAppTheme.fontName,
        build: FitnessAppTheme.build,
        primary: FitnessAppTheme.nearlyDarkBlue,
        scaffold: FitnessAppTheme.background,
      ),
    ];

    for (final themeCase in cases) {
      final ThemeData theme = themeCase.build();
      final ColorScheme colors = theme.colorScheme;

      expect(theme.brightness, Brightness.light, reason: themeCase.name);
      expect(theme.useMaterial3, isFalse, reason: themeCase.name);
      expect(theme.platform, defaultTargetPlatform, reason: themeCase.name);
      expect(theme.scaffoldBackgroundColor, themeCase.scaffold, reason: themeCase.name);
      expect(colors.primary, themeCase.primary, reason: themeCase.name);
      expect(theme.textTheme.bodyMedium?.fontFamily, themeCase.font, reason: themeCase.name);
      _expectContrast('${themeCase.name} onSurface/surface', colors.onSurface, colors.surface, 4.5);
      _expectContrast('${themeCase.name} onPrimary/primary', colors.onPrimary, colors.primary, 4.5);
      _expectContrast('${themeCase.name} onError/error', colors.onError, colors.error, 4.5);
      _expectContrast('${themeCase.name} outline/surface', colors.outline, colors.surface, 3);
    }
  });

  test('template themes follow the runtime platform', () {
    final TargetPlatform? originalPlatform = debugDefaultTargetPlatformOverride;
    addTearDown(() => debugDefaultTargetPlatformOverride = originalPlatform);

    for (final TargetPlatform platform in TargetPlatform.values) {
      debugDefaultTargetPlatformOverride = platform;
      expect(AppTheme.build().platform, platform);
      expect(DesignCourseAppTheme.build().platform, platform);
      expect(HotelAppTheme.build().platform, platform);
      expect(FitnessAppTheme.build().platform, platform);
    }
  });

  testWidgets('opened navigation drawer meets text contrast guidelines', (WidgetTester tester) async {
    _evictAssets(_galleryAssets);
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('root app keeps its accepted light appearance when the system is dark', (WidgetTester tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    _evictAssets(_galleryAssets);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme?.useMaterial3, isFalse);
    expect(app.darkTheme, isNull);
    expect(Theme.of(tester.element(find.byType(AppShell))).brightness, Brightness.light);
    expect(Theme.of(tester.element(find.byType(AppShell))).scaffoldBackgroundColor, AppTheme.nearlyWhite);
  });

  testWidgets('template surfaces inherit accessible fixed-light semantic themes', (WidgetTester tester) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

    _evictAssets(_designAssets);
    await _pumpThemedScreen(tester, const DesignCourseHomeScreen());
    await tester.pump(const Duration(seconds: 2));
    _expectTemplateTheme(tester, find.text('Category'), DesignCourseAppTheme.build());
    await _expectAccessible(tester);

    _evictAssets(_hotelAssets);
    await _pumpThemedScreen(tester, const HotelHomeScreen());
    await tester.pump(const Duration(seconds: 2));
    _expectTemplateTheme(tester, find.text('Explore'), HotelAppTheme.build());
    await _expectAccessible(tester);

    _evictAssets(_fitnessAssets);
    await _pumpThemedScreen(tester, const FitnessAppHomeScreen());
    await tester.pump(const Duration(seconds: 2));
    _expectTemplateTheme(tester, find.bySemanticsLabel('Diary').first, FitnessAppTheme.build());
    await _expectAccessible(tester);
    semantics.dispose();
  });

  testWidgets('template surfaces stay usable at compact maximum text size', (WidgetTester tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    addTearDown(tester.view.reset);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

    _evictAssets(_designAssets);
    await _pumpThemedScreen(tester, const DesignCourseHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    await tester.pump(const Duration(seconds: 2));
    _expectNoLayoutException(tester);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Popular Course'), findsOneWidget);

    _evictAssets(_hotelAssets);
    await _pumpThemedScreen(tester, const HotelHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    await tester.pump(const Duration(seconds: 2));
    _expectNoLayoutException(tester);
    final Finder hotelScroll = find
        .descendant(of: find.byType(HotelHomeScreen), matching: find.byType(Scrollable))
        .first;
    await tester.dragUntilVisible(find.text('Filter'), hotelScroll, const Offset(0, -180));
    await tester.pump();
    _expectNoLayoutException(tester);
    expect(find.text('Filter').hitTestable(), findsOneWidget);

    _evictAssets(_fitnessAssets);
    await _pumpThemedScreen(tester, const FitnessAppHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    await tester.pump(const Duration(seconds: 2));
    _expectNoLayoutException(tester);
    final Finder diaryList = find
        .descendant(of: find.byType(FitnessAppHomeScreen), matching: find.byType(Scrollable))
        .first;
    await tester.dragUntilVisible(find.text('Water'), diaryList, const Offset(0, -180));
    await tester.pump();
    _expectNoLayoutException(tester);
    expect(find.text('Water').hitTestable(), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Training').first);
    await tester.pump();
    final Finder trainingList = find
        .descendant(of: find.byType(FitnessAppHomeScreen), matching: find.byType(Scrollable))
        .first;
    await tester.dragUntilVisible(find.text('Area of focus'), trainingList, const Offset(0, -180));
    await tester.pump();
    _expectNoLayoutException(tester);
    expect(find.text('Area of focus').hitTestable(), findsOneWidget);
  });

  testWidgets('hotel filters remain readable and operable at compact maximum text size', (WidgetTester tester) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    addTearDown(tester.view.reset);
    _evictAssets(_hotelAssets);
    await _pumpThemedScreen(tester, const HotelHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    await tester.pump(const Duration(seconds: 2));

    final hotelScroll = find.descendant(of: find.byType(HotelHomeScreen), matching: find.byType(Scrollable)).first;
    await tester.dragUntilVisible(find.text('Filter'), hotelScroll, const Offset(0, -180));
    await tester.pump();
    final filterButton = find.text('Filter').hitTestable();
    expect(filterButton, findsOneWidget);
    await tester.tap(filterButton);
    await tester.pumpAndSettle();

    expect(find.byType(FiltersScreen), findsOneWidget);
    expect(tester.getRect(find.byTooltip('Close filters')).shortestSide, greaterThanOrEqualTo(48));
    expect(tester.getRect(find.widgetWithText(FilledButton, 'Apply')).height, greaterThanOrEqualTo(48));
    _expectNoLayoutException(tester);

    final filtersScroll = find.descendant(of: find.byType(FiltersScreen), matching: find.byType(Scrollable)).first;
    for (final label in <String>[
      'Price (for 1 night)',
      'Popular filters',
      'Distance from city center',
      'Type of Accommodation',
    ]) {
      await tester.dragUntilVisible(find.text(label), filtersScroll, const Offset(0, -160));
      await tester.pump();
      expect(find.text(label).hitTestable(), findsOneWidget);
      _expectNoLayoutException(tester);
    }

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await tester.tap(find.byTooltip('Close filters'));
    await tester.pumpAndSettle();
    expect(find.byType(HotelHomeScreen), findsOneWidget);
    semantics.dispose();
  });
}

Future<void> _pumpThemedScreen(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(430, 932),
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  final MediaQueryData mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: true);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.build(),
      home: MediaQuery(
        data: mediaQuery,
        child: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pump();
}

void _expectTemplateTheme(WidgetTester tester, Finder finder, ThemeData expected) {
  final ThemeData actual = Theme.of(tester.element(finder));
  expect(actual.brightness, Brightness.light);
  expect(actual.useMaterial3, isFalse);
  expect(actual.platform, defaultTargetPlatform);
  expect(actual.colorScheme.primary, expected.colorScheme.primary);
  expect(actual.textTheme.bodyMedium?.fontFamily, expected.textTheme.bodyMedium?.fontFamily);
}

Future<void> _expectAccessible(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
}

void _expectContrast(String name, Color foreground, Color background, double minimum) {
  final double foregroundLuminance = foreground.computeLuminance();
  final double backgroundLuminance = background.computeLuminance();
  final double lighter = foregroundLuminance > backgroundLuminance ? foregroundLuminance : backgroundLuminance;
  final double darker = foregroundLuminance > backgroundLuminance ? backgroundLuminance : foregroundLuminance;
  final double ratio = (lighter + 0.05) / (darker + 0.05);

  expect(ratio, greaterThanOrEqualTo(minimum), reason: '$name measured ${ratio.toStringAsFixed(2)}:1');
}

void _expectNoLayoutException(WidgetTester tester) {
  expect(tester.takeException(), isNull);
}

void _evictAssets(Iterable<String> assets) {
  for (final String asset in assets) {
    rootBundle.evict(asset);
  }
}

const List<String> _galleryAssets = <String>[
  'assets/hotel/hotel_booking.png',
  'assets/fitness_app/fitness_app.png',
  'assets/design_course/design_course.png',
];

const List<String> _designAssets = <String>[
  'assets/design_course/interFace1.png',
  'assets/design_course/interFace2.png',
  'assets/design_course/interFace3.png',
  'assets/design_course/interFace4.png',
  'assets/design_course/userImage.png',
];

const List<String> _hotelAssets = <String>[
  'assets/hotel/hotel_1.png',
  'assets/hotel/hotel_2.png',
  'assets/hotel/hotel_3.png',
  'assets/hotel/hotel_4.png',
  'assets/hotel/hotel_5.png',
];

const List<String> _fitnessAssets = <String>[
  'assets/fitness_app/eaten.png',
  'assets/fitness_app/burned.png',
  'assets/fitness_app/breakfast.png',
  'assets/fitness_app/lunch.png',
  'assets/fitness_app/snack.png',
  'assets/fitness_app/dinner.png',
  'assets/fitness_app/tab_1.png',
  'assets/fitness_app/tab_1s.png',
  'assets/fitness_app/tab_2.png',
  'assets/fitness_app/tab_2s.png',
  'assets/fitness_app/tab_3.png',
  'assets/fitness_app/tab_3s.png',
  'assets/fitness_app/tab_4.png',
  'assets/fitness_app/tab_4s.png',
  'assets/fitness_app/bottle.png',
  'assets/fitness_app/bell.png',
  'assets/fitness_app/glass.png',
  'assets/fitness_app/runner.png',
  'assets/fitness_app/back.png',
  'assets/fitness_app/area1.png',
  'assets/fitness_app/area2.png',
  'assets/fitness_app/area3.png',
];
