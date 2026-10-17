import '../../../l10n/localizations.dart';

enum TemplateGalleryDestination {
  hotelBooking,
  fitness,
  designCourse,
  personalFinance,
  dating,
  languageLearning,
  socialFeed,
  bankingSuperApp,
  channelMessenger,
  privateMessenger,
}

extension TemplateGalleryDestinationArtwork on TemplateGalleryDestination {
  String galleryPreviewPath(AppLocalizations l10n, {required bool dark}) {
    final appearanceSuffix = dark ? '-dark' : '';
    return 'assets/gallery/${l10n.localeName}/$assetName$appearanceSuffix.png';
  }

  String get assetName => switch (this) {
    TemplateGalleryDestination.hotelBooking => 'hotel-booking-screen',
    TemplateGalleryDestination.fitness => 'fitness-screen',
    TemplateGalleryDestination.designCourse => 'design-course-screen',
    TemplateGalleryDestination.personalFinance => 'personal-finance-screen',
    TemplateGalleryDestination.dating => 'dating-screen',
    TemplateGalleryDestination.languageLearning => 'language-learning-screen',
    TemplateGalleryDestination.socialFeed => 'social-feed-screen',
    TemplateGalleryDestination.bankingSuperApp => 'banking-screen',
    TemplateGalleryDestination.channelMessenger => 'channel-messenger-screen',
    TemplateGalleryDestination.privateMessenger => 'private-messenger-screen',
  };
}

class TemplateGalleryItem {
  const TemplateGalleryItem({required this.destination});

  final TemplateGalleryDestination destination;

  String title(AppLocalizations l10n) => switch (destination) {
    TemplateGalleryDestination.hotelBooking => l10n.hotelBooking,
    TemplateGalleryDestination.fitness => l10n.fitnessApp,
    TemplateGalleryDestination.designCourse => l10n.designCourse,
    TemplateGalleryDestination.personalFinance => l10n.personalFinance,
    TemplateGalleryDestination.dating => l10n.datingAndSocial,
    TemplateGalleryDestination.languageLearning => l10n.languageLearning,
    TemplateGalleryDestination.socialFeed => l10n.publicSocialFeed,
    TemplateGalleryDestination.bankingSuperApp => l10n.bankingSuperApp,
    TemplateGalleryDestination.channelMessenger => l10n.channelMessenger,
    TemplateGalleryDestination.privateMessenger => l10n.privateMessenger,
  };

  static const items = <TemplateGalleryItem>[
    TemplateGalleryItem(destination: TemplateGalleryDestination.hotelBooking),
    TemplateGalleryItem(destination: TemplateGalleryDestination.fitness),
    TemplateGalleryItem(destination: TemplateGalleryDestination.designCourse),
    TemplateGalleryItem(destination: TemplateGalleryDestination.personalFinance),
    TemplateGalleryItem(destination: TemplateGalleryDestination.dating),
    TemplateGalleryItem(destination: TemplateGalleryDestination.languageLearning),
    TemplateGalleryItem(destination: TemplateGalleryDestination.socialFeed),
    TemplateGalleryItem(destination: TemplateGalleryDestination.bankingSuperApp),
    TemplateGalleryItem(destination: TemplateGalleryDestination.channelMessenger),
    TemplateGalleryItem(destination: TemplateGalleryDestination.privateMessenger),
  ];
}
