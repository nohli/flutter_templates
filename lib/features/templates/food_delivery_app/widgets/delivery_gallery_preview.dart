import 'package:flutter/material.dart';

import '../../shared/template_gallery_preview.dart';
import '../food_delivery_app_theme.dart';
import '../models/meal.dart';
import 'meal_art.dart';

class DeliveryGalleryPreview extends StatelessWidget {
  const DeliveryGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateGalleryPreviewFrame(
      background: FoodDeliveryAppTheme.background,
      accent: FoodDeliveryAppTheme.primary,
      primary: _DeliveryDiscoverPreview(),
      secondary: _DeliveryOrderPreview(),
    );
  }
}

class _DeliveryDiscoverPreview extends StatelessWidget {
  const _DeliveryDiscoverPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text('Savor', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
              ),
              Icon(Icons.location_on_rounded, size: 8, color: FoodDeliveryAppTheme.primary),
            ],
          ),
          SizedBox(height: 5),
          Text('Good food,', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          Text('right on time.', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          SizedBox(height: 5),
          _PreviewSearch(),
          SizedBox(height: 6),
          Expanded(child: _PreviewMeal()),
        ],
      ),
    );
  }
}

class _DeliveryOrderPreview extends StatelessWidget {
  const _DeliveryOrderPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Your order', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          SizedBox(height: 3),
          Text('Arrives in 12 min', style: TextStyle(fontSize: 5, color: FoodDeliveryAppTheme.mutedInk)),
          SizedBox(height: 7),
          Expanded(child: _RouteMap()),
          SizedBox(height: 7),
          _CourierCard(),
        ],
      ),
    );
  }
}

class _PreviewSearch extends StatelessWidget {
  const _PreviewSearch();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(color: Color(0xFFFFF4E3), borderRadius: BorderRadius.all(Radius.circular(8))),
      child: const Row(
        children: <Widget>[
          Icon(Icons.search_rounded, size: 7, color: FoodDeliveryAppTheme.green),
          SizedBox(width: 3),
          Expanded(
            child: Text(
              'Search meals',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 4.5, color: FoodDeliveryAppTheme.mutedInk),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewMeal extends StatelessWidget {
  const _PreviewMeal();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0x1425352D), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: MealArt(kind: MealKind.bowl, compact: true)),
            SizedBox(height: 3),
            Text('Sunset bowl', style: TextStyle(fontSize: 5, fontWeight: FontWeight.w800)),
            SizedBox(height: 1),
            Text('Fresh Fork · 18 min', style: TextStyle(fontSize: 3.8, color: FoodDeliveryAppTheme.mutedInk)),
          ],
        ),
      ),
    );
  }
}

class _RouteMap extends StatelessWidget {
  const _RouteMap();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: FoodDeliveryAppTheme.mint,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Stack(
        children: <Widget>[
          const Positioned(left: 10, top: 18, child: _MapStreet(width: 64, angle: -0.3)),
          const Positioned(left: 23, top: 42, child: _MapStreet(width: 50, angle: 0.45)),
          const Positioned(
            left: 16,
            bottom: 16,
            child: Icon(Icons.home_rounded, size: 13, color: FoodDeliveryAppTheme.green),
          ),
          const Positioned(
            right: 15,
            top: 16,
            child: Icon(Icons.storefront_rounded, size: 13, color: FoodDeliveryAppTheme.primary),
          ),
          Center(
            child: Container(
              width: 42,
              height: 3,
              decoration: const BoxDecoration(
                color: FoodDeliveryAppTheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
          const Center(child: Icon(Icons.delivery_dining_rounded, size: 18, color: FoodDeliveryAppTheme.deepOrange)),
        ],
      ),
    );
  }
}

class _MapStreet extends StatelessWidget {
  const _MapStreet({required this.width, required this.angle});

  final double width;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(width: width, height: 2, color: Colors.white.withValues(alpha: 0.8)),
    );
  }
}

class _CourierCard extends StatelessWidget {
  const _CourierCard();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        CircleAvatar(
          radius: 8,
          backgroundColor: FoodDeliveryAppTheme.peach,
          child: Icon(Icons.person_rounded, size: 9, color: FoodDeliveryAppTheme.deepOrange),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Kai is nearby', style: TextStyle(fontSize: 5.5, fontWeight: FontWeight.w800)),
              SizedBox(height: 2),
              PreviewLine(width: 43, height: 2, color: FoodDeliveryAppTheme.divider),
            ],
          ),
        ),
        PreviewIconTile(
          icon: Icons.chat_bubble_outline_rounded,
          background: FoodDeliveryAppTheme.peach,
          foreground: FoodDeliveryAppTheme.primary,
          size: 17,
        ),
      ],
    );
  }
}
