import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../motion_preferences.dart';
import 'calendar_popup_view.dart';
import 'filters_screen.dart';
import 'hotel_app_theme.dart';
import 'hotel_list_view.dart';
import 'model/hotel_filter_settings.dart';
import 'model/hotel_list_data.dart';

class HotelHomeScreen extends StatefulWidget {
  const HotelHomeScreen({super.key});

  @override
  State<HotelHomeScreen> createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _favoriteHotelImages = <String>{};

  var _filterSettings = const HotelFilterSettings();
  var _query = '';

  var _startDate = DateTime.now();
  var _endDate = DateTime.now().add(const Duration(days: 5));

  late final AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startEntranceAnimation(context, _animationController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hotels = _visibleHotels;
    final theme = HotelAppTheme.build();
    final colors = theme.colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final stackFilterBar = textScale >= 1.5;

    return Theme(
      data: theme,
      child: Material(
        color: colors.surface,
        child: Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: <Widget>[
                  _buildAppBar(colors),
                  Expanded(
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                              return Column(children: <Widget>[_buildSearchBar(colors), _buildDateAndGuests(colors)]);
                            }, childCount: 1),
                          ),
                          if (stackFilterBar)
                            SliverToBoxAdapter(child: _buildFilterBar(colors))
                          else
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: _PinnedHeaderDelegate(_buildFilterBar(colors), extent: 60),
                            ),
                        ];
                      },
                      body: Container(
                        color: colors.surface,
                        child: ListView.builder(
                          itemCount: hotels.length,
                          padding: const EdgeInsets.only(top: 8),
                          itemBuilder: (BuildContext context, int index) {
                            final count = hotels.length > 10 ? 10 : hotels.length;
                            final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
                              ),
                            );
                            return HotelListView(
                              hotelData: hotels[index],
                              isFavorite: _favoriteHotelImages.contains(hotels[index].imagePath),
                              onFavoriteChanged: () {
                                setState(() {
                                  final imagePath = hotels[index].imagePath;
                                  final isFavorite = _favoriteHotelImages.contains(imagePath);

                                  if (isFavorite) {
                                    _favoriteHotelImages.remove(imagePath);
                                  } else {
                                    _favoriteHotelImages.add(imagePath);
                                  }
                                });
                              },
                              animation: animation,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndGuests(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: colors.primary.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              onTap: () {
                FocusScope.of(context).unfocus();
                _showDateDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Choose date',
                      style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16, color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('dd, MMM').format(_startDate)} - ${DateFormat('dd, MMM').format(_endDate)}',
                      style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(width: 1, height: 42, color: colors.outlineVariant),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sample guests',
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16, color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 8),
                  const Text('1 room · 2 adults', style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: colors.shadow.withValues(alpha: 0.2), offset: const Offset(0, 2), blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String value) {
                      setState(() {
                        _query = value.trim().toLowerCase();
                      });
                    },
                    style: const TextStyle(fontSize: 18),
                    cursorColor: colors.secondary,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Search sample hotels'),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: const BorderRadius.all(Radius.circular(38.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: colors.shadow.withValues(alpha: 0.4), offset: const Offset(0, 2), blurRadius: 8.0),
              ],
            ),
            child: IconButton(
              tooltip: 'Search sample hotels',
              constraints: const BoxConstraints.tightFor(width: 52, height: 52),
              onPressed: () => FocusScope.of(context).unfocus(),
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ColorScheme colors) {
    final stackActions = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final hotelCount = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '${_visibleHotels.length} sample hotels',
        style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 16),
      ),
    );
    final filterButton = TextButton(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      onPressed: _openFilters,
      child: Flex(
        direction: stackActions ? Axis.vertical : Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Filter', style: TextStyle(color: colors.onSurface)),
          Padding(
            padding: EdgeInsets.only(left: stackActions ? 0 : 8, top: stackActions ? 8 : 0),
            child: Icon(Icons.sort, color: colors.primary),
          ),
        ],
      ),
    );
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: <BoxShadow>[
                BoxShadow(color: colors.shadow.withValues(alpha: 0.2), offset: const Offset(0, -2), blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: colors.surface,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Flex(
              direction: stackActions ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: stackActions ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
              children: <Widget>[
                if (stackActions) hotelCount else Expanded(child: hotelCount),
                if (stackActions) Align(alignment: Alignment.centerRight, child: filterButton) else filterButton,
              ],
            ),
          ),
        ),
        Positioned(top: 0, left: 0, right: 0, child: Divider(height: 1, color: colors.outlineVariant)),
      ],
    );
  }

  void _showDateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => MediaQuery.withNoTextScaling(
        child: CalendarPopupView(
          minimumDate: DateTime.now(),
          initialEndDate: _endDate,
          initialStartDate: _startDate,
          onApplyClick: (DateTime startData, DateTime endData) {
            if (mounted) {
              setState(() {
                _startDate = startData;
                _endDate = endData;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colors) {
    final stackTitle = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final backButton = IconButton(
      tooltip: 'Back',
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
    );
    const trailingIcons = SizedBox(
      width: 96,
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8), child: Icon(Icons.favorite_border)),
          Padding(padding: EdgeInsets.all(8), child: FaIcon(FontAwesomeIcons.locationDot)),
        ],
      ),
    );
    const title = Text('Explore', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22));
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.shadow.withValues(alpha: 0.2), offset: const Offset(0, 2), blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Material(
          child: stackTitle
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 48, height: 48, child: backButton),
                        trailingIcons,
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Center(child: title),
                    ),
                  ],
                )
              : SizedBox(
                  height: AppBar().preferredSize.height,
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        width: AppBar().preferredSize.height + 40,
                        child: backButton,
                      ),
                      const Expanded(child: Center(child: title)),
                      trailingIcons,
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  List<HotelListData> get _visibleHotels {
    return HotelListData.samples
        .where((HotelListData hotel) {
          final searchableText = '${hotel.title} ${hotel.location}'.toLowerCase();
          final matchesQuery = _query.isEmpty || searchableText.contains(_query);
          final matchesMinimumPrice = hotel.nightlyPrice >= _filterSettings.minimumPrice;
          final matchesMaximumPrice = hotel.nightlyPrice <= _filterSettings.maximumPrice;
          final matchesDistance = hotel.distanceKm <= _filterSettings.maximumDistanceKm;
          final matchesAmenities = _filterSettings.amenities.every(hotel.amenities.contains);
          final matchesType =
              _filterSettings.accommodationTypes.isEmpty ||
              _filterSettings.accommodationTypes.contains(hotel.accommodationType);

          return matchesQuery &&
              matchesMinimumPrice &&
              matchesMaximumPrice &&
              matchesDistance &&
              matchesAmenities &&
              matchesType;
        })
        .toList(growable: false);
  }

  Future<void> _openFilters() async {
    FocusScope.of(context).unfocus();
    final settings = await Navigator.push<HotelFilterSettings>(
      context,
      MaterialPageRoute<HotelFilterSettings>(
        builder: (BuildContext context) =>
            MediaQuery.withNoTextScaling(child: FiltersScreen(initialSettings: _filterSettings)),
        fullscreenDialog: true,
      ),
    );
    if (!mounted || settings == null) return;

    setState(() {
      _filterSettings = settings;
    });
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PinnedHeaderDelegate(this.content, {required this.extent});
  final Widget content;
  final double extent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return content;
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is! _PinnedHeaderDelegate || oldDelegate.content != content;
  }
}
