import 'package:flutter/material.dart';

import '../models/finance_transaction.dart';
import '../widgets/finance_entrance.dart';
import '../widgets/transaction_list.dart';

enum _ActivityFilter { all, income, spending }

class FinanceActivitySection extends StatefulWidget {
  const FinanceActivitySection({required this.animation, required this.scrollController, super.key});

  final Animation<double> animation;
  final ScrollController scrollController;

  @override
  State<FinanceActivitySection> createState() => _FinanceActivitySectionState();
}

class _FinanceActivitySectionState extends State<FinanceActivitySection> {
  var _filter = _ActivityFilter.all;

  @override
  Widget build(BuildContext context) {
    final transactions = FinanceTransaction.samples
        .where((FinanceTransaction transaction) {
          return switch (_filter) {
            _ActivityFilter.all => true,
            _ActivityFilter.income => transaction.isIncome,
            _ActivityFilter.spending => !transaction.isIncome,
          };
        })
        .toList(growable: false);

    return ListView(
      key: const PageStorageKey<String>('finance-activity'),
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: <Widget>[
        FinanceEntrance(
          animation: widget.animation,
          index: 0,
          child: Text(
            'A clear view of every sample transaction.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
          ),
        ),
        const SizedBox(height: 18),
        FinanceEntrance(
          animation: widget.animation,
          index: 1,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final filter in _ActivityFilter.values)
                ChoiceChip(
                  label: Text(_labelFor(filter)),
                  selected: _filter == filter,
                  showCheckmark: false,
                  onSelected: (_) {
                    setState(() {
                      _filter = filter;
                    });
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FinanceEntrance(
          animation: widget.animation,
          index: 2,
          child: AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(animation),
                  child: child,
                ),
              );
            },
            child: FinanceTransactionList(
              key: ValueKey<_ActivityFilter>(_filter),
              animation: widget.animation,
              transactions: transactions,
            ),
          ),
        ),
      ],
    );
  }

  String _labelFor(_ActivityFilter filter) => switch (filter) {
    _ActivityFilter.all => 'All',
    _ActivityFilter.income => 'Income',
    _ActivityFilter.spending => 'Spending',
  };
}
