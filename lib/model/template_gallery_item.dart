enum TemplateGalleryDestination { hotelBooking, fitness, designCourse }

class TemplateGalleryItem {
  const TemplateGalleryItem({required this.title, required this.destination, required this.imagePath});

  final String title;
  final TemplateGalleryDestination destination;
  final String imagePath;

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
  ];
}
