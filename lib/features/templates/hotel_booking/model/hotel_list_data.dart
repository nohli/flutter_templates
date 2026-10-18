import '../../../../l10n/localizations.dart';
import 'hotel_filter_settings.dart';

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
  final List<HotelAmenity> amenities;
  final HotelAccommodation accommodationType;

  static List<HotelListData> samples(AppLocalizations l10n) => <HotelListData>[
    HotelListData(
      id: 'grand-royal-hotel-1',
      imagePath: 'assets/hotel/hotel_1.png',
      title: l10n.grandRoyalHotel,
      location: l10n.wembleyLondon,
      distanceKm: 2.0,
      reviews: 80,
      rating: 4.4,
      nightlyPrice: 180,
      amenities: const <HotelAmenity>[HotelAmenity.breakfast, HotelAmenity.wifi, HotelAmenity.pool],
      accommodationType: HotelAccommodation.hotel,
    ),
    HotelListData(
      id: 'queen-hotel-1',
      imagePath: 'assets/hotel/hotel_2.png',
      title: l10n.queenHotel,
      location: l10n.wembleyLondon,
      distanceKm: 4.0,
      reviews: 74,
      rating: 4.5,
      nightlyPrice: 200,
      amenities: const <HotelAmenity>[HotelAmenity.parking, HotelAmenity.pets],
      accommodationType: HotelAccommodation.apartment,
    ),
    HotelListData(
      id: 'grand-royal-hotel-2',
      imagePath: 'assets/hotel/hotel_3.png',
      title: l10n.grandRoyalHotel,
      location: l10n.wembleyLondon,
      distanceKm: 3.0,
      reviews: 62,
      rating: 4.0,
      nightlyPrice: 60,
      amenities: const <HotelAmenity>[HotelAmenity.breakfast, HotelAmenity.parking],
      accommodationType: HotelAccommodation.home,
    ),
    HotelListData(
      id: 'queen-hotel-2',
      imagePath: 'assets/hotel/hotel_4.png',
      title: l10n.queenHotel,
      location: l10n.wembleyLondon,
      distanceKm: 7.0,
      reviews: 90,
      rating: 4.4,
      nightlyPrice: 170,
      amenities: const <HotelAmenity>[HotelAmenity.pool, HotelAmenity.pets, HotelAmenity.wifi],
      accommodationType: HotelAccommodation.villa,
    ),
    HotelListData(
      id: 'grand-royal-hotel-3',
      imagePath: 'assets/hotel/hotel_5.png',
      title: l10n.grandRoyalHotel,
      location: l10n.wembleyLondon,
      distanceKm: 2.0,
      reviews: 240,
      rating: 4.5,
      nightlyPrice: 200,
      amenities: const <HotelAmenity>[HotelAmenity.breakfast, HotelAmenity.pool, HotelAmenity.wifi],
      accommodationType: HotelAccommodation.resort,
    ),
  ];
}
