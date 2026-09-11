import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_theme.dart';
import 'package:templates/features/templates/ai_assistant_app/ai_assistant_app_theme.dart';
import 'package:templates/features/templates/ai_assistant_app/ai_assistant_home_screen.dart';
import 'package:templates/features/templates/design_course/design_course_app_theme.dart';
import 'package:templates/features/templates/design_course/home_design_course.dart';
import 'package:templates/features/templates/finance_app/finance_app_theme.dart';
import 'package:templates/features/templates/finance_app/finance_home_screen.dart';
import 'package:templates/features/templates/food_delivery_app/food_delivery_app_theme.dart';
import 'package:templates/features/templates/food_delivery_app/food_delivery_home_screen.dart';
import 'package:templates/features/templates/fitness_app/fitness_app_home_screen.dart';
import 'package:templates/features/templates/fitness_app/fitness_app_theme.dart';
import 'package:templates/features/templates/hotel_booking/hotel_app_theme.dart';
import 'package:templates/features/templates/hotel_booking/filters_screen.dart';
import 'package:templates/features/templates/hotel_booking/hotel_home_screen.dart';
import 'package:templates/features/templates/planner_app/planner_app_theme.dart';
import 'package:templates/features/templates/planner_app/planner_home_screen.dart';
import 'package:templates/features/templates/podcast_app/podcast_app_theme.dart';
import 'package:templates/features/templates/podcast_app/podcast_home_screen.dart';
import 'package:templates/features/templates/social_app/social_app_theme.dart';
import 'package:templates/features/templates/social_app/social_home_screen.dart';
import 'package:templates/features/templates/storefront_app/storefront_app_theme.dart';
import 'package:templates/features/templates/storefront_app/storefront_home_screen.dart';
import 'package:templates/features/templates/travel_app/travel_app_theme.dart';
import 'package:templates/features/templates/travel_app/travel_home_screen.dart';
import 'package:templates/main.dart';

