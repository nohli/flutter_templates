import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';
import '../food_delivery_formatters.dart';
import '../models/meal.dart';
import 'meal_art.dart';

class MealCard extends StatelessWidget {
  const MealCard({required this.meal, required this.onAdd, super.key});

  final Meal meal;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FoodDeliveryAppTheme.surface,
      borderRadius: const BorderRadius.all(Radius.circular(26)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(aspectRatio: 1.45, child: MealArt(kind: meal.kind)),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(meal.restaurant, style: const TextStyle(color: FoodDeliveryAppTheme.green, fontSize: 12)),
                const SizedBox(height: 3),
                Text(meal.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(
                  meal.description,
                  style: const TextStyle(color: FoodDeliveryAppTheme.mutedInk, fontSize: 12, height: 1.35),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star_rounded, color: FoodDeliveryAppTheme.primary, size: 17),
                    const SizedBox(width: 3),
                    Text('${meal.rating}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        meal.etaLabel,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: FoodDeliveryAppTheme.mutedInk, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                      icon: const Icon(Icons.add_rounded),
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
