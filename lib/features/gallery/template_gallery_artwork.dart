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

    return switch (item.destination) {
      TemplateGalleryDestination.personalFinance => const FinanceGalleryPreview(),
      TemplateGalleryDestination.storefront => const StorefrontGalleryPreview(),
      TemplateGalleryDestination.planner => const PlannerGalleryPreview(),
      TemplateGalleryDestination.aiAssistant => const AssistantGalleryPreview(),
      TemplateGalleryDestination.foodDelivery => const DeliveryGalleryPreview(),
      TemplateGalleryDestination.podcast => const PodcastGalleryPreview(),
      TemplateGalleryDestination.social => const SocialGalleryPreview(),
      TemplateGalleryDestination.travel => const TravelGalleryPreview(),
      TemplateGalleryDestination.dating => const DatingGalleryPreview(),
      TemplateGalleryDestination.hotelBooking ||
      TemplateGalleryDestination.fitness ||
      TemplateGalleryDestination.designCourse => const SizedBox.shrink(),
    };
  }
}
