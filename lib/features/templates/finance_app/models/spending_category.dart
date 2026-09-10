enum SpendingCategoryKind { home, food, transport }

class SpendingCategory {
  const SpendingCategory({required this.label, required this.spent, required this.budget, required this.kind});

  final String label;
  final double spent;
  final double budget;
  final SpendingCategoryKind kind;

  double get progress => budget <= 0 ? 0 : (spent / budget).clamp(0, 1);

  static const samples = <SpendingCategory>[
    SpendingCategory(label: 'Home', spent: 1180, budget: 1400, kind: SpendingCategoryKind.home),
    SpendingCategory(label: 'Food', spent: 620, budget: 900, kind: SpendingCategoryKind.food),
    SpendingCategory(label: 'Transport', spent: 240, budget: 400, kind: SpendingCategoryKind.transport),
  ];
}
