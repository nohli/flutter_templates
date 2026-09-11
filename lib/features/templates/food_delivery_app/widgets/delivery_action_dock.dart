import 'package:flutter/material.dart';

import '../models/delivery_section.dart';

class DeliveryActionDock extends StatelessWidget {
  const DeliveryActionDock({
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
    final colors = Theme.of(context).colorScheme;
    final compactLabels = MediaQuery.textScalerOf(context).scale(1) >= 1.8;

    return Material(
      color: colors.surface,
      elevation: 10,
      shadowColor: Colors.black26,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: SizedBox(
          height: compactLabels ? 56 : 62,
          child: Row(
            children: <Widget>[
              _DockIconAction(
                label: 'Discover',
                icon: Icons.restaurant_menu_rounded,
                isSelected: selectedSection == DeliverySection.discover,
                hideLabel: compactLabels,
                onPressed: () => onSelected(DeliverySection.discover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OrderAction(
                  isSelected: selectedSection == DeliverySection.order,
                  onPressed: () => onSelected(DeliverySection.order),
                ),
              ),
              const SizedBox(width: 10),
              _BasketAction(
                itemCount: itemCount,
                isSelected: selectedSection == DeliverySection.basket,
                hideLabel: compactLabels,
                onPressed: () => onSelected(DeliverySection.basket),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockIconAction extends StatelessWidget {
  const _DockIconAction({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.hideLabel,
    required this.onPressed,
    this.badgeCount = 0,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool hideLabel;
  final VoidCallback onPressed;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minWidth: 58, minHeight: 54),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected ? colors.secondaryContainer : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(18)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Badge(
                  isLabelVisible: badgeCount > 0,
                  label: Text('$badgeCount'),
                  child: Icon(icon, color: isSelected ? colors.primary : colors.onSurfaceVariant, size: 22),
                ),
                if (!hideLabel) ...<Widget>[
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(color: colors.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderAction extends StatelessWidget {
  const _OrderAction({required this.isSelected, required this.onPressed});

  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Order',
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: isSelected ? colors.secondary : colors.primary,
          foregroundColor: isSelected ? colors.onSecondary : colors.onPrimary,
          shape: const StadiumBorder(),
        ),
        icon: Icon(isSelected ? Icons.route_rounded : Icons.delivery_dining_rounded),
        label: FittedBox(child: Text(isSelected ? 'Track order' : 'Order status')),
      ),
    );
  }
}

class _BasketAction extends StatelessWidget {
  const _BasketAction({
    required this.itemCount,
    required this.isSelected,
    required this.hideLabel,
    required this.onPressed,
  });

  final int itemCount;
  final bool isSelected;
  final bool hideLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _DockIconAction(
      label: itemCount == 0 ? 'Basket' : 'Basket, $itemCount ${itemCount == 1 ? 'item' : 'items'}',
      icon: itemCount == 0 ? Icons.shopping_basket_outlined : Icons.shopping_basket_rounded,
      isSelected: isSelected,
      hideLabel: hideLabel,
      onPressed: onPressed,
      badgeCount: itemCount,
    );
  }
}
