import '../../../../l10n/localizations.dart';

enum HotelAmenity {
  breakfast,
  parking,
  pool,
  pets,
  wifi;

  String label(AppLocalizations l10n) => switch (this) {
    HotelAmenity.breakfast => l10n.freeBreakfast,
    HotelAmenity.parking => l10n.freeParking,
    HotelAmenity.pool => l10n.pool,
    HotelAmenity.pets => l10n.petFriendly,
    HotelAmenity.wifi => l10n.freeWifi,
  };
}

enum HotelAccommodation {
  all,
  apartment,
  home,
  villa,
  hotel,
  resort;

  String label(AppLocalizations l10n) => switch (this) {
    HotelAccommodation.all => l10n.all,
    HotelAccommodation.apartment => l10n.apartment,
    HotelAccommodation.home => l10n.home,
    HotelAccommodation.villa => l10n.villa,
    HotelAccommodation.hotel => l10n.hotel,
    HotelAccommodation.resort => l10n.resort,
  };
}

class HotelFilterSettings {
  const HotelFilterSettings({
    this.minimumPrice = 0,
    this.maximumPrice = 1000,
    this.maximumDistanceKm = 10,
    this.amenities = const <HotelAmenity>[],
    this.accommodationTypes = const <HotelAccommodation>[],
  });

  final double minimumPrice;
  final double maximumPrice;
  final double maximumDistanceKm;
  final List<HotelAmenity> amenities;
  final List<HotelAccommodation> accommodationTypes;
}
