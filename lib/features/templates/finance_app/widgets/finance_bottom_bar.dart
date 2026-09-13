import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../models/finance_section.dart';

class FinanceBottomBar extends StatelessWidget {
  const FinanceBottomBar({required this.selectedSection, required this.onSelected, super.key});

  static const _destinations = <_FinanceDestination>[
    _FinanceDestination(section: FinanceSection.overview, number: '01', label: 'Home', icon: Icons.home_rounded),
    _FinanceDestination(
      section: FinanceSection.activity,
      number: '02',
      label: 'Activity',
      icon: Icons.swap_horiz_rounded,
    ),
    _FinanceDestination(section: FinanceSection.cards, number: '03', label: 'Cards', icon: Icons.credit_card_rounded),
    _FinanceDestination(section: FinanceSection.profile, number: '04', label: 'Profile', icon: Icons.person_rounded),
  ];

  final FinanceSection selectedSection;
  final ValueChanged<FinanceSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final colors = theme.colorScheme;

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: colors.surface,
          elevation: dark ? 0 : 10,
          shadowColor: FinanceAppTheme.ink.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: dark ? FinanceAppTheme.mint.withValues(alpha: 0.24) : colors.outlineVariant),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
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
    return SizedBox(
      height: 68,
      child: Row(
        children: <Widget>[
          for (final destination in _destinations)
            Expanded(
              child: _FinanceDestinationButton(
                destination: destination,
                isSelected: destination.section == selectedSection,
                onPressed: () => onSelected(destination.section),
              ),
            ),
        ],
      ),
    );
  }
}

class _FinanceDestinationButton extends StatelessWidget {
  const _FinanceDestinationButton({required this.destination, required this.isSelected, required this.onPressed});

  final _FinanceDestination destination;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = isSelected
        ? (theme.brightness == Brightness.dark ? FinanceAppTheme.mint : theme.colorScheme.primary)
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: destination.label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedPositioned(
                duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                left: isSelected ? 12 : 30,
                right: isSelected ? 12 : 30,
                top: 0,
                child: AnimatedContainer(
                  duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
                  height: 3,
                  color: isSelected ? activeColor : Colors.transparent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 4, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          destination.number,
                          style: TextStyle(color: activeColor.withValues(alpha: 0.7), fontSize: 8, letterSpacing: 0.7),
                        ),
                        const SizedBox(width: 5),
                        Icon(destination.icon, size: 17, color: activeColor),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.label,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(color: activeColor, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final foreground = isSelected
        ? (dark ? FinanceAppTheme.ink : theme.colorScheme.onPrimary)
        : theme.colorScheme.onSurfaceVariant;
    final background = isSelected ? (dark ? FinanceAppTheme.mint : theme.colorScheme.primary) : Colors.transparent;

    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
      ),
      icon: Icon(destination.icon),
      label: Text(destination.label),
    );
  }
}

class _FinanceDestination {
  const _FinanceDestination({required this.section, required this.number, required this.label, required this.icon});

  final FinanceSection section;
  final String number;
  final String label;
  final IconData icon;
}
