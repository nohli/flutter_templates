import 'package:flutter/material.dart';

import '../models/storefront_section.dart';
import '../storefront_app_theme.dart';

class StorefrontBottomBar extends StatelessWidget {
  const StorefrontBottomBar({
    required this.selectedSection,
    required this.bagItemCount,
    required this.onSelected,
    super.key,
  });

  final StorefrontSection selectedSection;
  final int bagItemCount;
  final ValueChanged<StorefrontSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ColoredBox(
      color: StorefrontAppTheme.background,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: StorefrontAppTheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: usesLargeText ? _buildLargeTextNavigation() : _buildStandardNavigation(),
        ),
      ),
    );
  }

  Widget _buildStandardNavigation() {
    return NavigationBar(
      height: 68,
      selectedIndex: selectedSection.index,
      backgroundColor: Colors.transparent,
      indicatorColor: StorefrontAppTheme.blush,
      onDestinationSelected: (int index) => onSelected(StorefrontSection.values[index]),
      destinations: <NavigationDestination>[
        const NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront_rounded),
          label: 'Shop',
        ),
        const NavigationDestination(
          icon: Icon(Icons.favorite_border_rounded),
          selectedIcon: Icon(Icons.favorite_rounded),
          label: 'Saved',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: bagItemCount > 0,
            label: Text('$bagItemCount'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: bagItemCount > 0,
            label: Text('$bagItemCount'),
            child: const Icon(Icons.shopping_bag_rounded),
          ),
          label: 'Bag',
        ),
      ],
    );
  }

  Widget _buildLargeTextNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          _LargeDestination(
            label: 'Shop',
            icon: Icons.storefront_rounded,
            isSelected: selectedSection == StorefrontSection.shop,
            onPressed: () => onSelected(StorefrontSection.shop),
          ),
          const SizedBox(width: 8),
          _LargeDestination(
            label: 'Saved',
            icon: Icons.favorite_rounded,
            isSelected: selectedSection == StorefrontSection.saved,
            onPressed: () => onSelected(StorefrontSection.saved),
          ),
          const SizedBox(width: 8),
          Badge(
            isLabelVisible: bagItemCount > 0,
            label: Text('$bagItemCount'),
            child: _LargeDestination(
              label: 'Bag',
              icon: Icons.shopping_bag_rounded,
              isSelected: selectedSection == StorefrontSection.bag,
              onPressed: () => onSelected(StorefrontSection.bag),
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeDestination extends StatelessWidget {
  const _LargeDestination({required this.label, required this.icon, required this.isSelected, required this.onPressed});

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon);
    final labelWidget = Text(label);

    return isSelected
        ? FilledButton.tonalIcon(onPressed: onPressed, icon: iconWidget, label: labelWidget)
        : TextButton.icon(onPressed: onPressed, icon: iconWidget, label: labelWidget);
  }
}