void main() {
  test('template themes preserve their accepted palettes and accessible semantic roles', () {
    final cases =
        <
          ({
            String name,
            String font,
            ThemeData Function() build,
            Color primary,
            Color scaffold,
            bool useMaterial3,
            Brightness brightness,
          })
        >[
          (
            name: 'App',
            font: AppTheme.fontName,
            build: AppTheme.build,
            primary: Colors.blue,
            scaffold: AppTheme.nearlyWhite,
            useMaterial3: false,
            brightness: Brightness.light,
          ),
          (
            name: 'Design Course',
            font: DesignCourseAppTheme.fontName,
            build: DesignCourseAppTheme.build,
            primary: DesignCourseAppTheme.nearlyBlue,
            scaffold: DesignCourseAppTheme.nearlyWhite,
            useMaterial3: false,
            brightness: Brightness.light,
          ),
          (
            name: 'Hotel',
            font: 'WorkSans',
            build: HotelAppTheme.build,
            primary: HotelAppTheme.seedColor,
            scaffold: const Color(0xFFF6F6F6),
            useMaterial3: false,
            brightness: Brightness.light,
          ),
          (
            name: 'Fitness',
            font: FitnessAppTheme.fontName,
            build: FitnessAppTheme.build,
            primary: FitnessAppTheme.nearlyDarkBlue,
            scaffold: FitnessAppTheme.background,
            useMaterial3: false,
            brightness: Brightness.light,
          ),
          (
            name: 'Finance',
            font: FinanceAppTheme.fontName,
            build: FinanceAppTheme.build,
            primary: FinanceAppTheme.primary,
            scaffold: FinanceAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          (
            name: 'Storefront',
            font: StorefrontAppTheme.fontName,
            build: StorefrontAppTheme.build,
            primary: StorefrontAppTheme.primary,
            scaffold: StorefrontAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          (
            name: 'Planner',
            font: PlannerAppTheme.fontName,
            build: PlannerAppTheme.build,
            primary: PlannerAppTheme.primary,
            scaffold: PlannerAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          (
            name: 'AI assistant',
            font: AiAssistantAppTheme.fontName,
            build: AiAssistantAppTheme.build,
            primary: AiAssistantAppTheme.primary,
            scaffold: AiAssistantAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          (
            name: 'Food delivery',
            font: FoodDeliveryAppTheme.fontName,
            build: FoodDeliveryAppTheme.build,
            primary: FoodDeliveryAppTheme.primary,
            scaffold: FoodDeliveryAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          (
            name: 'Podcast',
            font: PodcastAppTheme.fontName,
            build: PodcastAppTheme.build,
            primary: PodcastAppTheme.primary,
            scaffold: PodcastAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          (
            name: 'Social community',
            font: SocialAppTheme.fontName,
            build: SocialAppTheme.build,
            primary: SocialAppTheme.primary,
            scaffold: SocialAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          (
            name: 'Travel planner',
            font: TravelAppTheme.fontName,
            build: TravelAppTheme.build,
            primary: TravelAppTheme.primary,
            scaffold: TravelAppTheme.background,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
        ];

    for (final themeCase in cases) {
      final theme = themeCase.build();
      final colors = theme.colorScheme;

      expect(theme.brightness, themeCase.brightness, reason: themeCase.name);
      expect(theme.useMaterial3, themeCase.useMaterial3, reason: themeCase.name);
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
    final originalPlatform = debugDefaultTargetPlatformOverride;
    addTearDown(() => debugDefaultTargetPlatformOverride = originalPlatform);

    for (final TargetPlatform platform in TargetPlatform.values) {
      debugDefaultTargetPlatformOverride = platform;
      expect(AppTheme.build().platform, platform);
      expect(DesignCourseAppTheme.build().platform, platform);
      expect(HotelAppTheme.build().platform, platform);
      expect(FitnessAppTheme.build().platform, platform);
      expect(FinanceAppTheme.build().platform, platform);
      expect(StorefrontAppTheme.build().platform, platform);
      expect(PlannerAppTheme.build().platform, platform);
      expect(AiAssistantAppTheme.build().platform, platform);
      expect(FoodDeliveryAppTheme.build().platform, platform);
      expect(PodcastAppTheme.build().platform, platform);
      expect(SocialAppTheme.build().platform, platform);
      expect(TravelAppTheme.build().platform, platform);
    }
  });

  testWidgets('opened navigation drawer meets text contrast guidelines', (WidgetTester tester) async {
    _evictAssets(_galleryAssets);
    await tester.pumpWidget(const UiTemplatesApp());
    await tester.pump();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('gallery follows the system appearance until the user chooses a mode', (WidgetTester tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    _evictAssets(_galleryAssets);

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpWidget(const UiTemplatesApp());
    await tester.pump();

    final galleryTheme = Theme.of(tester.element(find.byTooltip('Appearance: System')));
    expect(galleryTheme.brightness, Brightness.dark);
    expect(galleryTheme.scaffoldBackgroundColor, const Color(0xFF111719));
  });

  testWidgets('template surfaces inherit their accessible semantic themes', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
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

    await _pumpThemedScreen(tester, const FinanceHomeScreen());
    _expectTemplateTheme(tester, find.text('Overview'), FinanceAppTheme.build());
    await _expectAccessible(tester);

    await _pumpThemedScreen(tester, const StorefrontHomeScreen());
    _expectTemplateTheme(tester, find.text('Nest'), StorefrontAppTheme.build());
    await _expectAccessible(tester);

    await _pumpThemedScreen(tester, const PlannerHomeScreen());
    _expectTemplateTheme(tester, find.text('Daymark'), PlannerAppTheme.build());
    await _expectAccessible(tester);

    await _pumpThemedScreen(tester, const AiAssistantHomeScreen());
    _expectTemplateTheme(
      tester,
      find.descendant(of: find.byType(AppBar), matching: find.text('Nova')),
      AiAssistantAppTheme.build(),
    );
    await _expectAccessible(tester);

    await _pumpThemedScreen(tester, const FoodDeliveryHomeScreen());
    _expectTemplateTheme(tester, find.text('Savor'), FoodDeliveryAppTheme.build());
    await _expectAccessible(tester);

    await _pumpThemedScreen(tester, const PodcastHomeScreen());
    _expectTemplateTheme(tester, find.text('Wave'), PodcastAppTheme.build());
    await _expectAccessible(tester);

    await _pumpThemedScreen(tester, const SocialHomeScreen());
    _expectTemplateTheme(tester, find.text('Mingle'), SocialAppTheme.build());
    await _expectAccessible(tester);

    await _pumpThemedScreen(tester, const TravelHomeScreen());
    _expectTemplateTheme(tester, find.text('Roam'), TravelAppTheme.build());
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
    final hotelScroll = find.descendant(of: find.byType(HotelHomeScreen), matching: find.byType(Scrollable)).first;
    await tester.dragUntilVisible(find.text('Filter'), hotelScroll, const Offset(0, -180));
    await tester.pump();
    _expectNoLayoutException(tester);
    expect(find.text('Filter').hitTestable(), findsOneWidget);

    _evictAssets(_fitnessAssets);
    await _pumpThemedScreen(tester, const FitnessAppHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    await tester.pump(const Duration(seconds: 2));
    _expectNoLayoutException(tester);
    final diaryList = find.descendant(of: find.byType(FitnessAppHomeScreen), matching: find.byType(Scrollable)).first;
    await tester.dragUntilVisible(find.text('Water'), diaryList, const Offset(0, -180));
    await tester.pump();
    _expectNoLayoutException(tester);
    expect(find.text('Water').hitTestable(), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Training').first);
    await tester.pump();
    final trainingList = find
        .descendant(of: find.byType(FitnessAppHomeScreen), matching: find.byType(Scrollable))
        .first;
    await tester.dragUntilVisible(find.text('Area of focus'), trainingList, const Offset(0, -180));
    await tester.pump();
    _expectNoLayoutException(tester);
    expect(find.text('Area of focus').hitTestable(), findsOneWidget);

    await _pumpThemedScreen(tester, const FinanceHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.text('Overview'), findsOneWidget);

    await _pumpThemedScreen(tester, const StorefrontHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.text('Nest'), findsOneWidget);

    await _pumpThemedScreen(tester, const PlannerHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.text('Daymark'), findsOneWidget);

    await _pumpThemedScreen(tester, const AiAssistantHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Nova')), findsOneWidget);

    await _pumpThemedScreen(tester, const FoodDeliveryHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.text('Savor'), findsOneWidget);

    await _pumpThemedScreen(tester, const PodcastHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.text('Wave'), findsOneWidget);

    await _pumpThemedScreen(tester, const SocialHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.text('Mingle'), findsOneWidget);

    await _pumpThemedScreen(tester, const TravelHomeScreen(), size: const Size(320, 568), textScale: 3.2);
    _expectNoLayoutException(tester);
    expect(find.text('Roam'), findsOneWidget);
  });

  testWidgets('hotel filters remain readable and operable at compact maximum text size', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
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
  final mediaQuery = MediaQueryData.fromView(
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
  final actual = Theme.of(tester.element(finder));
  expect(actual.brightness, expected.brightness);
  expect(actual.useMaterial3, expected.useMaterial3);
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
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance ? foregroundLuminance : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance ? backgroundLuminance : foregroundLuminance;
  final ratio = (lighter + 0.05) / (darker + 0.05);

  expect(ratio, greaterThanOrEqualTo(minimum), reason: '$name measured ${ratio.toStringAsFixed(2)}:1');
}

void _expectNoLayoutException(WidgetTester tester) {
  expect(tester.takeException(), isNull);
}

void _evictAssets(Iterable<String> assets) {
  for (final asset in assets) {
    rootBundle.evict(asset);
  }
}

const _galleryAssets = <String>[
  'assets/hotel/hotel_booking.png',
  'assets/fitness_app/fitness_app.png',
  'assets/design_course/design_course.png',
];

const _designAssets = <String>[
  'assets/design_course/interFace1.png',
  'assets/design_course/interFace2.png',
  'assets/design_course/interFace3.png',
  'assets/design_course/interFace4.png',
  'assets/design_course/userImage.png',
];

const _hotelAssets = <String>[
  'assets/hotel/hotel_1.png',
  'assets/hotel/hotel_2.png',
  'assets/hotel/hotel_3.png',
  'assets/hotel/hotel_4.png',
  'assets/hotel/hotel_5.png',
];

const _fitnessAssets = <String>[
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
