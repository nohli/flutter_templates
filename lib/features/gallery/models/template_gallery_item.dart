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
  String galleryPreviewPath({required bool dark}) {
    final appearanceSuffix = dark ? '-dark' : '';
    return 'assets/gallery/$assetName$appearanceSuffix.png';
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
  const TemplateGalleryItem({required this.title, required this.destination});

  final String title;
  final TemplateGalleryDestination destination;

  static const items = <TemplateGalleryItem>[
    TemplateGalleryItem(title: 'Hotel Booking', destination: TemplateGalleryDestination.hotelBooking),
    TemplateGalleryItem(title: 'Fitness App', destination: TemplateGalleryDestination.fitness),
    TemplateGalleryItem(title: 'Design Course', destination: TemplateGalleryDestination.designCourse),
    TemplateGalleryItem(title: 'Personal Finance', destination: TemplateGalleryDestination.personalFinance),
    TemplateGalleryItem(title: 'Dating & Social', destination: TemplateGalleryDestination.dating),
    TemplateGalleryItem(title: 'Language Learning', destination: TemplateGalleryDestination.languageLearning),
    TemplateGalleryItem(title: 'Public Social Feed', destination: TemplateGalleryDestination.socialFeed),
    TemplateGalleryItem(title: 'Banking Super-App', destination: TemplateGalleryDestination.bankingSuperApp),
    TemplateGalleryItem(title: 'Channel Messenger', destination: TemplateGalleryDestination.channelMessenger),
    TemplateGalleryItem(title: 'Private Messenger', destination: TemplateGalleryDestination.privateMessenger),
  ];
}
