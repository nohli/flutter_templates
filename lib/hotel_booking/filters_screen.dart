import 'package:flutter/material.dart';

import 'hotel_app_theme.dart';
import 'model/hotel_filter_settings.dart';
import 'model/popular_filter_list.dart';
import 'range_slider_view.dart';
import 'slider_view.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({this.initialSettings = const HotelFilterSettings(), super.key});

  final HotelFilterSettings initialSettings;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late final List<PopularFilterListData> _popularFilters;
  late final List<PopularFilterListData> _accommodationFilters;

  late RangeValues _values;
  late double _distanceValue;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(widget.initialSettings.minimumPrice, widget.initialSettings.maximumPrice);
    _distanceValue = widget.initialSettings.maximumDistanceKm * 10;
    _popularFilters = PopularFilterListData.popularFilters.map((PopularFilterListData filter) {
      return PopularFilterListData(
        label: filter.label,
        isSelected: widget.initialSettings.amenities.contains(filter.label),
      );
    }).toList();
    _accommodationFilters = PopularFilterListData.accommodationTypes.map((PopularFilterListData filter) {
      final hasSpecificTypes = widget.initialSettings.accommodationTypes.isNotEmpty;
      final isSelected = filter.label == 'All'
          ? !hasSpecificTypes
          : widget.initialSettings.accommodationTypes.contains(filter.label);

      return PopularFilterListData(label: filter.label, isSelected: isSelected);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HotelAppTheme.build();
    final colors = theme.colorScheme;
    return Theme(
      data: theme,
      child: Material(
        color: colors.surface,
        child: Column(
          children: <Widget>[
            _buildAppBar(colors),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildPriceFilter(colors),
                    const Divider(height: 1),
                    _buildPopularFilters(colors),
                    const Divider(height: 1),
                    _buildDistanceFilter(colors),
                    const Divider(height: 1),
                    _buildAccommodationFilters(colors),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  onPressed: () {
                    final amenities = _popularFilters
                        .where((PopularFilterListData filter) => filter.isSelected)
                        .map((PopularFilterListData filter) => filter.label)
                        .toList(growable: false);
                    final types = _accommodationFilters
                        .skip(1)
                        .where((PopularFilterListData filter) => filter.isSelected)
                        .map((PopularFilterListData filter) => filter.label)
                        .toList(growable: false);
                    final hasEveryType = types.length == _accommodationFilters.length - 1;
                    final settings = HotelFilterSettings(
                      minimumPrice: _values.start,
                      maximumPrice: _values.end,
                      maximumDistanceKm: _distanceValue / 10,
                      amenities: amenities,
                      accommodationTypes: hasEveryType ? const <String>[] : types,
                    );

                    Navigator.pop(context, settings);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccommodationFilters(ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Type of Accommodation',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(children: _buildAccommodationFilterRows()),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  List<Widget> _buildAccommodationFilterRows() {
    final rows = <Widget>[];
    for (var i = 0; i < _accommodationFilters.length; i++) {
      final PopularFilterListData filter = _accommodationFilters[i];
      void toggleAccommodation() {
        if (mounted) {
          setState(() {
            _toggleAccommodation(i);
          });
        }
      }

      rows.add(
        Semantics(
          label: filter.label,
          toggled: filter.isSelected,
          onTap: toggleAccommodation,
          child: ExcludeSemantics(
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(filter.label),
              onChanged: (_) => toggleAccommodation(),
              value: filter.isSelected,
            ),
          ),
        ),
      );
      if (i == 0) {
        rows.add(const Divider(height: 1));
      }
    }
    return rows;
  }

  void _toggleAccommodation(int index) {
    if (index == 0) {
      for (final PopularFilterListData data in _accommodationFilters) {
        data.isSelected = false;
      }
      _accommodationFilters[0].isSelected = true;
    } else {
      _accommodationFilters[index].isSelected = !_accommodationFilters[index].isSelected;
      final hasSpecificType = _accommodationFilters.skip(1).any((PopularFilterListData data) => data.isSelected);

      _accommodationFilters[0].isSelected = !hasSpecificType;
    }
  }

  Widget _buildDistanceFilter(ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Distance from city center',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SliderView(
          distanceValue: _distanceValue,
          onDistanceChanged: (double value) {
            _distanceValue = value;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPopularFilters(ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Popular filters',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(children: _buildPopularFilterRows()),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  List<Widget> _buildPopularFilterRows() {
    final rows = <Widget>[];
    const columnCount = 2;
    for (var index = 0; index < _popularFilters.length; index += columnCount) {
      final items = <Widget>[_buildPopularFilter(_popularFilters[index])];
      final hasSecondItem = index + 1 < _popularFilters.length;

      if (hasSecondItem) {
        items.add(_buildPopularFilter(_popularFilters[index + 1]));
      } else {
        items.add(const Expanded(child: SizedBox()));
      }

      rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: items));
    }

    return rows;
  }

  Widget _buildPopularFilter(PopularFilterListData filter) {
    void toggleFilter() {
      setState(() {
        filter.isSelected = !filter.isSelected;
      });
    }

    return Expanded(
      child: Semantics(
        label: filter.label,
        checked: filter.isSelected,
        onTap: toggleFilter,
        child: ExcludeSemantics(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: Text(filter.label),
            value: filter.isSelected,
            onChanged: (_) => toggleFilter(),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceFilter(ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Price (for 1 night)',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        RangeSliderView(
          values: _values,
          onChangeRangeValues: (RangeValues values) {
            _values = values;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAppBar(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.shadow.withValues(alpha: 0.2), offset: const Offset(0, 2), blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: IconButton(
                tooltip: 'Close filters',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Filters', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
              ),
            ),
            SizedBox(width: AppBar().preferredSize.height + 40, height: AppBar().preferredSize.height),
          ],
        ),
      ),
    );
  }
}
