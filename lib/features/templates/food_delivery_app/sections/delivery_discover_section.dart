import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';

class DeliveryDiscoverSection extends StatelessWidget {
  const DeliveryDiscoverSection({
    required this.meals,
    required this.selectedCategory,
    required this.scrollController,
    required this.onQueryChanged,
    required this.onCategorySelected,
    required this.onAddMeal,
    super.key,
  });

  final List<Meal> meals;
  final MealCategory selectedCategory;
  final ScrollController scrollController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<MealCategory> onCategorySelected;
  final ValueChanged<Meal> onAddMeal;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('delivery-discover'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Good food, right on time.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text(
          'Fresh local favorites, ready when you are.',
          style: TextStyle(color: FoodDeliveryAppTheme.mutedInk),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: onQueryChanged,
          decoration: const InputDecoration(
            hintText: 'Search meals or restaurants',
            prefixIcon: Icon(Icons.search_rounded),
            filled: true,
            fillColor: FoodDeliveryAppTheme.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final category in MealCategory.values) ...<Widget>[
                ChoiceChip(
                  label: Text(_labelFor(category)),
                  selected: selectedCategory == category,
                  onSelected: (_) => onCategorySelected(category),
                ),
                if (category != MealCategory.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: <Widget>[
            const Expanded(
              child: Text('Popular nearby', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            Text('${meals.length} meals', style: const TextStyle(color: FoodDeliveryAppTheme.mutedInk)),
          ],
        ),
        const SizedBox(height: 14),
        if (meals.isEmpty)
          const _EmptyMealState()
        else
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final usesColumns = constraints.maxWidth >= 380 && MediaQuery.textScalerOf(context).scale(1) < 1.6;
              final width = usesColumns ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  for (final meal in meals)
                    SizedBox(
                      width: width,
                      child: MealCard(meal: meal, onAdd: () => onAddMeal(meal)),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  String _labelFor(MealCategory category) => switch (category) {
    MealCategory.all => 'All',
    MealCategory.bowls => 'Bowls',
    MealCategory.pizza => 'Pizza',
    MealCategory.plantBased => 'Plant based',
  };
}

class _EmptyMealState extends StatelessWidget {
  const _EmptyMealState();

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: FoodDeliveryAppTheme.surface,
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: <Widget>[
            Icon(Icons.search_off_rounded, size: 42, color: FoodDeliveryAppTheme.primary),
            SizedBox(height: 12),
            Text('No matching meals', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
