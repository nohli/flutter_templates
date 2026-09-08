class HotelListData {
  const HotelListData({
    this.imagePath = '',
    this.title = '',
    this.location = '',
    this.distanceKm = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.nightlyPrice = 180,
    this.amenities = const <String>[],
    this.accommodationType = 'Hotel',
  });

  final String imagePath;
  final String title;
  final String location;
  final double distanceKm;
  final double rating;
  final int reviews;
  final int nightlyPrice;
  final List<String> amenities;
  final String accommodationType;

  static const List<HotelListData> samples = <HotelListData>[
    HotelListData(
      imagePath: 'assets/hotel/hotel_1.png',
      title: 'Grand Royal Hotel',
      location: 'Wembley, London',
      distanceKm: 2.0,
      rating: 4.4,
      amenities: <String>['Free Breakfast', 'Free wifi', 'Pool'],
      accommodationType: 'Hotel',
    ),
    HotelListData(
      imagePath: 'assets/hotel/hotel_2.png',
      title: 'Queen Hotel',
      location: 'Wembley, London',
      distanceKm: 4.0,
      reviews: 74,
      nightlyPrice: 200,
      amenities: <String>['Free Parking', 'Pet Friendly'],
      accommodationType: 'Apartment',
    ),
    HotelListData(
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
      imagePath: 'assets/hotel/hotel_5.png',
      title: 'Grand Royal Hotel',
      location: 'Wembley, London',
      distanceKm: 2.0,
      reviews: 240,
      nightlyPrice: 200,
      amenities: <String>['Free Breakfast', 'Pool', 'Free wifi'],
      accommodationType: 'Resort',
    ),
  ];
}
