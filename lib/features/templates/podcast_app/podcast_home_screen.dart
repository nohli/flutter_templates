import 'package:flutter/material.dart';

import '../shared/template_motion.dart';
import 'models/podcast_section.dart';
import 'models/podcast_show.dart';
import 'podcast_app_theme.dart';
import 'sections/podcast_discover_section.dart';
import 'sections/podcast_library_section.dart';
import 'sections/podcast_player_section.dart';
import 'widgets/podcast_bottom_bar.dart';

class PodcastHomeScreen extends StatefulWidget {
  const PodcastHomeScreen({super.key});

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

    return Theme(
      data: PodcastAppTheme.build(),
      child: PrimaryScrollController(
        controller: scrollController,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: PodcastAppTheme.background,
            surfaceTintColor: Colors.transparent,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    tooltip: 'Back to template gallery',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  )
                : null,
            title: const Text('WAVE', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2)),
            actions: <Widget>[
              IconButton(
                tooltip: 'Podcast notifications',
                onPressed: () => _showMessage('No new sample notifications.'),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              const SizedBox(width: 8),
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
          bottomNavigationBar: PodcastBottomBar(selectedSection: _selectedSection, onSelected: _selectSection),
        ),
      ),
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
