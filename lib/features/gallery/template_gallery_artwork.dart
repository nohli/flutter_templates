import 'package:flutter/material.dart';

import '../templates/finance_app/widgets/finance_gallery_preview.dart';
import '../templates/food_delivery_app/widgets/delivery_gallery_preview.dart';
import '../templates/messenger_app/widgets/messenger_gallery_preview.dart';
import '../templates/planner_app/widgets/planner_gallery_preview.dart';
import '../templates/podcast_app/widgets/podcast_gallery_preview.dart';
import '../templates/smart_home_app/widgets/smart_home_gallery_preview.dart';
import '../templates/storefront_app/widgets/storefront_gallery_preview.dart';
import 'models/template_gallery_item.dart';

class TemplateGalleryArtwork extends StatelessWidget {
  const TemplateGalleryArtwork({required this.item, super.key});

  final TemplateGalleryItem item;

  @override
  Widget build(BuildContext context) {
    if (item.imagePath case final imagePath?) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    }

    return switch (item.destination) {
      TemplateGalleryDestination.personalFinance => const FinanceGalleryPreview(),
      TemplateGalleryDestination.storefront => const StorefrontGalleryPreview(),
      TemplateGalleryDestination.planner => const PlannerGalleryPreview(),
      TemplateGalleryDestination.messenger => const MessengerGalleryPreview(),
      TemplateGalleryDestination.foodDelivery => const DeliveryGalleryPreview(),
      TemplateGalleryDestination.podcast => const PodcastGalleryPreview(),
      TemplateGalleryDestination.smartHome => const SmartHomeGalleryPreview(),
      TemplateGalleryDestination.hotelBooking ||
      TemplateGalleryDestination.fitness ||
      TemplateGalleryDestination.designCourse => const SizedBox.shrink(),
    };
  }
}
