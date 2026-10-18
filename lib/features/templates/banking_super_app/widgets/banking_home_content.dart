import 'package:flutter/material.dart';

import '../banking_app_theme.dart';
import '../models/banking_payment.dart';
import 'banking_balance_hero.dart';
import '../../../../l10n/localizations.dart';

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
        _SectionHeader(title: context.l10n.yourMoney, action: context.l10n.exchangeRates),
        const SizedBox(height: 13),
        const _CurrencyRail(),
        const SizedBox(height: 30),
        _SectionHeader(title: context.l10n.latest, action: context.l10n.seeAll),
        const SizedBox(height: 8),
        for (final payment in BankingPayment.samples(context.l10n)) _PaymentTile(payment: payment),
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
          tooltip: context.l10n.backToTemplateGallery,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            context.l10n.banking,
            style: const TextStyle(
              fontFamily: BankingAppTheme.displayFontName,
              fontSize: 31,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.5,
            ),
          ),
        ),
        IconButton(
          tooltip: context.l10n.search,
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
          child: Text('AR', style: TextStyle(fontWeight: FontWeight.w800)),
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
        _QuickAction(label: context.l10n.addMoney, icon: Icons.add_rounded, onTap: () {}),
        _QuickAction(label: context.l10n.send, icon: Icons.north_east_rounded, onTap: onSend),
        _QuickAction(label: context.l10n.exchange, icon: Icons.swap_horiz_rounded, onTap: () {}),
        _QuickAction(label: context.l10n.splitBill, icon: Icons.call_split_rounded, onTap: () {}),
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
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 12),
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
        children: <Widget>[
          _CurrencyCard(
            code: 'EUR',
            amount: context.l10n.money(8942, 'EUR', decimalDigits: 0),
            change: context.l10n.primary,
            color: BankingAppTheme.acid,
          ),
          const SizedBox(width: 10),
          _CurrencyCard(
            code: 'USD',
            amount: context.l10n.money(2180, 'USD', decimalDigits: 0),
            change: '${context.l10n.number(1)} EUR = ${context.l10n.number(1.17)} USD',
            changeTextDirection: TextDirection.ltr,
            color: BankingAppTheme.ice,
          ),
          const SizedBox(width: 10),
          _CurrencyCard(
            code: 'GBP',
            amount: context.l10n.money(640, 'GBP', decimalDigits: 0),
            change: '${context.l10n.number(1)} EUR = ${context.l10n.number(0.86)} GBP',
            changeTextDirection: TextDirection.ltr,
            color: BankingAppTheme.coral,
          ),
        ],
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.code,
    required this.amount,
    required this.change,
    required this.color,
    this.changeTextDirection,
  });

  final String code;
  final String amount;
  final String change;
  final Color color;
  final TextDirection? changeTextDirection;

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
            textDirection: changeTextDirection,
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
