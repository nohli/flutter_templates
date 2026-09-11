import 'package:flutter/material.dart';

import '../templates/ai_assistant_app/widgets/assistant_gallery_preview.dart';
import '../templates/dating_app/widgets/dating_gallery_preview.dart';
import '../templates/finance_app/widgets/finance_gallery_preview.dart';
import '../templates/food_delivery_app/widgets/delivery_gallery_preview.dart';
import '../templates/planner_app/widgets/planner_gallery_preview.dart';
import '../templates/podcast_app/widgets/podcast_gallery_preview.dart';
import '../templates/social_app/widgets/social_gallery_preview.dart';
import '../templates/storefront_app/widgets/storefront_gallery_preview.dart';
import '../templates/travel_app/widgets/travel_gallery_preview.dart';
import 'models/template_gallery_item.dart';

class TemplateGalleryArtwork extends StatelessWidget {
  const TemplateGalleryArtwork({required this.item, super.key});

  final TemplateGalleryItem item;

  @override
  Widget build(BuildContext context) {
    if (item.imagePath case final imagePath?) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    }

    final brightness = Theme.of(context).brightness;
    return switch (item.destination) {
      TemplateGalleryDestination.personalFinance => FinanceGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.storefront => StorefrontGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.planner => PlannerGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.aiAssistant => const AssistantGalleryPreview(),
      TemplateGalleryDestination.foodDelivery => DeliveryGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.podcast => PodcastGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.social => SocialGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.travel => const TravelGalleryPreview(),
      TemplateGalleryDestination.dating => const DatingGalleryPreview(),
      TemplateGalleryDestination.hotelBooking ||
      TemplateGalleryDestination.fitness ||
      TemplateGalleryDestination.designCourse => const SizedBox.shrink(),
    };
  }
}
