import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';
import '../food_delivery_formatters.dart';
import '../models/meal.dart';
import 'meal_art.dart';

class DeliveryBasketItem extends StatelessWidget {
  const DeliveryBasketItem({
    required this.meal,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final Meal meal;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final art = SizedBox.square(dimension: 64, child: MealArt(kind: meal.kind, compact: true));
    final details = _MealDetails(meal: meal, quantity: quantity);
    final controls = _QuantityControls(meal: meal, quantity: quantity, onAdd: onAdd, onRemove: onRemove);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: usesLargeText
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    art,
                    const SizedBox(width: 12),
                    Expanded(child: details),
                  ],
                ),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: controls),
              ],
            )
          : Row(
              children: <Widget>[
                art,
                const SizedBox(width: 12),
                Expanded(child: details),
                controls,
              ],
            ),
    );
  }
}

class _MealDetails extends StatelessWidget {
  const _MealDetails({required this.meal, required this.quantity});

  final Meal meal;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(meal.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          formatDeliveryPrice(context, meal.price * quantity),
          style: const TextStyle(color: FoodDeliveryAppTheme.primary, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({required this.meal, required this.quantity, required this.onAdd, required this.onRemove});

  final Meal meal;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          tooltip: 'Remove one ${meal.name}',
          onPressed: onRemove,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w700)),
        IconButton(tooltip: 'Add one ${meal.name}', onPressed: onAdd, icon: const Icon(Icons.add_circle_outline)),
      ],
    );
  }
}
