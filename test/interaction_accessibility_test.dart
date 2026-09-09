import 'dart:ui' show CheckedState, SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:templates/design_course/home_design_course.dart';
import 'package:templates/design_course/models/category.dart';
import 'package:templates/fitness_app/bottom_navigation_view/bottom_bar_view.dart';
import 'package:templates/fitness_app/fitness_app_home_screen.dart';
import 'package:templates/fitness_app/fitness_app_theme.dart';
import 'package:templates/fitness_app/ui_view/area_list_view.dart';
import 'package:templates/hotel_booking/custom_calendar.dart';
import 'package:templates/hotel_booking/hotel_home_screen.dart';
import 'package:templates/hotel_booking/model/hotel_list_data.dart';
import 'package:templates/hotel_booking/smooth_star_rating.dart';
import 'package:templates/home_screen.dart';

void main() {
  test('course lesson labels use correct singular and plural grammar', () {
    const singleLesson = Category(
      id: 'single-lesson',
      title: 'Single Lesson',
      imagePath: '',
      lessonCount: 1,
      money: 0,
      rating: 0,
    );

    expect(singleLesson.lessonLabel, '1 lesson');
    expect(Category.categoryList.first.lessonLabel, '24 lessons');
  });

  test('hotel samples use stable unique identities', () {
    final hotels = HotelListData.samples;
    final ids = hotels.map((HotelListData hotel) => hotel.id).toSet();

    expect(ids, hasLength(hotels.length));
    expect(ids, everyElement(isNotEmpty));
    expect(hotels, everyElement(predicate<HotelListData>((HotelListData hotel) => hotel.id != hotel.imagePath)));
  });

  testWidgets('design course category choices and search remain accessible and truthful', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    _evictAssets(<String>[
      'assets/design_course/interFace1.png',
      'assets/design_course/interFace2.png',
      'assets/design_course/interFace3.png',
      'assets/design_course/interFace4.png',
      'assets/design_course/userImage.png',
    ]);
    await _pumpScreen(tester, const DesignCourseHomeScreen());
    await tester.pump(const Duration(seconds: 2));

    final uiCategory = find.bySemanticsLabel('Select UI/UX category');
    final codingCategory = find.bySemanticsLabel('Select Coding category');
    final basicCategory = find.bySemanticsLabel('Select Basic UI category');
    for (final categoryControl in <Finder>[uiCategory, codingCategory, basicCategory]) {
      expect(tester.getRect(categoryControl).height, greaterThanOrEqualTo(48));
    }
    expect(tester.getSemantics(uiCategory).flagsCollection.isSelected, Tristate.isTrue);

    await tester.tap(codingCategory);
    await tester.pump();

    expect(tester.getSemantics(codingCategory).flagsCollection.isSelected, Tristate.isTrue);
    expect(find.text('User Interface Design'), findsNothing);
    expect(find.text('No sample courses are included in this category.'), findsOneWidget);
    expect(find.text('App Design Course'), findsOneWidget);
    expect(find.text('Web Design Course'), findsOneWidget);
    expect(find.text('Responsive Layouts'), findsOneWidget);
    expect(find.text('Interaction Design'), findsOneWidget);

    await tester.tap(basicCategory);
    await tester.pump();

    expect(tester.getSemantics(basicCategory).flagsCollection.isSelected, Tristate.isTrue);
    expect(find.text('User Interface Design'), findsNothing);

    await tester.enterText(find.byType(TextFormField), 'web');
    await tester.pump();

    expect(find.text('Web Design Course'), findsOneWidget);
    expect(find.text('App Design Course'), findsNothing);
    expect(find.text('User Interface Design'), findsNothing);
    expect(find.text('No sample courses match your search.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'missing');
    await tester.pump();

    expect(find.text('No sample courses match your search.'), findsNWidgets(2));
    semantics.dispose();
  });

  testWidgets('gallery preserves saved courses when the template is reopened', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    _evictAssets(<String>[
      'assets/hotel/hotel_booking.png',
      'assets/fitness_app/fitness_app.png',
      'assets/design_course/design_course.png',
      'assets/design_course/interFace1.png',
      'assets/design_course/interFace2.png',
      'assets/design_course/interFace3.png',
      'assets/design_course/interFace4.png',
      'assets/design_course/userImage.png',
    ]);
    await _pumpScreen(tester, const MyHomePage());
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.bySemanticsLabel('Design Course'));
    await tester.pumpAndSettle();

    final courseCard = find.bySemanticsLabel(RegExp(r'^Open Web Design Course sample course,'));
    await tester.tap(courseCard.first);
    await tester.pumpAndSettle();

    expect(find.text('Preview only — enrollment is not available.'), findsOneWidget);
    expect(find.text('Join Course'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);

    final saveCourse = find.bySemanticsLabel('Save sample course');
    expect(tester.getRect(saveCourse).shortestSide, greaterThanOrEqualTo(48));
    expect(tester.getSemantics(saveCourse).flagsCollection.isToggled, Tristate.isFalse);

    await tester.tap(saveCourse);
    await tester.pump();

    final removeCourse = find.bySemanticsLabel('Remove saved sample course');
    expect(removeCourse, findsOneWidget);
    expect(tester.getSemantics(removeCourse).flagsCollection.isToggled, Tristate.isTrue);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(DesignCourseHomeScreen))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Design Course'));
    await tester.pumpAndSettle();
    await tester.tap(courseCard.first);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Remove saved sample course'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Remove saved sample course'));
    await tester.pump();

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(DesignCourseHomeScreen))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Design Course'));
    await tester.pumpAndSettle();
    await tester.tap(courseCard.first);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Save sample course'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('hotel search, favorites, and applied filters update the visible local samples', (
    WidgetTester tester,
  ) async {
    final semantics = tester.ensureSemantics();
    _evictAssets(<String>[
      'assets/hotel/hotel_1.png',
      'assets/hotel/hotel_2.png',
      'assets/hotel/hotel_3.png',
      'assets/hotel/hotel_4.png',
      'assets/hotel/hotel_5.png',
    ]);
    await _pumpScreen(tester, const HotelHomeScreen());
    await tester.pump(const Duration(seconds: 1));

    await tester.enterText(find.byType(TextField), 'Queen');
    await tester.pump();

    expect(find.text('2 sample hotels'), findsOneWidget);
    expect(find.text('Grand Royal Hotel'), findsNothing);

    final favorite = find
        .byWidgetPredicate(
          (Widget widget) =>
              widget is Semantics &&
              widget.properties.label == 'Favorite Queen Hotel' &&
              widget.properties.toggled == false,
        )
        .first;
    expect(tester.getRect(favorite).shortestSide, greaterThanOrEqualTo(48));
    await tester.tap(favorite);
    await tester.pump();

    final removeFavorite = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Semantics &&
          widget.properties.label == 'Remove Queen Hotel from favorites' &&
          widget.properties.toggled == true,
    );
    expect(removeFavorite, findsOneWidget);
    await tester.tap(removeFavorite);
    await tester.pump();
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Semantics &&
            widget.properties.label == 'Favorite Queen Hotel' &&
            widget.properties.toggled == false,
      ),
      findsNWidgets(2),
    );

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();

    final breakfastControl = find.widgetWithText(CheckboxListTile, 'Free Breakfast');
    final homeControl = find.widgetWithText(SwitchListTile, 'Home');
    expect(tester.getRect(breakfastControl).height, greaterThanOrEqualTo(48));
    expect(tester.getRect(homeControl).height, greaterThanOrEqualTo(48));
    expect(tester.getRect(find.widgetWithText(FilledButton, 'Apply')).height, greaterThanOrEqualTo(48));

    await tester.tap(find.text('Free Breakfast'));
    await tester.tap(find.text('Home'));
    await tester.tap(find.bySemanticsLabel('All'));
    await tester.pump();

    expect(tester.getSemantics(find.bySemanticsLabel('All')).flagsCollection.isToggled, Tristate.isTrue);
    expect(tester.getSemantics(find.bySemanticsLabel('Home')).flagsCollection.isToggled, Tristate.isFalse);

    await tester.tap(find.text('Home'));
    tester.widget<RangeSlider>(find.byType(RangeSlider)).onChanged!(const RangeValues(1, 100));
    tester.widget<Slider>(find.byType(Slider)).onChanged!(40);
    await tester.pump();

    expect(tester.getSemantics(find.bySemanticsLabel('Free Breakfast')).flagsCollection.isChecked, CheckedState.isTrue);
    expect(tester.getSemantics(find.bySemanticsLabel('Home')).flagsCollection.isToggled, Tristate.isTrue);

    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(find.text('1 sample hotels'), findsOneWidget);
    expect(find.text('Grand Royal Hotel'), findsOneWidget);
    expect(find.text('Queen Hotel'), findsNothing);

    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();
    expect(tester.getSemantics(find.bySemanticsLabel('Free Breakfast')).flagsCollection.isChecked, CheckedState.isTrue);
    expect(tester.getSemantics(find.bySemanticsLabel('Home')).flagsCollection.isToggled, Tristate.isTrue);
    expect(tester.widget<RangeSlider>(find.byType(RangeSlider)).values, const RangeValues(1, 100));
    expect(tester.widget<Slider>(find.byType(Slider)).value, 40);
    expect(find.text('Less than 4.0 Km'), findsOneWidget);
    await tester.tap(find.byTooltip('Close filters'));
    await tester.pumpAndSettle();
    expect(find.byType(HotelHomeScreen), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('every hotel filter independently changes the matching sample set', (WidgetTester tester) async {
    final scenarios = <({double? distanceValue, int expectedCount, String name, String? option, RangeValues? prices})>[
      (name: 'breakfast', option: 'Free Breakfast', prices: null, distanceValue: null, expectedCount: 3),
      (name: 'maximum-price', option: null, prices: const RangeValues(0, 100), distanceValue: null, expectedCount: 1),
      (name: 'distance', option: null, prices: null, distanceValue: 40, expectedCount: 4),
      (name: 'home', option: 'Home', prices: null, distanceValue: null, expectedCount: 1),
      (
        name: 'minimum-price',
        option: null,
        prices: const RangeValues(190, 1000),
        distanceValue: null,
        expectedCount: 2,
      ),
    ];

    for (final scenario in scenarios) {
      await _pumpScreen(tester, HotelHomeScreen(key: ValueKey<String>(scenario.name)));
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      if (scenario.prices case final RangeValues prices) {
        tester.widget<RangeSlider>(find.byType(RangeSlider)).onChanged!(prices);
      }
      if (scenario.distanceValue case final double distanceValue) {
        tester.widget<Slider>(find.byType(Slider)).onChanged!(distanceValue);
      }
      if (scenario.option case final String option) {
        await tester.ensureVisible(find.text(option));
        await tester.tap(find.text(option));
      }
      await tester.pump();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(find.text('${scenario.expectedCount} sample hotels'), findsOneWidget, reason: scenario.name);
    }
  });

  testWidgets('calendar and ratings expose one meaningful semantic value with adequate controls', (
    WidgetTester tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 5);
    final end = DateTime(now.year, now.month, 10);
    var updatedRating = 3.0;
    await _pumpScreen(
      tester,
      Column(
        children: <Widget>[
          Expanded(
            child: CustomCalendarView(
              minimumDate: DateTime(now.year, now.month, 1),
              maximumDate: DateTime(now.year, now.month, 20),
              initialStartDate: start,
              initialEndDate: end,
              startEndDateChange: (_, _) {},
            ),
          ),
          const SmoothStarRating(rating: 4.5),
        ],
      ),
    );

    final previousMonth = find.byTooltip('Previous month');
    final nextMonth = find.byTooltip('Next month');
    expect(tester.getRect(previousMonth).shortestSide, greaterThanOrEqualTo(48));
    expect(tester.getRect(nextMonth).shortestSide, greaterThanOrEqualTo(48));
    expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.keyboard_arrow_left)).onPressed, isNull);
    expect(tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.keyboard_arrow_right)).onPressed, isNull);

    final selectedStart = find.bySemanticsLabel(DateFormat('EEEE, d MMMM yyyy').format(start));
    expect(tester.getSemantics(selectedStart).flagsCollection.isSelected, Tristate.isTrue);
    final unavailableDate = DateTime(now.year, now.month, 25);
    final unavailable = find.bySemanticsLabel(DateFormat('EEEE, d MMMM yyyy').format(unavailableDate));
    expect(tester.getSemantics(unavailable).flagsCollection.isEnabled, Tristate.isFalse);
    expect(tester.getSemantics(unavailable).getSemanticsData().hasAction(SemanticsAction.tap), isFalse);

    await tester.tap(find.descendant(of: selectedStart, matching: find.text('${start.day}')));
    await tester.pump();
    expect(find.text(DateFormat('MMMM, yyyy').format(now)), findsOneWidget);

    final rating = tester.getSemantics(find.bySemanticsLabel('Rating').first);
    expect(rating.value, '4.5 out of 5');
    expect(rating.flagsCollection.isReadOnly, isTrue);
    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsNothing);

    late StateSetter updateRatingState;
    await _pumpScreen(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          updateRatingState = setState;
          return SmoothStarRating(
            rating: updatedRating,
            onRatingChanged: (double rating) {
              setState(() => updatedRating = rating);
            },
          );
        },
      ),
    );
    final interactiveRating = find.bySemanticsLabel('Rating');
    final interactiveData = tester.getSemantics(interactiveRating).getSemanticsData();
    expect(interactiveData.hasAction(SemanticsAction.increase), isTrue);
    expect(interactiveData.hasAction(SemanticsAction.decrease), isTrue);
    tester.semantics.increase(find.semantics.byLabel('Rating'));
    await tester.pump();
    expect(updatedRating, 3.5);
    tester.semantics.decrease(find.semantics.byLabel('Rating'));
    await tester.pump();
    expect(updatedRating, 3);

    updateRatingState(() => updatedRating = 5);
    await tester.pump();
    tester.semantics.increase(find.semantics.byLabel('Rating'));
    await tester.pump();
    expect(updatedRating, 5);

    updateRatingState(() => updatedRating = 0);
    await tester.pump();
    tester.semantics.decrease(find.semantics.byLabel('Rating'));
    await tester.pump();
    expect(updatedRating, 0);
    semantics.dispose();
  });

  testWidgets('fitness preserves its custom navigation and static sample captions', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    _evictAssets(<String>[
      'assets/fitness_app/eaten.png',
      'assets/fitness_app/burned.png',
      'assets/fitness_app/breakfast.png',
      'assets/fitness_app/tab_1.png',
      'assets/fitness_app/tab_1s.png',
      'assets/fitness_app/tab_2.png',
      'assets/fitness_app/tab_2s.png',
      'assets/fitness_app/tab_3.png',
      'assets/fitness_app/tab_3s.png',
      'assets/fitness_app/tab_4.png',
      'assets/fitness_app/tab_4s.png',
    ]);
    await _pumpScreen(tester, const FitnessAppHomeScreen());
    await tester.pump(const Duration(milliseconds: 650));

    final navigation = find.byType(BottomBarView);
    expect(navigation, findsOneWidget);
    expect(MediaQuery.disableAnimationsOf(tester.element(navigation)), isFalse);
    expect(TickerMode.valuesOf(tester.element(navigation)).enabled, isTrue);
    expect(find.byType(NavigationBar), findsNothing);
    expect(
      find.descendant(
        of: navigation,
        matching: find.byWidgetPredicate((Widget widget) => widget is PhysicalShape && widget.clipper is TabClipper),
      ),
      findsOneWidget,
    );
    final physicalBar = tester.widget<PhysicalShape>(
      find.descendant(
        of: navigation,
        matching: find.byWidgetPredicate((Widget widget) => widget is PhysicalShape && widget.clipper is TabClipper),
      ),
    );
    expect(physicalBar.color, FitnessAppTheme.white);
    final centerIcon = find.descendant(of: navigation, matching: find.byIcon(Icons.add));
    expect(centerIcon, findsOneWidget);
    final centerDecoration = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: centerIcon,
            matching: find.byWidgetPredicate(
              (Widget widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).gradient != null,
            ),
          )
          .first,
    );
    final centerBox = centerDecoration.decoration as BoxDecoration;
    expect((centerBox.gradient! as LinearGradient).colors, <Color>[
      FitnessAppTheme.nearlyDarkBlue,
      const Color(0xFF6A88E5),
    ]);
    final centerSize = tester.widget<SizedBox>(
      find.ancestor(
        of: centerIcon,
        matching: find.byWidgetPredicate(
          (Widget widget) => widget is SizedBox && widget.width == 60 && widget.height == 60,
        ),
      ),
    );
    expect(centerSize.width, 60);
    expect(find.ancestor(of: centerIcon, matching: find.byType(InkWell)), findsNothing);
    expect(find.ancestor(of: centerIcon, matching: find.byType(IconButton)), findsNothing);
    expect(
      find.descendant(of: navigation, matching: find.image(const AssetImage('assets/fitness_app/tab_1s.png'))),
      findsOneWidget,
    );
    expect(
      find.descendant(of: navigation, matching: find.image(const AssetImage('assets/fitness_app/tab_2.png'))),
      findsOneWidget,
    );
    expect(
      find.descendant(of: navigation, matching: find.image(const AssetImage('assets/fitness_app/tab_3.png'))),
      findsOneWidget,
    );
    expect(
      find.descendant(of: navigation, matching: find.image(const AssetImage('assets/fitness_app/tab_4.png'))),
      findsOneWidget,
    );
    final diarySemantics = find.descendant(of: navigation, matching: find.bySemanticsLabel('Diary')).first;
    expect(tester.getSemantics(diarySemantics).flagsCollection.isSelected, Tristate.isTrue);
    expect(find.ancestor(of: find.text('Details'), matching: find.byType(InkWell)), findsNothing);
    expect(find.text('15 May'), findsOneWidget);
    expect(find.bySemanticsLabel('Sample day, 15 May'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);

    final trainingButtons = find.descendant(of: navigation, matching: find.bySemanticsLabel('Training'));
    final firstTrainingControl = find.descendant(of: trainingButtons.first, matching: find.byType(InkWell));
    expect(firstTrainingControl, findsOneWidget);
    await tester.tap(firstTrainingControl);

    var maximumPulseScale = 0.88;
    for (var frame = 0; frame < 30; frame += 1) {
      await tester.pump(const Duration(milliseconds: 16));
      final selectedTrainingImage = find.descendant(
        of: navigation,
        matching: find.image(const AssetImage('assets/fitness_app/tab_2s.png')),
      );
      expect(selectedTrainingImage, findsOneWidget);
      final selectionPulse = tester.widget<ScaleTransition>(
        find.ancestor(of: selectedTrainingImage, matching: find.byType(ScaleTransition)),
      );
      if (selectionPulse.scale.value > maximumPulseScale) {
        maximumPulseScale = selectionPulse.scale.value;
      }
    }

    expect(find.text('Your program'), findsOneWidget);
    final trainingSemantics = trainingButtons.first;
    expect(tester.getSemantics(trainingSemantics).flagsCollection.isSelected, Tristate.isTrue);
    expect(maximumPulseScale, greaterThan(0.88));

    await tester.pump(const Duration(milliseconds: 400));
    final settledTrainingImage = find.descendant(
      of: navigation,
      matching: find.image(const AssetImage('assets/fitness_app/tab_2s.png')),
    );
    final settledPulse = tester.widget<ScaleTransition>(
      find.ancestor(of: settledTrainingImage, matching: find.byType(ScaleTransition)),
    );
    expect(settledPulse.scale.value, closeTo(0.88, 0.001));

    final diaryButtons = find.descendant(of: navigation, matching: find.bySemanticsLabel('Diary'));
    await tester.tap(diaryButtons.at(1));
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('My Diary'), findsOneWidget);
    expect(
      find.descendant(of: navigation, matching: find.image(const AssetImage('assets/fitness_app/tab_3s.png'))),
      findsOneWidget,
    );
    expect(tester.getSemantics(diaryButtons.at(1)).flagsCollection.isSelected, Tristate.isTrue);

    await tester.tap(trainingButtons.at(1));
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Your program'), findsOneWidget);
    expect(
      find.descendant(of: navigation, matching: find.image(const AssetImage('assets/fitness_app/tab_4s.png'))),
      findsOneWidget,
    );
    expect(tester.getSemantics(trainingButtons.at(1)).flagsCollection.isSelected, Tristate.isTrue);
    expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('fitness focus illustrations are descriptive rather than fake buttons', (WidgetTester tester) async {
    final controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: tester);
    addTearDown(controller.dispose);
    _evictAssets(<String>[
      'assets/fitness_app/area1.png',
      'assets/fitness_app/area2.png',
      'assets/fitness_app/area3.png',
    ]);
    await _pumpScreen(tester, AreaListView(mainScreenAnimation: controller));
    controller.value = 1;
    await tester.pump(const Duration(seconds: 2));

    expect(find.bySemanticsLabel('Sample training focus illustration'), findsNWidgets(4));
    expect(find.byType(InkWell), findsNothing);
  });
}

Future<void> _pumpScreen(WidgetTester tester, Widget screen, {Size size = const Size(430, 932)}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(home: Scaffold(body: screen)));
  await tester.pump();
}

void _evictAssets(Iterable<String> assets) {
  for (final asset in assets) {
    rootBundle.evict(asset);
  }
}
