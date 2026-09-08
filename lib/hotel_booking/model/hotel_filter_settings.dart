class HotelFilterSettings {
  const HotelFilterSettings({
    this.minimumPrice = 0,
    this.maximumPrice = 1000,
    this.maximumDistanceKm = 10,
    this.amenities = const <String>[],
    this.accommodationTypes = const <String>[],
  });

  final double minimumPrice;
  final double maximumPrice;
  final double maximumDistanceKm;
  final List<String> amenities;
  final List<String> accommodationTypes;
}
