import 'package:flutter/material.dart';

import '../banking_app_theme.dart';
import '../models/banking_payment.dart';
import 'banking_balance_hero.dart';

class BankingHomeContent extends StatelessWidget {
  const BankingHomeContent({
    required this.balanceVisible,
    required this.onToggleBalance,
    required this.onSend,
    super.key,
  });

  final bool balanceVisible;
  final VoidCallback onToggleBalance;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 110),
      children: <Widget>[
        const _BankingHeader(),
        const SizedBox(height: 22),
        BankingBalanceHero(balanceVisible: balanceVisible, onToggleVisibility: onToggleBalance),
        const SizedBox(height: 28),
        _QuickActions(onSend: onSend),
        const SizedBox(height: 30),
        const _SectionHeader(title: 'Your money', action: 'Exchange rates'),
        const SizedBox(height: 13),
        const _CurrencyRail(),
        const SizedBox(height: 30),
        const _SectionHeader(title: 'Latest', action: 'See all'),
        const SizedBox(height: 8),
        for (final payment in BankingPayment.samples) _PaymentTile(payment: payment),
      ],
    );
  }
}

class _BankingHeader extends StatelessWidget {
  const _BankingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          tooltip: 'Back to template gallery',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 7),
        const Text(
          'arc',
          style: TextStyle(
            fontFamily: BankingAppTheme.displayFontName,
            fontSize: 31,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Search',
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          icon: const Icon(Icons.search_rounded),
        ),
        const SizedBox(width: 6),
        const CircleAvatar(
          radius: 22,
          backgroundColor: BankingAppTheme.acid,
          foregroundColor: Color(0xFF263000),
          child: Text('TN', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onSend});

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _QuickAction(label: 'Add money', icon: Icons.add_rounded, onTap: () {}),
        _QuickAction(label: 'Send', icon: Icons.north_east_rounded, onTap: onSend),
        _QuickAction(label: 'Exchange', icon: Icons.swap_horiz_rounded, onTap: () {}),
        _QuickAction(label: 'Split bill', icon: Icons.call_split_rounded, onTap: () {}),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Semantics(
        label: label,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Icon(icon, color: colors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const Spacer(),
        Text(
          action,
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _CurrencyRail extends StatelessWidget {
  const _CurrencyRail();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          _CurrencyCard(code: 'EUR', amount: '€8,942', change: 'Primary', color: BankingAppTheme.acid),
          SizedBox(width: 10),
          _CurrencyCard(code: 'USD', amount: r'$2,180', change: '1 EUR = 1.17 USD', color: BankingAppTheme.ice),
          SizedBox(width: 10),
          _CurrencyCard(code: 'GBP', amount: '£640', change: '1 EUR = 0.86 GBP', color: BankingAppTheme.coral),
        ],
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({required this.code, required this.amount, required this.change, required this.color});

  final String code;
  final String amount;
  final String change;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            code,
            style: const TextStyle(
              color: Color(0xFF1D1B20),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(color: Color(0xFF1D1B20), fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            change,
            style: const TextStyle(color: Color(0xAA1D1B20), fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment});

  final BankingPayment payment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: payment.color.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Icon(payment.icon, color: payment.color),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(payment.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(
                  payment.detail,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(payment.amount, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
