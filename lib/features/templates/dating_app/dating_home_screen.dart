import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'dating_app_theme.dart';
import 'models/dating_profile.dart';
import 'widgets/dating_action_bar.dart';
import 'widgets/dating_swipe_deck.dart';

class DatingHomeScreen extends StatefulWidget {
  const DatingHomeScreen({this.appearance = AppAppearance.dark, super.key});

  final AppAppearance appearance;

  @override
  State<DatingHomeScreen> createState() => _DatingHomeScreenState();
}

class _DatingHomeScreenState extends State<DatingHomeScreen> {
  final _scrollController = ScrollController();
  final _swipeController = DatingSwipeController();
  var _profileIndex = 0;
  int? _previousProfileIndex;
  String? _decision;

  @override
  void dispose() {
    _swipeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = DatingProfile.samples[_profileIndex];

    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: DatingAppTheme.build,
      builder: (BuildContext context) {
        return PrimaryScrollController(
          controller: _scrollController,
          child: Scaffold(
            bottomNavigationBar: _DatingActionDock(
              onUndo: _previousProfileIndex == null ? null : _undo,
              onDismiss: _swipeController.pass,
              onSpark: _swipeController.spark,
              onLike: _swipeController.like,
            ),
            body: SafeArea(
              bottom: false,
              child: TemplateEntrance(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
                      sliver: SliverList.list(
                        children: <Widget>[
                          const _DatingHeader(),
                          const SizedBox(height: 18),
                          const _DiscoveryIntro(),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: MediaQuery.disableAnimationsOf(context)
                                ? Duration.zero
                                : const Duration(milliseconds: 240),
                            child: _DecisionNote(key: ValueKey<String?>(_decision), message: _decision),
                          ),
                          const SizedBox(height: 18),
                          DatingSwipeDeck(
                            profile: profile,
                            nextProfile: DatingProfile.samples[(_profileIndex + 1) % DatingProfile.samples.length],
                            controller: _swipeController,
                            onChoice: _choose,
                          ),
                          const SizedBox(height: 20),
                          const _TonightCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _choose(DatingProfileChoice decision) {
    final profile = DatingProfile.samples[_profileIndex];
    setState(() {
      _previousProfileIndex = _profileIndex;
      _profileIndex = (_profileIndex + 1) % DatingProfile.samples.length;
      _decision = switch (decision) {
        DatingProfileChoice.pass => 'Passed on ${profile.name}. Your next introduction is ready.',
        DatingProfileChoice.spark => 'A spark was sent to ${profile.name}.',
        DatingProfileChoice.like => 'You liked ${profile.name}. We’ll let you know if it’s mutual.',
      };
    });
  }

  void _undo() {
    setState(() {
      _profileIndex = _previousProfileIndex!;
      _previousProfileIndex = null;
      _decision = 'Your last choice was restored.';
    });
  }
}

class _DatingHeader extends StatelessWidget {
  const _DatingHeader();

  @override
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return Row(
      children: <Widget>[
        if (Navigator.of(context).canPop())
          IconButton(
            tooltip: 'Back to template gallery',
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              shape: const RoundedRectangleBorder(),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
          )
        else
          const SizedBox.square(dimension: 48),
        Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Flexible(
                  child: Text(
                    'Sway',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontFamily: DatingAppTheme.displayFontName,
                      fontSize: 31,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (!largeText) ...<Widget>[
                  const SizedBox(width: 8),
                  const Text(
                    'AFTER DARK / 04',
                    style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                  ),
                  const SizedBox(width: 7),
                  const _LiveDot(),
                ],
              ],
            ),
          ),
        ),
        const SizedBox.square(dimension: 48),
      ],
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Discover is live',
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.45), blurRadius: 9),
          ],
        ),
      ),
    );
  }
}

class _DiscoveryIntro extends StatelessWidget {
  const _DiscoveryIntro();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    if (largeText) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('CURATED CONNECTIONS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900)),
          SizedBox(height: 10),
          Text(
            'One good introduction.',
            style: TextStyle(
              fontFamily: DatingAppTheme.displayFontName,
              fontSize: 29,
              fontWeight: FontWeight.w500,
              height: 0.95,
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'CURATED CONNECTIONS / TONIGHT',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              SizedBox(height: 8),
              Text(
                'ONE GOOD\nINTRODUCTION.',
                style: TextStyle(
                  fontFamily: DatingAppTheme.displayFontName,
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                  height: 0.82,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        DecoratedBox(
          decoration: BoxDecoration(color: colors.primaryContainer),
          child: SizedBox.square(
            dimension: 48,
            child: Center(
              child: Text(
                '${DatingProfile.samples.length}',
                style: TextStyle(color: colors.onPrimaryContainer, fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DatingActionDock extends StatelessWidget {
  const _DatingActionDock({required this.onDismiss, required this.onLike, required this.onSpark, this.onUndo});

  final VoidCallback onDismiss;
  final VoidCallback onLike;
  final VoidCallback onSpark;
  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: DatingAppTheme.background,
        border: Border(top: BorderSide(color: DatingAppTheme.primary, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: DatingActionBar(onUndo: onUndo, onDismiss: onDismiss, onSpark: onSpark, onLike: onLike),
        ),
      ),
    );
  }
}

class _DecisionNote extends StatelessWidget {
  const _DecisionNote({required this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        message ?? 'Swipe left to pass · right to like. Every profile returns tomorrow.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35),
      ),
    );
  }
}

class _TonightCard extends StatelessWidget {
  const _TonightCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        border: Border.all(color: colors.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            const DecoratedBox(
              decoration: BoxDecoration(color: DatingAppTheme.sun),
              child: SizedBox.square(
                dimension: 44,
                child: Icon(Icons.local_bar_outlined, color: DatingAppTheme.background, size: 24),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Thursday social',
                    style: TextStyle(color: colors.onPrimaryContainer, fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text('12 seats · Old Port · 19:30', style: TextStyle(color: colors.onPrimaryContainer)),
                ],
              ),
            ),
            Icon(Icons.arrow_outward_rounded, color: colors.onPrimaryContainer),
          ],
        ),
      ),
    );
  }
}
