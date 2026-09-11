import 'package:flutter/material.dart';

import '../models/podcast_show.dart';
import '../podcast_app_theme.dart';
import '../widgets/podcast_show_card.dart';
import '../widgets/podcast_vinyl.dart';

class PodcastDiscoverSection extends StatelessWidget {
  const PodcastDiscoverSection({
    required this.shows,
    required this.selectedCategory,
    required this.savedShowIds,
    required this.scrollController,
    required this.onQueryChanged,
    required this.onCategorySelected,
    required this.onPlay,
    required this.onToggleSaved,
    super.key,
  });

  final List<PodcastShow> shows;
  final PodcastCategory selectedCategory;
  final Set<String> savedShowIds;
  final ScrollController scrollController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<PodcastCategory> onCategorySelected;
  final ValueChanged<PodcastShow> onPlay;
  final ValueChanged<PodcastShow> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      key: const PageStorageKey<String>('podcast-discover'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const _BroadcastHero(),
        const SizedBox(height: 16),
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Search shows or episodes',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: colors.outlineVariant),
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.outlineVariant),
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final category in PodcastCategory.values) ...<Widget>[
                ChoiceChip(
                  label: Text(_labelFor(category)),
                  selected: category == selectedCategory,
                  showCheckmark: false,
                  shape: const StadiumBorder(),
                  onSelected: (_) => onCategorySelected(category),
                ),
                if (category != PodcastCategory.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'ON AIR NOW',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.4),
              ),
            ),
            Text('${shows.length} shows', style: TextStyle(color: colors.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 12),
        if (shows.isEmpty)
          const _EmptyPodcastState()
        else
          for (final show in shows) ...<Widget>[
            PodcastShowCard(
              show: show,
              isSaved: savedShowIds.contains(show.id),
              onPlay: () => onPlay(show),
              onToggleSaved: () => onToggleSaved(show),
            ),
            if (show != shows.last) const SizedBox(height: 12),
          ],
      ],
    );
  }

  String _labelFor(PodcastCategory category) => switch (category) {
    PodcastCategory.all => 'All',
    PodcastCategory.design => 'Design',
    PodcastCategory.culture => 'Culture',
    PodcastCategory.science => 'Science',
  };
}

class _BroadcastHero extends StatelessWidget {
  const _BroadcastHero();

  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final show = PodcastShow.samples.first;

    if (largeText) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFF191711)),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'WAVE RADIO · LIVE',
                style: TextStyle(color: Color(0xFFF3DD43), fontSize: 8, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 14),
              Text(
                'Listen closer.',
                style: TextStyle(
                  color: Color(0xFFFFFCF0),
                  fontFamily: PodcastAppTheme.displayFontName,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 0.95,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Independent voices and curious ideas, tuned for today.',
                style: TextStyle(color: Color(0xCCFFFCF0), fontSize: 11, height: 1.3),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 188,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFF191711)),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            const Positioned.fill(child: CustomPaint(painter: _SignalPainter())),
            const Positioned(
              left: 18,
              top: 16,
              child: Text(
                'WAVE RADIO · LIVE',
                style: TextStyle(
                  color: Color(0xFFF3DD43),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Positioned(
              left: 18,
              top: 48,
              child: Text(
                'LISTEN\nCLOSER.',
                style: TextStyle(
                  color: Color(0xFFFFFCF0),
                  fontFamily: PodcastAppTheme.displayFontName,
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -1,
                  height: 0.88,
                ),
              ),
            ),
            const Positioned(
              left: 18,
              bottom: 18,
              child: Text(
                'INDEPENDENT VOICES / CURIOUS IDEAS',
                style: TextStyle(color: Color(0xB3FFFCF0), fontSize: 7, fontWeight: FontWeight.w700),
              ),
            ),
            Positioned(right: 12, top: 20, width: 154, height: 154, child: PodcastVinyl(show: show)),
            const Positioned(
              right: 75,
              top: 72,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF3DD43), shape: BoxShape.circle),
                child: SizedBox.square(
                  dimension: 30,
                  child: Center(
                    child: Text('072', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalPainter extends CustomPainter {
  const _SignalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x33F3DD43)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..moveTo(0, size.height * 0.77);
    for (var x = 0.0; x <= size.width; x += 9) {
      final height = x % 36 == 0 ? 22.0 : 8.0;
      path
        ..lineTo(x, size.height * 0.77 - height)
        ..lineTo(x + 4.5, size.height * 0.77 + height)
        ..lineTo(x + 9, size.height * 0.77);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SignalPainter oldDelegate) => false;
}

class _EmptyPodcastState extends StatelessWidget {
  const _EmptyPodcastState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: <Widget>[
            Icon(Icons.podcasts_rounded, size: 42, color: colors.primary),
            const SizedBox(height: 12),
            const Text('No matching shows', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
