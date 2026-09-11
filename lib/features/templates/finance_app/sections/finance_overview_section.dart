import 'package:flutter/material.dart';

import '../models/finance_transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/crypto_portfolio.dart';
import '../widgets/finance_entrance.dart';
import '../widgets/quick_actions.dart';
import '../widgets/spending_overview.dart';
import '../widgets/transaction_list.dart';

class FinanceOverviewSection extends StatelessWidget {
  const FinanceOverviewSection({
    required this.animation,
    required this.balanceIsVisible,
    required this.onToggleBalance,
    required this.onQuickAction,
    required this.onViewAllActivity,
    required this.scrollController,
    super.key,
  });

  final Animation<double> animation;
  final bool balanceIsVisible;
  final VoidCallback onToggleBalance;
  final ValueChanged<String> onQuickAction;
  final VoidCallback onViewAllActivity;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('finance-overview'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
      children: <Widget>[
        FinanceEntrance(animation: animation, index: 0, child: const _OverviewGreeting()),
        const SizedBox(height: 18),
        FinanceEntrance(
          animation: animation,
          index: 1,
          child: BalanceCard(balanceIsVisible: balanceIsVisible, onToggleBalance: onToggleBalance),
        ),
        const SizedBox(height: 22),
        FinanceQuickActions(animation: animation, onSelected: onQuickAction),
        const SizedBox(height: 28),
        FinanceEntrance(
          animation: animation,
          index: 3,
          child: SpendingOverview(animation: animation),
        ),
        const SizedBox(height: 28),
        FinanceEntrance(animation: animation, index: 4, child: const CryptoPortfolio()),
        const SizedBox(height: 28),
        FinanceEntrance(
          animation: animation,
          index: 5,
          child: Column(
            children: <Widget>[
              _SectionHeader(title: 'Recent activity', actionLabel: 'See all', onPressed: onViewAllActivity),
              const SizedBox(height: 12),
              FinanceTransactionList(animation: animation, transactions: FinanceTransaction.samples, compact: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _OverviewGreeting extends StatelessWidget {
  const _OverviewGreeting();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(width: 24, height: 2, color: colors.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Good morning, Alex',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              const Text(
                'Money and crypto, together',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -1.1, height: 1.02),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
              bottomRight: Radius.circular(6),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            'AR',
            style: TextStyle(color: colors.onPrimary, fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel, required this.onPressed});

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        ),
        TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}
