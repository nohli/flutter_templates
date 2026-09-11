import 'package:flutter/material.dart';

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
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: label,
      onTap: () => onTap(label),
      child: ExcludeSemantics(
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: colors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          onPressed: () => onTap(label),
          child: Column(
            children: <Widget>[
              Container(
                width: 54,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border.all(color: colors.outlineVariant),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Text(
                        '0${_actionIndex(label)}',
                        style: TextStyle(color: colors.onSurfaceVariant, fontSize: 7, letterSpacing: 0.4),
                      ),
                    ),
                    Icon(icon, color: colors.primary, size: 21),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _actionIndex(String action) => switch (action) {
    'Send' => 1,
    'Add money' => 2,
    'Request' => 3,
    _ => 4,
  };
}
