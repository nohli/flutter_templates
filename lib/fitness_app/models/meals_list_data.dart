import 'package:flutter/material.dart';

class MealsListData {
  const MealsListData({
    required this.meals,
    this.imagePath = '',
    this.title = '',
    this.startColor = Colors.grey,
    this.endColor = Colors.grey,
    this.kcal = 0,
  });

  final String imagePath;
  final String title;
  final Color startColor;
  final Color endColor;
  final List<String> meals;
  final int kcal;

  static const samples = <MealsListData>[
    MealsListData(
      imagePath: 'assets/fitness_app/breakfast.png',
      title: 'Breakfast',
      kcal: 525,
      meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: Color(0xFFFA7D82),
      endColor: Color(0xFFFFB295),
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/lunch.png',
      title: 'Lunch',
      kcal: 602,
      meals: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
      startColor: Color(0xFF738AE6),
      endColor: Color(0xFF5C5EDD),
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/snack.png',
      title: 'Snack',
      meals: <String>['Recommend:', '800 kcal'],
      startColor: Color(0xFFFE95B6),
      endColor: Color(0xFFFF5287),
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/dinner.png',
      title: 'Dinner',
      meals: <String>['Recommend:', '703 kcal'],
      startColor: Color(0xFF6F72CA),
      endColor: Color(0xFF1E1466),
    ),
  ];
}
