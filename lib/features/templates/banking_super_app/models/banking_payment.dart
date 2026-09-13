import 'package:flutter/material.dart';

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

  static const samples = <BankingPayment>[
    BankingPayment(
      name: 'Nomad Coffee',
      detail: 'Today · Card',
      amount: '− €6.80',
      icon: Icons.local_cafe_rounded,
      color: Color(0xFFFFB15A),
    ),
    BankingPayment(
      name: 'Mina Park',
      detail: 'Yesterday · Transfer',
      amount: '+ €48.00',
      icon: Icons.person_rounded,
      color: Color(0xFF8A7CF6),
    ),
    BankingPayment(
      name: 'Metro',
      detail: 'Yesterday · Transport',
      amount: '− €3.20',
      icon: Icons.directions_subway_rounded,
      color: Color(0xFF74C9E8),
    ),
  ];
}
