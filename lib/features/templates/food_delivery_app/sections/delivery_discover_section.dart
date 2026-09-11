import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';
import '../models/meal.dart';
import '../widgets/meal_art.dart';
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
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('delivery-discover'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const _DeliveryPoster(),
        const SizedBox(height: 18),
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Search meals or restaurants',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: colors.outlineVariant),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.outlineVariant),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
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
                  showCheckmark: false,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
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
              child: Text(
                'TODAY’S MENU',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.3),
              ),
            ),
            Text('${meals.length} meals', style: TextStyle(color: colors.onSurfaceVariant)),
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

class _DeliveryPoster extends StatelessWidget {
  const _DeliveryPoster();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final background = dark ? const Color(0xFF2C1711) : const Color(0xFFF04D2F);
    const foreground = Color(0xFFFFF1D1);

    if (usesLargeText) {
      return ColoredBox(
        color: background,
        child: const Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'FRESH / FAST / LOCAL',
                style: TextStyle(color: foreground, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
              SizedBox(height: 16),
              Text(
                'Good food, right on time.',
                style: TextStyle(color: foreground, fontSize: 19, fontWeight: FontWeight.w900, height: 0.98),
              ),
              SizedBox(height: 14),
              Text(
                'Fresh local favorites, ready when you are.',
                style: TextStyle(color: Color(0xD9FFF1D1), fontSize: 11, height: 1.3),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 174,
      child: ColoredBox(
        color: background,
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: CustomPaint(painter: _PosterStripePainter())),
            const Positioned(
              left: 18,
              top: 18,
              child: Text(
                'FRESH / FAST / LOCAL',
                style: TextStyle(color: foreground, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
            ),
            const Positioned(
              left: 18,
              top: 43,
              width: 200,
              child: Text(
                'Good food, right on time.',
                style: TextStyle(
                  color: foreground,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 0.92,
                ),
              ),
            ),
            const Positioned(
              left: 18,
              bottom: 14,
              width: 190,
              child: Text(
                'Fresh local favorites, ready when you are.',
                style: TextStyle(color: Color(0xD9FFF1D1), fontSize: 11, height: 1.3),
              ),
            ),
            Positioned(
              right: 17,
              top: 32,
              width: 116,
              height: 128,
              child: Transform.rotate(
                angle: 0.055,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: foreground,
                    boxShadow: <BoxShadow>[BoxShadow(color: Color(0x29000000), blurRadius: 12, offset: Offset(0, 6))],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: MealArt(kind: MealKind.bowl, compact: true),
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 10,
              top: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(color: FoodDeliveryAppTheme.yellow, shape: BoxShape.circle),
                child: SizedBox.square(
                  dimension: 46,
                  child: Center(
                    child: Text(
                      '18\nMIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: FoodDeliveryAppTheme.deepOrange,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        height: 0.9,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterStripePainter extends CustomPainter {
  const _PosterStripePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x12FFF1D1);
    for (var x = -size.height; x < size.width; x += 30) {
      canvas.save();
      canvas.translate(x, 0);
      canvas.rotate(-0.16);
      canvas.drawRect(Rect.fromLTWH(0, 0, 11, size.height * 1.2), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PosterStripePainter oldDelegate) => false;
}

class _EmptyMealState extends StatelessWidget {
  const _EmptyMealState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: <Widget>[
            Icon(Icons.search_off_rounded, size: 42, color: colors.primary),
            const SizedBox(height: 12),
            const Text('No matching meals', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
