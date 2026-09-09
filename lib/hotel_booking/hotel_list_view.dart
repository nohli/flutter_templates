import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/hotel_list_data.dart';
import 'smooth_star_rating.dart';

class HotelListView extends StatelessWidget {
  const HotelListView({
    required this.hotelData,
    required this.isFavorite,
    required this.onFavoriteChanged,
    required this.animation,
    super.key,
  });

  final HotelListData hotelData;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final stackDetails = MediaQuery.sizeOf(context).width < 360 || textScale >= 2;
    final showFullText = textScale >= 2;
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: showFullText ? colors.shadow.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          AspectRatio(aspectRatio: 2, child: Image.asset(hotelData.imagePath, fit: BoxFit.cover)),
                          Container(
                            color: colors.surface,
                            child: Flex(
                              direction: stackDetails ? Axis.vertical : Axis.horizontal,
                              crossAxisAlignment: stackDetails ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
                              children: <Widget>[
                                if (stackDetails)
                                  _HotelDetails(hotelData: hotelData, colors: colors, showFullText: showFullText)
                                else
                                  Expanded(
                                    child: _HotelDetails(
                                      hotelData: hotelData,
                                      colors: colors,
                                      showFullText: showFullText,
                                    ),
                                  ),
                                _HotelPrice(hotelData: hotelData, colors: colors, alignEnd: !stackDetails),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: showFullText ? colors.surfaceContainerHigh.withValues(alpha: 0.9) : Colors.transparent,
                          shape: const CircleBorder(),
                          child: Semantics(
                            button: true,
                            toggled: isFavorite,
                            label: isFavorite
                                ? 'Remove ${hotelData.title} from favorites'
                                : 'Favorite ${hotelData.title}',
                            onTap: onFavoriteChanged,
                            child: ExcludeSemantics(
                              child: IconButton(
                                tooltip: isFavorite
                                    ? 'Remove ${hotelData.title} from favorites'
                                    : 'Favorite ${hotelData.title}',
                                constraints: const BoxConstraints.tightFor(width: 48, height: 48),
                                isSelected: isFavorite,
                                selectedIcon: Icon(Icons.favorite, color: colors.primary),
                                icon: Icon(Icons.favorite_border, color: colors.primary),
                                onPressed: onFavoriteChanged,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HotelDetails extends StatelessWidget {
  const _HotelDetails({required this.hotelData, required this.colors, required this.showFullText});

  final HotelListData hotelData;
  final ColorScheme colors;
  final bool showFullText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: showFullText
          ? const EdgeInsets.fromLTRB(16, 8, 16, 8)
          : const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hotelData.title,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          if (showFullText)
            Row(
              children: <Widget>[
                FaIcon(FontAwesomeIcons.locationDot, size: 12, color: colors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${hotelData.location} · ${hotelData.distanceKm.toStringAsFixed(1)} km to city',
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
                  ),
                ),
              ],
            )
          else
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(hotelData.location, style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant)),
                  const SizedBox(width: 4),
                  FaIcon(FontAwesomeIcons.locationDot, size: 12, color: colors.primary),
                  Text(
                    '${hotelData.distanceKm.toStringAsFixed(1)} km to city',
                    style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: <Widget>[
                SmoothStarRating(
                  rating: hotelData.rating,
                  size: 20,
                  color: colors.primary,
                  borderColor: colors.primary,
                ),
                if (showFullText)
                  Expanded(
                    child: Text(
                      ' ${hotelData.reviews} Reviews',
                      maxLines: null,
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
                    ),
                  )
                else
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ' ${hotelData.reviews} Reviews',
                        style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelPrice extends StatelessWidget {
  const _HotelPrice({required this.hotelData, required this.colors, required this.alignEnd});

  final HotelListData hotelData;
  final ColorScheme colors;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: alignEnd ? const EdgeInsets.only(right: 16, top: 8) : const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '\$${hotelData.nightlyPrice}',
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          Text('/per night', style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
