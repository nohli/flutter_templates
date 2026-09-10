import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';
import '../models/meal.dart';

class MealArt extends StatelessWidget {
  const MealArt({required this.kind, this.compact = false, super.key});

  final MealKind kind;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(kind);

    return Semantics(
      image: true,
      label: _labelFor(kind),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        child: ColoredBox(
          color: palette.background,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: compact ? -16 : -28,
                right: compact ? -12 : -20,
                child: CircleAvatar(radius: compact ? 26 : 48, backgroundColor: palette.accent.withValues(alpha: 0.35)),
              ),
              Positioned(
                left: compact ? -10 : -16,
                bottom: compact ? -14 : -24,
                child: CircleAvatar(radius: compact ? 22 : 40, backgroundColor: Colors.white.withValues(alpha: 0.55)),
              ),
              Icon(_iconFor(kind), size: compact ? 34 : 64, color: palette.foreground),
            ],
          ),
        ),
      ),
    );
  }

  ({Color background, Color foreground, Color accent}) _paletteFor(MealKind kind) => switch (kind) {
    MealKind.bowl => (
      background: FoodDeliveryAppTheme.yellow,
      foreground: FoodDeliveryAppTheme.deepOrange,
      accent: FoodDeliveryAppTheme.primary,
    ),
    MealKind.pizza => (
      background: FoodDeliveryAppTheme.peach,
      foreground: FoodDeliveryAppTheme.deepOrange,
      accent: FoodDeliveryAppTheme.yellow,
    ),
    MealKind.toast => (
      background: FoodDeliveryAppTheme.mint,
      foreground: FoodDeliveryAppTheme.green,
      accent: FoodDeliveryAppTheme.yellow,
    ),
    MealKind.salad => (
      background: const Color(0xFFD7EEDB),
      foreground: FoodDeliveryAppTheme.green,
      accent: const Color(0xFF8BC7A2),
    ),
  };

  IconData _iconFor(MealKind kind) => switch (kind) {
    MealKind.bowl => Icons.ramen_dining_rounded,
    MealKind.pizza => Icons.local_pizza_rounded,
    MealKind.toast => Icons.breakfast_dining_rounded,
    MealKind.salad => Icons.eco_rounded,
  };

  String _labelFor(MealKind kind) => switch (kind) {
    MealKind.bowl => 'Illustration of a grain bowl',
    MealKind.pizza => 'Illustration of a pizza',
    MealKind.toast => 'Illustration of avocado toast',
    MealKind.salad => 'Illustration of a garden salad',
  };
}
