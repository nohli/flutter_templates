import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../finance_formatters.dart';
import '../models/finance_transaction.dart';
import 'finance_entrance.dart';
import 'finance_surface.dart';

class FinanceTransactionList extends StatelessWidget {
  const FinanceTransactionList({required this.animation, required this.transactions, this.compact = false, super.key});

  final Animation<double> animation;
  final List<FinanceTransaction> transactions;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FinanceSurface(
      child: Column(
        children: <Widget>[
          for (var index = 0; index < transactions.length; index += 1) ...<Widget>[
            FinanceEntrance(
              animation: animation,
              index: index + 2,
              child: _TransactionTile(transaction: transactions[index], compact: compact),
            ),
            if (index != transactions.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 72),
                child: Divider(height: 1, color: FinanceAppTheme.divider),
              ),
          ],
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, required this.compact});

  final FinanceTransaction transaction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final amount = formatCurrency(context, transaction.amount);
    final amountColor = transaction.isIncome ? const Color(0xFF167A5B) : FinanceAppTheme.ink;

    return Semantics(
      container: true,
      label: '${transaction.title}, ${transaction.subtitle}, $amount',
      child: ExcludeSemantics(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: compact ? 12 : 15),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _backgroundFor(transaction.category),
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                ),
                alignment: Alignment.center,
                child: Icon(_iconFor(transaction.category), size: 20, color: _foregroundFor(transaction.category)),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(transaction.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(
                      transaction.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: FinanceAppTheme.mutedInk),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                amount,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: amountColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _backgroundFor(TransactionCategory category) => switch (category) {
    TransactionCategory.dining => const Color(0xFFFFE7E2),
    TransactionCategory.groceries => const Color(0xFFE0F7EF),
    TransactionCategory.income => FinanceAppTheme.lavender,
    TransactionCategory.subscription => const Color(0xFFFFF0D3),
    TransactionCategory.transport => const Color(0xFFE5F2FF),
  };

  Color _foregroundFor(TransactionCategory category) => switch (category) {
    TransactionCategory.dining => FinanceAppTheme.coral,
    TransactionCategory.groceries => const Color(0xFF258E70),
    TransactionCategory.income => FinanceAppTheme.primary,
    TransactionCategory.subscription => const Color(0xFFB67400),
    TransactionCategory.transport => const Color(0xFF2675B8),
  };

  IconData _iconFor(TransactionCategory category) => switch (category) {
    TransactionCategory.dining => Icons.local_cafe_rounded,
    TransactionCategory.groceries => Icons.shopping_basket_rounded,
    TransactionCategory.income => Icons.south_west_rounded,
    TransactionCategory.subscription => Icons.cloud_rounded,
    TransactionCategory.transport => Icons.train_rounded,
  };
}
