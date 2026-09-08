import 'package:flutter/widgets.dart';

import '../design_course/home_design_course.dart';
import '../fitness_app/fitness_app_home_screen.dart';
import '../hotel_booking/hotel_home_screen.dart';

class HomeList {
  const HomeList({required this.title, required this.navigateScreen, required this.imagePath});

  final String title;
  final Widget navigateScreen;
  final String imagePath;

  static const homeList = <HomeList>[
    HomeList(title: 'Hotel Booking', navigateScreen: HotelHomeScreen(), imagePath: 'assets/hotel/hotel_booking.png'),
    HomeList(
      title: 'Fitness App',
      navigateScreen: FitnessAppHomeScreen(),
      imagePath: 'assets/fitness_app/fitness_app.png',
    ),
    HomeList(
      title: 'Design Course',
      navigateScreen: DesignCourseHomeScreen(),
      imagePath: 'assets/design_course/design_course.png',
    ),
  ];
}
