import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../models/finance_section.dart';

class FinanceBottomBar extends StatelessWidget {
  const FinanceBottomBar({required this.selectedSection, required this.onSelected, super.key});

  static const _destinations = <_FinanceDestination>[
    _FinanceDestination(
      section: FinanceSection.overview,
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _FinanceDestination(
      section: FinanceSection.activity,
      label: 'Activity',
      icon: Icons.swap_horiz_rounded,
      selectedIcon: Icons.receipt_long_rounded,
    ),
    _FinanceDestination(
      section: FinanceSection.cards,
      label: 'Cards',
      icon: Icons.credit_card_outlined,
      selectedIcon: Icons.credit_card_rounded,
    ),
    _FinanceDestination(
      section: FinanceSection.profile,
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  final FinanceSection selectedSection;
  final ValueChanged<FinanceSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ColoredBox(
      color: FinanceAppTheme.background,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: FinanceAppTheme.surface,
          elevation: 4,
          shadowColor: const Color(0x24182033),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: usesLargeText ? _buildLargeTextNavigation() : _buildStandardNavigation(),
        ),
      ),
    );
  }

  Widget _buildLargeTextNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: <Widget>[
          for (final destination in _destinations) ...<Widget>[
            _LargeTextDestination(
              destination: destination,
              isSelected: destination.section == selectedSection,
              onPressed: () => onSelected(destination.section),
            ),
            if (destination != _destinations.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildStandardNavigation() {
    return NavigationBar(
      height: 68,
      selectedIndex: selectedSection.index,
      backgroundColor: Colors.transparent,
      indicatorColor: FinanceAppTheme.lavender,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (int index) => onSelected(FinanceSection.values[index]),
      destinations: <NavigationDestination>[
        for (final destination in _destinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: destination.label,
          ),
      ],
    );
  }
}

class _LargeTextDestination extends StatelessWidget {
  const _LargeTextDestination({required this.destination, required this.isSelected, required this.onPressed});

  final _FinanceDestination destination;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(isSelected ? destination.selectedIcon : destination.icon);
    final label = Text(destination.label);

    return isSelected
        ? FilledButton.tonalIcon(onPressed: onPressed, icon: icon, label: label)
        : TextButton.icon(onPressed: onPressed, icon: icon, label: label);
  }
}

class _FinanceDestination {
  const _FinanceDestination({
    required this.section,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final FinanceSection section;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
