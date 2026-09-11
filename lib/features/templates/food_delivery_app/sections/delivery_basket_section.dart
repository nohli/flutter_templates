import 'package:flutter/material.dart';

import '../food_delivery_formatters.dart';
import '../models/meal.dart';
import '../widgets/delivery_basket_item.dart';

class DeliveryBasketSection extends StatelessWidget {
  const DeliveryBasketSection({
    required this.quantities,
    required this.scrollController,
    required this.onAdd,
    required this.onRemove,
    required this.onCheckout,
    super.key,
  });

  final Map<String, int> quantities;
  final ScrollController scrollController;
  final ValueChanged<Meal> onAdd;
  final ValueChanged<Meal> onRemove;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final meals = Meal.samples.where((Meal meal) => quantities.containsKey(meal.id)).toList(growable: false);
    final subtotal = meals.fold<double>(0, (double sum, Meal meal) => sum + meal.price * quantities[meal.id]!);
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('delivery-basket'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Your basket', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('A simple, reusable quantity and checkout pattern.', style: TextStyle(color: colors.onSurfaceVariant)),
        const SizedBox(height: 20),
        if (meals.isEmpty)
          const _EmptyBasketState()
        else ...<Widget>[
          Material(
            color: colors.surface,
            borderRadius: const BorderRadius.all(Radius.circular(26)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                for (final meal in meals) ...<Widget>[
                  DeliveryBasketItem(
                    meal: meal,
                    quantity: quantities[meal.id]!,
                    onAdd: () => onAdd(meal),
                    onRemove: () => onRemove(meal),
                  ),
                  if (meal != meals.last)
                    Padding(
                      padding: const EdgeInsets.only(left: 88),
                      child: Divider(height: 1, color: colors.outlineVariant),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(26)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text('Sample subtotal', style: TextStyle(color: Color(0xFFD9E1DC))),
                    ),
                    Text(
                      formatDeliveryPrice(context, subtotal),
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onCheckout,
                    style: FilledButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.onPrimary),
                    child: const Text('Preview checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyBasketState extends StatelessWidget {
  const _EmptyBasketState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
        child: Column(
          children: <Widget>[
            Icon(Icons.takeout_dining_outlined, size: 44, color: colors.primary),
            const SizedBox(height: 12),
            const Text('Your basket is waiting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Add a meal from Discover to try the flow.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
