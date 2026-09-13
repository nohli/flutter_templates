enum TemplateGalleryDestination {
  hotelBooking,
  fitness,
  designCourse,
  personalFinance,
  dating,
  languageLearning,
  socialFeed,
  bankingSuperApp,
}

class TemplateGalleryItem {
  const TemplateGalleryItem({required this.title, required this.destination, this.imagePath});

  final String title;
  final TemplateGalleryDestination destination;
  final String? imagePath;

  static const items = <TemplateGalleryItem>[
    TemplateGalleryItem(
      title: 'Hotel Booking',
      destination: TemplateGalleryDestination.hotelBooking,
      imagePath: 'assets/hotel/hotel_booking.png',
    ),
    TemplateGalleryItem(
      title: 'Fitness App',
      destination: TemplateGalleryDestination.fitness,
      imagePath: 'assets/fitness_app/fitness_app.png',
    ),
    TemplateGalleryItem(
      title: 'Design Course',
      destination: TemplateGalleryDestination.designCourse,
      imagePath: 'assets/design_course/design_course.png',
    ),
    TemplateGalleryItem(title: 'Personal Finance', destination: TemplateGalleryDestination.personalFinance),
    TemplateGalleryItem(title: 'Dating & Social', destination: TemplateGalleryDestination.dating),
    TemplateGalleryItem(title: 'Language Learning', destination: TemplateGalleryDestination.languageLearning),
    TemplateGalleryItem(title: 'Public Social Feed', destination: TemplateGalleryDestination.socialFeed),
    TemplateGalleryItem(title: 'Banking Super-App', destination: TemplateGalleryDestination.bankingSuperApp),
  ];
}
