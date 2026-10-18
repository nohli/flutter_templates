import 'package:flutter/material.dart';
import '../../../../l10n/localizations.dart';

class BankingPayment {
  const BankingPayment({
    required this.name,
    required this.detail,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String name;
  final String detail;
  final String amount;
  final IconData icon;
  final Color color;

  static List<BankingPayment> samples(AppLocalizations l10n) => <BankingPayment>[
    BankingPayment(
      name: l10n.nomadCoffee,
      detail: l10n.todayCard,
      amount: l10n.money(-6.8, 'EUR'),
      icon: Icons.local_cafe_rounded,
      color: const Color(0xFFFFB15A),
    ),
    BankingPayment(
      name: 'Mina Park',
      detail: l10n.yesterdayTransfer,
      amount: '+ ${l10n.money(48, 'EUR')}',
      icon: Icons.person_rounded,
      color: const Color(0xFF8A7CF6),
    ),
    BankingPayment(
      name: l10n.metro,
      detail: l10n.yesterdayTransport,
      amount: l10n.money(-3.2, 'EUR'),
      icon: Icons.directions_subway_rounded,
      color: const Color(0xFF74C9E8),
    ),
  ];
}
