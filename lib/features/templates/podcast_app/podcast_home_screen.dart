import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/podcast_section.dart';
import 'models/podcast_show.dart';
import 'podcast_app_theme.dart';
import 'sections/podcast_discover_section.dart';
import 'sections/podcast_library_section.dart';
import 'sections/podcast_player_section.dart';
import 'widgets/podcast_mini_player.dart';
import 'widgets/podcast_navigation_drawer.dart';

class PodcastHomeScreen extends StatefulWidget {
  const PodcastHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  State<PodcastHomeScreen> createState() => _PodcastHomeScreenState();
}

class _PodcastHomeScreenState extends State<PodcastHomeScreen> {
  late final _scrollControllers = <PodcastSection, ScrollController>{
    for (final section in PodcastSection.values) section: ScrollController(),
  };
  final _savedShowIds = <String>{};
  final _downloadedShowIds = <String>{};
  var _selectedSection = PodcastSection.discover;
  var _selectedCategory = PodcastCategory.all;
  var _currentShow = PodcastShow.samples.first;
  var _query = '';
  var _hasPlayback = false;
  var _isPlaying = false;
  var _progress = 0.36;
  var _speed = 1.0;

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shows = PodcastShow.samples.where(_matchesFilters).toList(growable: false);
    final savedShows = PodcastShow.samples
        .where((PodcastShow show) => _savedShowIds.contains(show.id))
        .toList(growable: false);
    final scrollController = _scrollControllers[_selectedSection]!;

    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: PodcastAppTheme.build,
      builder: (BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final dark = Theme.of(context).brightness == Brightness.dark;
        final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

        return PrimaryScrollController(
          controller: scrollController,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: dark ? const Color(0xFF191711) : PodcastAppTheme.ink,
              foregroundColor: PodcastAppTheme.signal,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: usesLargeText ? 92 : 72,
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      tooltip: 'Back to template gallery',
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: PodcastAppTheme.signal),
                        shape: const CircleBorder(),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : null,
              title: usesLargeText
                  ? const Text(
                      'Wave',
                      style: TextStyle(
                        fontFamily: PodcastAppTheme.displayFontName,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : const Row(
                      children: <Widget>[
                        Text(
                          'Wave',
                          style: TextStyle(
                            fontFamily: PodcastAppTheme.displayFontName,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.8,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('/ 072', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                      ],
                    ),
              actions: <Widget>[
                if (!usesLargeText)
                  Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: const BorderRadius.all(Radius.circular(99)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                        child: Text(
                          'LIVE SIGNAL',
                          style: TextStyle(color: PodcastAppTheme.ink, fontSize: 8, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      tooltip: 'Open listening menu',
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      icon: const Icon(Icons.menu_rounded),
                    );
                  },
                ),
              ],
            ),
            body: TemplateEntrance(
              child: TemplateSectionSwitcher(
                selectedIndex: _selectedSection.index,
                children: <Widget>[
                  PodcastDiscoverSection(
                    shows: shows,
                    selectedCategory: _selectedCategory,
                    savedShowIds: _savedShowIds,
                    scrollController: _scrollControllers[PodcastSection.discover]!,
                    onQueryChanged: (String query) {
                      setState(() {
                        _query = query.trim().toLowerCase();
                      });
                    },
                    onCategorySelected: (PodcastCategory category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    onPlay: _play,
                    onToggleSaved: _toggleSaved,
                  ),
                  PodcastLibrarySection(
                    shows: savedShows,
                    downloadedShowIds: _downloadedShowIds,
                    scrollController: _scrollControllers[PodcastSection.library]!,
                    onPlay: _play,
                    onRemove: _toggleSaved,
                    onToggleDownloaded: _toggleDownloaded,
                  ),
                  PodcastPlayerSection(
                    show: _currentShow,
                    isPlaying: _isPlaying,
                    progress: _progress,
                    speed: _speed,
                    scrollController: _scrollControllers[PodcastSection.player]!,
                    onTogglePlayback: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    onProgressChanged: (double value) {
                      setState(() {
                        _progress = value;
                      });
                    },
                    onCycleSpeed: _cycleSpeed,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _selectedSection == PodcastSection.player || !_hasPlayback
                ? null
                : PodcastMiniPlayer(
                    show: _currentShow,
                    isPlaying: _isPlaying,
                    progress: _progress,
                    onOpen: () => _selectSection(PodcastSection.player),
                    onTogglePlayback: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
            endDrawer: PodcastNavigationDrawer(
              selectedSection: _selectedSection,
              currentShow: _currentShow,
              onSelected: _selectSection,
            ),
          ),
        );
      },
    );
  }

  bool _matchesFilters(PodcastShow show) {
    final matchesCategory = _selectedCategory == PodcastCategory.all || show.category == _selectedCategory;
    final matchesQuery =
        _query.isEmpty ||
        show.title.toLowerCase().contains(_query) ||
        show.author.toLowerCase().contains(_query) ||
        show.episodeTitle.toLowerCase().contains(_query);
    return matchesCategory && matchesQuery;
  }

  void _play(PodcastShow show) {
    setState(() {
      _currentShow = show;
      _selectedSection = PodcastSection.player;
      _hasPlayback = true;
      _isPlaying = true;
      _progress = 0;
    });
  }

  void _toggleSaved(PodcastShow show) {
    setState(() {
      if (!_savedShowIds.remove(show.id)) {
        _savedShowIds.add(show.id);
      } else {
        _downloadedShowIds.remove(show.id);
      }
    });
  }

  void _toggleDownloaded(PodcastShow show) {
    setState(() {
      if (!_downloadedShowIds.remove(show.id)) {
        _downloadedShowIds.add(show.id);
      }
    });
  }

  void _cycleSpeed() {
    const speeds = <double>[1, 1.25, 1.5, 2];
    final index = speeds.indexOf(_speed);
    setState(() {
      _speed = speeds[(index + 1) % speeds.length];
    });
  }

  void _selectSection(PodcastSection section) {
    if (section == _selectedSection) {
      final controller = _scrollControllers[section]!;
      if (controller.hasClients) {
        if (MediaQuery.disableAnimationsOf(context)) {
          controller.jumpTo(0);
        } else {
          controller.animateTo(0, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
        }
      }
      return;
    }
    setState(() {
      _selectedSection = section;
    });
  }
}
