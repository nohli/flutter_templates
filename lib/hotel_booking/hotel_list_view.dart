import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'model/hotel_list_data.dart';
import 'smooth_star_rating.dart';

class HotelListView extends StatelessWidget {
  const HotelListView({
    required this.hotelData,
    required this.isFavorite,
    required this.onFavoriteChanged,
    required this.animationController,
    required this.animation,
    super.key,
  });

  final HotelListData hotelData;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final stackDetails = MediaQuery.sizeOf(context).width < 360 || textScale >= 2;
    final showFullText = textScale >= 2;
    return AnimatedBuilder(
      animation: animationController,
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
                    BoxShadow(color: colors.shadow.withValues(alpha: 0.3), offset: const Offset(4, 4), blurRadius: 16),
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
                            color: colors.surfaceContainerLow,
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
                          color: colors.surfaceContainerHigh.withValues(alpha: 0.9),
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
                                selectedIcon: Icon(Icons.favorite, color: colors.secondary),
                                icon: Icon(Icons.favorite_border, color: colors.secondary),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hotelData.title,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          Row(
            children: <Widget>[
              FaIcon(FontAwesomeIcons.locationDot, size: 12, color: colors.secondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${hotelData.location} · ${hotelData.distanceKm.toStringAsFixed(1)} km to city',
                  maxLines: showFullText ? null : 2,
                  overflow: showFullText ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: <Widget>[
                SmoothStarRating(
                  rating: hotelData.rating,
                  size: 20,
                  color: colors.secondary,
                  borderColor: colors.secondary,
                ),
                Expanded(
                  child: Text(
                    ' ${hotelData.reviews} Reviews',
                    maxLines: showFullText ? null : 1,
                    overflow: showFullText ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
