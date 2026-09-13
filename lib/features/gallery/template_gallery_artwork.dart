import 'package:flutter/material.dart';

import '../templates/dating_app/widgets/dating_gallery_preview.dart';
import '../templates/banking_super_app/widgets/banking_gallery_preview.dart';
import '../templates/finance_app/widgets/finance_gallery_preview.dart';
import '../templates/language_learning/widgets/language_learning_gallery_preview.dart';
import '../templates/social_feed/widgets/social_feed_gallery_preview.dart';
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
      TemplateGalleryDestination.dating => DatingGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.languageLearning => LanguageLearningGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.socialFeed => SocialFeedGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.bankingSuperApp => BankingGalleryPreview(brightness: brightness),
      TemplateGalleryDestination.hotelBooking ||
      TemplateGalleryDestination.fitness ||
      TemplateGalleryDestination.designCourse => const SizedBox.shrink(),
    };
  }
}
