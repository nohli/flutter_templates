import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import 'finance_entrance.dart';

class FinanceQuickActions extends StatelessWidget {
  const FinanceQuickActions({required this.animation, required this.onSelected, super.key});

  final Animation<double> animation;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FinanceEntrance(
            animation: animation,
            index: 2,
            child: _QuickAction(label: 'Send', icon: Icons.arrow_outward_rounded, onTap: onSelected),
          ),
        ),
        Expanded(
          child: FinanceEntrance(
            animation: animation,
            index: 3,
            child: _QuickAction(label: 'Add money', icon: Icons.add_rounded, onTap: onSelected),
          ),
        ),
        Expanded(
          child: FinanceEntrance(
            animation: animation,
            index: 4,
            child: _QuickAction(label: 'Request', icon: Icons.south_west_rounded, onTap: onSelected),
          ),
        ),
        Expanded(
          child: FinanceEntrance(
            animation: animation,
            index: 5,
            child: _QuickAction(label: 'More', icon: Icons.more_horiz_rounded, onTap: onSelected),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      onTap: () => onTap(label),
      child: ExcludeSemantics(
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: FinanceAppTheme.primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
          ),
          onPressed: () => onTap(label),
          child: Column(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: FinanceAppTheme.surface,
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                  boxShadow: FinanceAppTheme.softShadow,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: FinanceAppTheme.primaryDark, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FinanceAppTheme.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
