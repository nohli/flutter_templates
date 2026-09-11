import 'package:flutter/material.dart';

import '../models/travel_day.dart';

class TravelTimeline extends StatelessWidget {
  const TravelTimeline({required this.stops, required this.savedStopIds, required this.onToggleSaved, super.key});

  final List<TravelStop> stops;
  final Set<String> savedStopIds;
  final ValueChanged<TravelStop> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var index = 0; index < stops.length; index++)
          _TimelineEntry(
            stop: stops[index],
            isFirst: index == 0,
            isLast: index == stops.length - 1,
            isSaved: savedStopIds.contains(stops[index].id),
            onToggleSaved: () => onToggleSaved(stops[index]),
          ),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.stop,
    required this.isFirst,
    required this.isLast,
    required this.isSaved,
    required this.onToggleSaved,
  });

  final TravelStop stop;
  final bool isFirst;
  final bool isLast;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final timeline = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _TimelineMarker(kind: stop.kind, isFirst: isFirst, isLast: isLast),
          const SizedBox(width: 10),
          Expanded(
            child: _TravelStopCard(stop: stop, isSaved: isSaved, onToggleSaved: onToggleSaved),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: usesLargeText
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(stop.time, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                timeline,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 17),
                    child: Text(stop.time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
                Expanded(child: timeline),
              ],
            ),
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({required this.kind, required this.isFirst, required this.isLast});

  final TravelStopKind kind;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 34,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: isFirst ? 22 : 0,
            bottom: isLast ? 22 : 0,
            child: Container(width: 2, color: colors.outlineVariant),
          ),
          Positioned(
            top: 12,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 3),
              ),
              child: Icon(_iconFor(kind), size: 12, color: colors.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(TravelStopKind kind) => switch (kind) {
    TravelStopKind.arrival => Icons.flight_land_rounded,
    TravelStopKind.coffee => Icons.coffee_rounded,
    TravelStopKind.culture => Icons.explore_rounded,
    TravelStopKind.food => Icons.restaurant_rounded,
    TravelStopKind.coast => Icons.waves_rounded,
    TravelStopKind.stay => Icons.bed_rounded,
  };
}

class _TravelStopCard extends StatelessWidget {
  const _TravelStopCard({required this.stop, required this.isSaved, required this.onToggleSaved});

  final TravelStop stop;
  final bool isSaved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
      padding: const EdgeInsets.fromLTRB(17, 15, 9, 15),
      decoration: BoxDecoration(
        color: isSaved ? colors.secondaryContainer.withValues(alpha: 0.7) : colors.surface,
        border: Border.all(color: isSaved ? colors.secondary : colors.outlineVariant),
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x12152B2D), blurRadius: 18, offset: Offset(0, 7))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(stop.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.15)),
                const SizedBox(height: 5),
                Text(
                  stop.place,
                  style: TextStyle(color: colors.secondary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 7),
                Text(stop.detail, style: TextStyle(color: colors.onSurfaceVariant, height: 1.35)),
              ],
            ),
          ),
          IconButton(
            tooltip: isSaved ? 'Remove ${stop.title} from saved' : 'Save ${stop.title}',
            onPressed: onToggleSaved,
            icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
          ),
        ],
      ),
    );
  }
}
