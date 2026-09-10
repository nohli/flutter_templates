import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';

class DeliveryGalleryPreview extends StatelessWidget {
  const DeliveryGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(width: 214, height: 143, child: _DeliveryPreviewCanvas()),
    );
  }
}

class _DeliveryPreviewCanvas extends StatelessWidget {
  const _DeliveryPreviewCanvas();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: FoodDeliveryAppTheme.background,
      child: Padding(
        padding: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('SAVOR', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
                ),
                CircleAvatar(
                  radius: 8,
                  backgroundColor: FoodDeliveryAppTheme.peach,
                  child: Icon(Icons.location_on_rounded, size: 9, color: FoodDeliveryAppTheme.deepOrange),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Good food, right on time.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _PreviewMeal(color: FoodDeliveryAppTheme.yellow, icon: Icons.ramen_dining_rounded),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _PreviewMeal(color: FoodDeliveryAppTheme.peach, icon: Icons.local_pizza_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewMeal extends StatelessWidget {
  const _PreviewMeal({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: FoodDeliveryAppTheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(child: Icon(icon, size: 22, color: FoodDeliveryAppTheme.deepOrange)),
            ),
          ),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: 46, child: Divider(height: 3, thickness: 3, color: FoodDeliveryAppTheme.ink)),
          ),
        ],
      ),
    );
  }
}
