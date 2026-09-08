class PopularFilterListData {
  PopularFilterListData({this.label = '', this.isSelected = false});

  final String label;
  bool isSelected;

  static final List<PopularFilterListData> popularFilters = <PopularFilterListData>[
    PopularFilterListData(label: 'Free Breakfast'),
    PopularFilterListData(label: 'Free Parking'),
    PopularFilterListData(label: 'Pool', isSelected: true),
    PopularFilterListData(label: 'Pet Friendly'),
    PopularFilterListData(label: 'Free wifi'),
  ];

  static final List<PopularFilterListData> accommodationTypes = <PopularFilterListData>[
    PopularFilterListData(label: 'All'),
    PopularFilterListData(label: 'Apartment'),
    PopularFilterListData(label: 'Home', isSelected: true),
    PopularFilterListData(label: 'Villa'),
    PopularFilterListData(label: 'Hotel'),
    PopularFilterListData(label: 'Resort'),
  ];
}
