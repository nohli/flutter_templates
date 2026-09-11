import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';

class DeliveryOrderSection extends StatelessWidget {
  const DeliveryOrderSection({
    required this.isDelivered,
    required this.scrollController,
    required this.onToggle,
    super.key,
  });

  final bool isDelivered;
  final ScrollController scrollController;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('delivery-order'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Your order', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          isDelivered ? 'Delivered. Enjoy every bite.' : 'Mina is heading your way.',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[FoodDeliveryAppTheme.green, Color(0xFF4D8C6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: FoodDeliveryAppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                isDelivered ? Icons.check_circle_rounded : Icons.delivery_dining_rounded,
                color: Colors.white,
                size: 42,
              ),
              const SizedBox(height: 18),
              Text(
                isDelivered ? 'Order delivered' : 'Arriving in 8–12 min',
                style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text('Fresh Fork · order #1048', style: TextStyle(color: Color(0xFFDCEBDF))),
              const SizedBox(height: 20),
              _OrderProgress(isDelivered: isDelivered),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 190,
          decoration: const BoxDecoration(
            color: FoodDeliveryAppTheme.mint,
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          child: Stack(
            children: <Widget>[
              const Positioned(left: 20, top: 40, right: 24, child: Divider(thickness: 5, color: Colors.white)),
              const Positioned(left: 60, top: 100, right: 12, child: Divider(thickness: 4, color: Colors.white)),
              Positioned(
                left: 30,
                bottom: 28,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: colors.surface,
                  child: Icon(
                    isDelivered ? Icons.home_rounded : Icons.restaurant_rounded,
                    color: FoodDeliveryAppTheme.green,
                  ),
                ),
              ),
              Positioned(
                right: 34,
                top: 34,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: colors.primary,
                  child: Icon(
                    isDelivered ? Icons.check_rounded : Icons.delivery_dining_rounded,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Material(
          color: colors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colors.secondaryContainer,
                  child: Text(
                    'MK',
                    style: TextStyle(color: colors.onSecondaryContainer, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Mina K.', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('Your sample courier', style: TextStyle(color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton.outlined(
                  tooltip: 'Contact sample courier',
                  onPressed: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Courier contact is not connected in this template.'))),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: onToggle,
          icon: Icon(isDelivered ? Icons.refresh_rounded : Icons.check_rounded),
          label: Text(isDelivered ? 'Reset sample journey' : 'Mark sample delivered'),
        ),
      ],
    );
  }
}

class _OrderProgress extends StatelessWidget {
  const _OrderProgress({required this.isDelivered});

  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    const labels = <String>['Confirmed', 'Cooking', 'On the way', 'Delivered'];
    final activeStep = isDelivered ? 3 : 2;

    return Row(
      children: <Widget>[
        for (var index = 0; index < labels.length; index++) ...<Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 7,
                  backgroundColor: index <= activeStep ? FoodDeliveryAppTheme.yellow : const Color(0x6688A494),
                ),
                const SizedBox(height: 6),
                Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ],
            ),
          ),
          if (index < labels.length - 1) const Expanded(child: Divider(color: Color(0x99FFFFFF))),
        ],
      ],
    );
  }
}
