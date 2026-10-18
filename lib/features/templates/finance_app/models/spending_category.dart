import '../../../../l10n/localizations.dart';

enum SpendingCategoryKind { home, food, transport }

class SpendingCategory {
  const SpendingCategory({required this.label, required this.spent, required this.budget, required this.kind});

  final String label;
  final double spent;
  final double budget;
  final SpendingCategoryKind kind;

  double get progress => budget <= 0 ? 0 : (spent / budget).clamp(0, 1);

  static List<SpendingCategory> samples(AppLocalizations l10n) => <SpendingCategory>[
    SpendingCategory(label: l10n.home, spent: 1180, budget: 1400, kind: SpendingCategoryKind.home),
    SpendingCategory(label: l10n.food, spent: 620, budget: 900, kind: SpendingCategoryKind.food),
    SpendingCategory(label: l10n.transport, spent: 240, budget: 400, kind: SpendingCategoryKind.transport),
  ];
}
