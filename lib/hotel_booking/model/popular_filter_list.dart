class PopularFilterListData {
  const PopularFilterListData({required this.label});

  final String label;

  static const popularFilters = <PopularFilterListData>[
    PopularFilterListData(label: 'Free Breakfast'),
    PopularFilterListData(label: 'Free Parking'),
    PopularFilterListData(label: 'Pool'),
    PopularFilterListData(label: 'Pet Friendly'),
    PopularFilterListData(label: 'Free wifi'),
  ];

  static const accommodationTypes = <PopularFilterListData>[
    PopularFilterListData(label: 'All'),
    PopularFilterListData(label: 'Apartment'),
    PopularFilterListData(label: 'Home'),
    PopularFilterListData(label: 'Villa'),
    PopularFilterListData(label: 'Hotel'),
    PopularFilterListData(label: 'Resort'),
  ];
}
