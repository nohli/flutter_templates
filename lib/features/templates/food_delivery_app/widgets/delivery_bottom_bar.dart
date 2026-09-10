import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';
import '../models/delivery_section.dart';

class DeliveryBottomBar extends StatelessWidget {
  const DeliveryBottomBar({
    required this.selectedSection,
    required this.itemCount,
    required this.onSelected,
    super.key,
  });

  final DeliverySection selectedSection;
  final int itemCount;
  final ValueChanged<DeliverySection> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return ColoredBox(
      color: FoodDeliveryAppTheme.background,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Material(
          color: FoodDeliveryAppTheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: usesLargeText ? _largeTextNavigation() : _standardNavigation(),
        ),
      ),
    );
  }

  Widget _standardNavigation() {
    return NavigationBar(
      height: 68,
      selectedIndex: selectedSection.index,
      backgroundColor: Colors.transparent,
      indicatorColor: FoodDeliveryAppTheme.peach,
      onDestinationSelected: (int index) => onSelected(DeliverySection.values[index]),
      destinations: <NavigationDestination>[
        const NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore_rounded),
          label: 'Discover',
        ),
        const NavigationDestination(
          icon: Icon(Icons.delivery_dining_outlined),
          selectedIcon: Icon(Icons.delivery_dining_rounded),
          label: 'Order',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: itemCount > 0,
            label: Text('$itemCount'),
            child: const Icon(Icons.shopping_basket_outlined),
          ),
          selectedIcon: Badge(
            isLabelVisible: itemCount > 0,
            label: Text('$itemCount'),
            child: const Icon(Icons.shopping_basket_rounded),
          ),
          label: 'Basket',
        ),
      ],
    );
  }

  Widget _largeTextNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          for (final section in DeliverySection.values) ...<Widget>[
            _LargeDestination(
              label: _labelFor(section),
              icon: _iconFor(section),
              isSelected: selectedSection == section,
              onPressed: () => onSelected(section),
            ),
            if (section != DeliverySection.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _labelFor(DeliverySection section) => switch (section) {
    DeliverySection.discover => 'Discover',
    DeliverySection.order => 'Order',
    DeliverySection.basket => itemCount == 0 ? 'Basket' : 'Basket · $itemCount',
  };

  IconData _iconFor(DeliverySection section) => switch (section) {
    DeliverySection.discover => Icons.explore_rounded,
    DeliverySection.order => Icons.delivery_dining_rounded,
    DeliverySection.basket => Icons.shopping_basket_rounded,
  };
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
