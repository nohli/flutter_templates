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

  static const samples = <FinanceTransaction>[
    FinanceTransaction(
      id: 'salary-september',
      title: 'Salary',
      subtitle: 'Today · Monthly income',
      amount: 4200,
      category: TransactionCategory.income,
    ),
    FinanceTransaction(
      id: 'green-market',
      title: 'Green Market',
      subtitle: 'Today · Groceries',
      amount: -84.60,
      category: TransactionCategory.groceries,
    ),
    FinanceTransaction(
      id: 'metro-pass',
      title: 'Metro Pass',
      subtitle: 'Yesterday · Transport',
      amount: -42,
      category: TransactionCategory.transport,
    ),
    FinanceTransaction(
      id: 'north-star-cafe',
      title: 'North Star Café',
      subtitle: 'Yesterday · Dining',
      amount: -18.40,
      category: TransactionCategory.dining,
    ),
    FinanceTransaction(
      id: 'studio-cloud',
      title: 'Studio Cloud',
      subtitle: '8 Sep · Subscription',
      amount: -12.99,
      category: TransactionCategory.subscription,
    ),
  ];
}
