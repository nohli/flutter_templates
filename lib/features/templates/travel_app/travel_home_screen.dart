import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/travel_day.dart';
import 'travel_app_theme.dart';
import 'widgets/travel_day_selector.dart';
import 'widgets/travel_route_card.dart';
import 'widgets/travel_timeline.dart';

class TravelHomeScreen extends StatefulWidget {
  const TravelHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  State<TravelHomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<TravelHomeScreen> {
  final _scrollController = ScrollController();
  final _savedStopIds = <String>{};
  var _selectedDayIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = TravelDay.samples[_selectedDayIndex];

    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: TravelAppTheme.build,
      builder: (BuildContext context) {
        final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

        return PrimaryScrollController(
          controller: _scrollController,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: TravelAppTheme.ink,
              foregroundColor: TravelAppTheme.surface,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: usesLargeText ? 92 : 72,
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      tooltip: 'Back to template gallery',
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: TravelAppTheme.sun),
                        shape: const RoundedRectangleBorder(),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : null,
              title: usesLargeText
                  ? const Text(
                      'Roam',
                      style: TextStyle(
                        fontFamily: TravelAppTheme.displayFontName,
                        color: TravelAppTheme.surface,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : const Row(
                      children: <Widget>[
                        Text(
                          'Roam',
                          style: TextStyle(
                            fontFamily: TravelAppTheme.displayFontName,
                            color: TravelAppTheme.surface,
                            fontSize: 29,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(width: 9),
                        Text(
                          'FIELD ATLAS / 01',
                          style: TextStyle(color: TravelAppTheme.surface, fontSize: 8, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Open trip map',
                  onPressed: () => _showMessage('The trip map is shown as an interface preview.'),
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: TravelAppTheme.sun),
                    shape: const RoundedRectangleBorder(),
                  ),
                  icon: const Icon(Icons.map_outlined),
                ),
              ],
            ),
            body: TemplateEntrance(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
                    sliver: SliverList.list(
                      children: <Widget>[
                        if (usesLargeText)
                          const Text(
                            'Madeira field atlas.',
                            style: TextStyle(
                              fontFamily: TravelAppTheme.displayFontName,
                              fontSize: 29,
                              height: 1,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        else
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'N 32°39′ / W 16°54′',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.4),
                              ),
                              SizedBox(height: 7),
                              Text(
                                'MADEIRA\nFIELD ATLAS.',
                                style: TextStyle(
                                  fontFamily: TravelAppTheme.displayFontName,
                                  fontSize: 39,
                                  height: 0.82,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.6,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        const TravelRouteCard(),
                        const SizedBox(height: 28),
                        const _ItineraryHeader(),
                        const SizedBox(height: 14),
                        TravelDaySelector(
                          days: TravelDay.samples,
                          selectedIndex: _selectedDayIndex,
                          onSelected: (int index) {
                            setState(() {
                              _selectedDayIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 17),
                        AnimatedSwitcher(
                          duration: MediaQuery.disableAnimationsOf(context)
                              ? Duration.zero
                              : const Duration(milliseconds: 260),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.04, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _SelectedItinerary(
                            key: ValueKey<int>(_selectedDayIndex),
                            day: selectedDay,
                            savedStopIds: _savedStopIds,
                            onToggleSaved: _toggleSaved,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleSaved(TravelStop stop) {
    setState(() {
      if (!_savedStopIds.remove(stop.id)) {
        _savedStopIds.add(stop.id);
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ItineraryHeader extends StatelessWidget {
  const _ItineraryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Text(
            'FIELD NOTES / ITINERARY',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
        ),
        Icon(Icons.near_me_rounded, color: Theme.of(context).colorScheme.secondary),
      ],
    );
  }
}

class _SelectedItinerary extends StatelessWidget {
  const _SelectedItinerary({required this.day, required this.savedStopIds, required this.onToggleSaved, super.key});

  final TravelDay day;
  final Set<String> savedStopIds;
  final ValueChanged<TravelStop> onToggleSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(day.summary, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 14),
        TravelTimeline(stops: day.stops, savedStopIds: savedStopIds, onToggleSaved: onToggleSaved),
      ],
    );
  }
}
