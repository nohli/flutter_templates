class HotelListData {
  const HotelListData({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.distanceKm,
    required this.reviews,
    required this.rating,
    required this.nightlyPrice,
    required this.amenities,
    required this.accommodationType,
  });

  final String id;
  final String imagePath;
  final String title;
  final String location;
  final double distanceKm;
  final int reviews;
  final double rating;
  final int nightlyPrice;
  final List<String> amenities;
  final String accommodationType;

  static const samples = <HotelListData>[
    HotelListData(
      id: 'grand-royal-hotel-1',
      imagePath: 'assets/hotel/hotel_1.png',
      title: 'Grand Royal Hotel',
      location: 'Wembley, London',
      distanceKm: 2.0,
      reviews: 80,
      rating: 4.4,
      nightlyPrice: 180,
      amenities: <String>['Free Breakfast', 'Free wifi', 'Pool'],
      accommodationType: 'Hotel',
    ),
    HotelListData(
      id: 'queen-hotel-1',
      imagePath: 'assets/hotel/hotel_2.png',
      title: 'Queen Hotel',
      location: 'Wembley, London',
      distanceKm: 4.0,
      reviews: 74,
      rating: 4.5,
      nightlyPrice: 200,
      amenities: <String>['Free Parking', 'Pet Friendly'],
      accommodationType: 'Apartment',
    ),
    HotelListData(
      id: 'grand-royal-hotel-2',
      imagePath: 'assets/hotel/hotel_3.png',
      title: 'Grand Royal Hotel',
      location: 'Wembley, London',
      distanceKm: 3.0,
      reviews: 62,
      rating: 4.0,
      nightlyPrice: 60,
      amenities: <String>['Free Breakfast', 'Free Parking'],
      accommodationType: 'Home',
    ),
    HotelListData(
      id: 'queen-hotel-2',
      imagePath: 'assets/hotel/hotel_4.png',
      title: 'Queen Hotel',
      location: 'Wembley, London',
      distanceKm: 7.0,
      reviews: 90,
      rating: 4.4,
      nightlyPrice: 170,
      amenities: <String>['Pool', 'Pet Friendly', 'Free wifi'],
      accommodationType: 'Villa',
    ),
    HotelListData(
      id: 'grand-royal-hotel-3',
      imagePath: 'assets/hotel/hotel_5.png',
      title: 'Grand Royal Hotel',
      location: 'Wembley, London',
      distanceKm: 2.0,
      reviews: 240,
      rating: 4.5,
      nightlyPrice: 200,
      amenities: <String>['Free Breakfast', 'Pool', 'Free wifi'],
      accommodationType: 'Resort',
    ),
  ];
}
