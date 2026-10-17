import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import 'hotel_app_theme.dart';
import 'model/hotel_filter_settings.dart';
import 'range_slider_view.dart';
import 'slider_view.dart';
import '../../../l10n/localizations.dart';

const _amenityOptions = HotelAmenity.values;
const _accommodationOptions = HotelAccommodation.values;

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({
    this.appearance = AppAppearance.light,
    this.initialSettings = const HotelFilterSettings(),
    super.key,
  });

  final AppAppearance appearance;
  final HotelFilterSettings initialSettings;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late RangeValues _values;
  late double _distanceValue;
  late final Set<HotelAmenity> _selectedAmenities;
  late final Set<HotelAccommodation> _selectedAccommodationTypes;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(widget.initialSettings.minimumPrice, widget.initialSettings.maximumPrice);
    _distanceValue = widget.initialSettings.maximumDistanceKm * 10;
    _selectedAmenities = widget.initialSettings.amenities.toSet();
    _selectedAccommodationTypes = widget.initialSettings.accommodationTypes.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HotelAppTheme.build(widget.appearance.resolve(context));
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
                  onPressed: _applyFilters,
                  child: Text(context.l10n.apply),
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
        _FilterSectionTitle(label: context.l10n.typeOfAccommodation, colors: colors),
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
    for (var i = 0; i < _accommodationOptions.length; i++) {
      final option = _accommodationOptions[i];
      final label = option.label(context.l10n);
      final isSelected = i == 0 ? _selectedAccommodationTypes.isEmpty : _selectedAccommodationTypes.contains(option);

      void toggleAccommodation() {
        setState(() {
          _toggleAccommodation(i);
        });
      }

      rows.add(
        Semantics(
          label: label,
          toggled: isSelected,
          onTap: toggleAccommodation,
          child: ExcludeSemantics(
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(label),
              onChanged: (_) => toggleAccommodation(),
              value: isSelected,
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
      _selectedAccommodationTypes.clear();
      return;
    }

    final label = _accommodationOptions[index];
    _toggleSelection(_selectedAccommodationTypes, label);
  }

  Widget _buildDistanceFilter(ColorScheme colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FilterSectionTitle(label: context.l10n.distanceFromCityCenter, colors: colors),
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
        _FilterSectionTitle(label: context.l10n.popularFilters, colors: colors),
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
    for (var index = 0; index < _amenityOptions.length; index += columnCount) {
      final items = <Widget>[_buildPopularFilter(_amenityOptions[index])];
      final hasSecondItem = index + 1 < _amenityOptions.length;

      if (hasSecondItem) {
        items.add(_buildPopularFilter(_amenityOptions[index + 1]));
      } else {
        items.add(const Expanded(child: SizedBox()));
      }

      rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: items));
    }

    return rows;
  }

  Widget _buildPopularFilter(HotelAmenity amenity) {
    final label = amenity.label(context.l10n);
    final isSelected = _selectedAmenities.contains(amenity);

    void toggleFilter() {
      setState(() {
        _toggleSelection(_selectedAmenities, amenity);
      });
    }

    return Expanded(
      child: Semantics(
        label: label,
        checked: isSelected,
        onTap: toggleFilter,
        child: ExcludeSemantics(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: Text(label),
            value: isSelected,
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
        _FilterSectionTitle(label: context.l10n.priceFor1Night, colors: colors, bottomPadding: 16),
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
                tooltip: context.l10n.closeFilters,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(context.l10n.filters, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
              ),
            ),
            SizedBox(width: AppBar().preferredSize.height + 40, height: AppBar().preferredSize.height),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    final amenities = _amenityOptions.where(_selectedAmenities.contains).toList(growable: false);
    final types = _accommodationOptions.skip(1).where(_selectedAccommodationTypes.contains).toList(growable: false);
    final hasEveryType = types.length == _accommodationOptions.length - 1;
    final settings = HotelFilterSettings(
      minimumPrice: _values.start,
      maximumPrice: _values.end,
      maximumDistanceKm: _distanceValue / 10,
      amenities: amenities,
      accommodationTypes: hasEveryType ? const <HotelAccommodation>[] : types,
    );

    Navigator.pop(context, settings);
  }

  void _toggleSelection<T>(Set<T> selection, T label) {
    final wasSelected = !selection.add(label);

    if (wasSelected) {
      selection.remove(label);
    }
  }
}

class _FilterSectionTitle extends StatelessWidget {
  const _FilterSectionTitle({required this.label, required this.colors, this.bottomPadding = 8});

  final String label;
  final ColorScheme colors;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: bottomPadding),
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: colors.onSurfaceVariant,
          fontSize: MediaQuery.sizeOf(context).width > 360 ? 18 : 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
