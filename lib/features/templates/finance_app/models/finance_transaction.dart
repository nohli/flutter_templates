import '../../../../l10n/localizations.dart';

enum TransactionCategory { dining, groceries, income, subscription, transport }

class FinanceTransaction {
  const FinanceTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.category,
  });

  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionCategory category;

  bool get isIncome => amount > 0;

  static List<FinanceTransaction> samples(AppLocalizations l10n) => <FinanceTransaction>[
    FinanceTransaction(
      id: 'salary-september',
      title: l10n.salary,
      subtitle: l10n.todayMonthlyIncome,
      amount: 4200,
      category: TransactionCategory.income,
    ),
    FinanceTransaction(
      id: 'green-market',
      title: l10n.greenMarket,
      subtitle: l10n.todayGroceries,
      amount: -84.60,
      category: TransactionCategory.groceries,
    ),
    FinanceTransaction(
      id: 'metro-pass',
      title: l10n.metroPass,
      subtitle: l10n.yesterdayTransport,
      amount: -42,
      category: TransactionCategory.transport,
    ),
    FinanceTransaction(
      id: 'north-star-cafe',
      title: l10n.northStarCaf,
      subtitle: l10n.yesterdayDining,
      amount: -18.40,
      category: TransactionCategory.dining,
    ),
    FinanceTransaction(
      id: 'studio-cloud',
      title: l10n.studioCloud,
      subtitle: l10n.sample8SepSubscription,
      amount: -12.99,
      category: TransactionCategory.subscription,
    ),
  ];
}
