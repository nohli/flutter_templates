import 'package:flutter/material.dart';
import '../../../../l10n/localizations.dart';

class MealsListData {
  const MealsListData({
    required this.imagePath,
    required this.title,
    required this.startColor,
    required this.endColor,
    required this.meals,
    this.kcal,
  });

  final String imagePath;
  final String title;
  final Color startColor;
  final Color endColor;
  final List<String> meals;
  final int? kcal;

  static List<MealsListData> samples(AppLocalizations l10n) => <MealsListData>[
    MealsListData(
      imagePath: 'assets/fitness_app/breakfast.png',
      title: l10n.breakfast,
      kcal: 525,
      meals: <String>[l10n.bread, l10n.peanutButter, l10n.apple],
      startColor: const Color(0xFFFA7D82),
      endColor: const Color(0xFFFFB295),
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/lunch.png',
      title: l10n.lunch,
      kcal: 602,
      meals: <String>[l10n.salmon, l10n.mixedVeggies, l10n.avocado],
      startColor: const Color(0xFF738AE6),
      endColor: const Color(0xFF5C5EDD),
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/snack.png',
      title: l10n.snack,
      meals: <String>[l10n.recommend, l10n.sample800Kcal],
      startColor: const Color(0xFFFE95B6),
      endColor: const Color(0xFFFF5287),
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/dinner.png',
      title: l10n.dinner,
      meals: <String>[l10n.recommend, l10n.sample703Kcal],
      startColor: const Color(0xFF6F72CA),
      endColor: const Color(0xFF1E1466),
    ),
  ];
}
