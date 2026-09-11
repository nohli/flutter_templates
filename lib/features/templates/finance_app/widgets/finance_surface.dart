import 'package:flutter/material.dart';

import '../finance_app_theme.dart';

class FinanceSurface extends StatelessWidget {
  const FinanceSurface({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        boxShadow: FinanceAppTheme.softShadow,
      ),
      child: Material(type: MaterialType.transparency, child: child),
    );
  }
}
