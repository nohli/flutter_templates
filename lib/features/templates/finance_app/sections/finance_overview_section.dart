import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../models/finance_transaction.dart';
import '../widgets/balance_card.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: <Widget>[
        FinanceEntrance(animation: animation, index: 0, child: const _OverviewGreeting()),
        const SizedBox(height: 14),
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
        FinanceEntrance(
          animation: animation,
          index: 4,
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
    return const Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Good morning, Alex', style: TextStyle(color: FinanceAppTheme.mutedInk, fontSize: 14)),
              SizedBox(height: 3),
              Text('Your money, at a glance', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: FinanceAppTheme.lavender,
          child: Text(
            'AR',
            style: TextStyle(color: FinanceAppTheme.primaryDark, fontSize: 13, fontWeight: FontWeight.w700),
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
