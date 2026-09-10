enum MealCategory { all, bowls, pizza, plantBased }

enum MealKind { bowl, pizza, toast, salad }

class Meal {
  const Meal({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.description,
    required this.etaLabel,
    required this.price,
    required this.rating,
    required this.category,
    required this.kind,
  });

  final String id;
  final String name;
  final String restaurant;
  final String description;
  final String etaLabel;
  final double price;
  final double rating;
  final MealCategory category;
  final MealKind kind;

  static const samples = <Meal>[
    Meal(
      id: 'sunset-bowl',
      name: 'Sunset bowl',
      restaurant: 'Fresh Fork',
      description: 'Miso sweet potato, grains, greens',
      etaLabel: '18–24 min',
      price: 16,
      rating: 4.9,
      category: MealCategory.bowls,
      kind: MealKind.bowl,
    ),
    Meal(
      id: 'garden-pizza',
      name: 'Garden pizza',
      restaurant: 'Forno',
      description: 'Charred tomato, basil, burrata',
      etaLabel: '22–30 min',
      price: 19,
      rating: 4.8,
      category: MealCategory.pizza,
      kind: MealKind.pizza,
    ),
    Meal(
      id: 'avocado-toast',
      name: 'Avocado toast',
      restaurant: 'Daybreak',
      description: 'Sourdough, herbs, citrus crunch',
      etaLabel: '12–18 min',
      price: 12,
      rating: 4.7,
      category: MealCategory.plantBased,
      kind: MealKind.toast,
    ),
    Meal(
      id: 'citrus-salad',
      name: 'Citrus garden',
      restaurant: 'Green Room',
      description: 'Fennel, orange, leaves, pistachio',
      etaLabel: '16–22 min',
      price: 14,
      rating: 4.9,
      category: MealCategory.plantBased,
      kind: MealKind.salad,
    ),
  ];
}
