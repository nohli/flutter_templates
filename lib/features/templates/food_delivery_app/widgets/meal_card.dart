import 'package:flutter/material.dart';

import '../food_delivery_formatters.dart';
import '../food_delivery_app_theme.dart';
import '../models/meal.dart';
import 'meal_art.dart';

class MealCard extends StatelessWidget {
  const MealCard({required this.meal, required this.onAdd, super.key});

  final Meal meal;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.55,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MealArt(kind: meal.kind),
                ),
                Positioned(left: 0, top: 0, child: _MealNumber(kind: meal.kind)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  meal.restaurant.toUpperCase(),
                  style: TextStyle(color: colors.secondary, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const SizedBox(height: 3),
                Text(meal.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                const SizedBox(height: 5),
                Text(meal.description, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12, height: 1.35)),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_rounded, color: colors.primary, size: 17),
                    const SizedBox(width: 3),
                    Text('${meal.rating}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        meal.etaLabel,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        formatDeliveryPrice(context, meal.price),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton.filled(
                      tooltip: 'Add ${meal.name} to basket',
                      onPressed: onAdd,
                      style: IconButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                      icon: const Icon(Icons.arrow_outward_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealNumber extends StatelessWidget {
  const _MealNumber({required this.kind});

  final MealKind kind;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FoodDeliveryAppTheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(switch (kind) {
          MealKind.bowl => '01',
          MealKind.pizza => '02',
          MealKind.toast => '03',
          MealKind.salad => '04',
        }, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
