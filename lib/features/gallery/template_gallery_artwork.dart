import 'package:flutter/material.dart';

import '../templates/finance_app/widgets/finance_gallery_preview.dart';
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
      TemplateGalleryDestination.hotelBooking ||
      TemplateGalleryDestination.fitness ||
      TemplateGalleryDestination.designCourse => const SizedBox.shrink(),
    };
  }
}
