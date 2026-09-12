import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../dating_app_theme.dart';
import '../models/dating_profile.dart';
import 'dating_profile_card.dart';

enum DatingProfileChoice { pass, spark, like }

class DatingSwipeController {
  _DatingSwipeDeckState? _state;

  void pass() => _state?._choose(DatingProfileChoice.pass);

  void spark() => _state?._choose(DatingProfileChoice.spark);

  void like() => _state?._choose(DatingProfileChoice.like);

  void dispose() => _state = null;
}

class DatingSwipeDeck extends StatefulWidget {
  const DatingSwipeDeck({
    required this.profile,
    required this.nextProfile,
    required this.onChoice,
    required this.controller,
    super.key,
  });

  final DatingProfile profile;
  final DatingProfile nextProfile;
  final ValueChanged<DatingProfileChoice> onChoice;
  final DatingSwipeController controller;

  @override
  State<DatingSwipeDeck> createState() => _DatingSwipeDeckState();
}

class _DatingSwipeDeckState extends State<DatingSwipeDeck> with SingleTickerProviderStateMixin {
  static const _decisionVelocity = 850.0;
  static const _snapDuration = Duration(milliseconds: 360);
  static const _decisionDuration = Duration(milliseconds: 260);

  late final _motionController = AnimationController(vsync: this)..addListener(_followAnimation);
  Animation<Offset> _motion = const AlwaysStoppedAnimation<Offset>(Offset.zero);
  var _offset = Offset.zero;
  var _cardWidth = 1.0;
  var _isCommitting = false;
  var _thresholdFeedbackSent = false;

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }

  @override
  void didUpdateWidget(DatingSwipeDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    if (oldWidget.controller._state == this) {
      oldWidget.controller._state = null;
    }
    widget.controller._state = this;
  }

  @override
  void dispose() {
    if (widget.controller._state == this) {
      widget.controller._state = null;
    }
    _motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final showQueuedProfile = MediaQuery.textScalerOf(context).scale(1) < 2;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _cardWidth = constraints.maxWidth;
        final progress = (_offset.dx / _decisionThreshold).clamp(-1.0, 1.0);
        final sparkProgress = (-_offset.dy / _decisionThreshold).clamp(0.0, 1.0);
        final revealProgress = (progress.abs() + sparkProgress).clamp(0.0, 1.0);
        final rotation = reduceMotion ? 0.0 : progress * 0.085;

        return Semantics(
          container: true,
          label: 'Swipe ${widget.profile.name} left to pass or right to like',
          customSemanticsActions: <CustomSemanticsAction, VoidCallback>{
            CustomSemanticsAction(label: 'Pass on ${widget.profile.name}'): widget.controller.pass,
            CustomSemanticsAction(label: 'Send a spark to ${widget.profile.name}'): widget.controller.spark,
            CustomSemanticsAction(label: 'Like ${widget.profile.name}'): widget.controller.like,
          },
          child: MouseRegion(
            cursor: _offset == Offset.zero ? SystemMouseCursors.grab : SystemMouseCursors.grabbing,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: _isCommitting ? null : _startDrag,
              onHorizontalDragUpdate: _isCommitting ? null : _updateDrag,
              onHorizontalDragEnd: _isCommitting ? null : _endDrag,
              onHorizontalDragCancel: _isCommitting ? null : _cancelDrag,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  if (showQueuedProfile)
                    Positioned.fill(
                      child: ExcludeSemantics(
                        child: IgnorePointer(
                          child: Transform.translate(
                            offset: Offset(0, 16 - 8 * revealProgress),
                            child: Transform.scale(
                              scale: 0.955 + 0.025 * revealProgress,
                              child: Opacity(
                                opacity: 0.5 + 0.3 * revealProgress,
                                child: DatingProfileCard(profile: widget.nextProfile),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: _offset,
                    child: Transform.rotate(
                      angle: rotation,
                      alignment: Alignment.bottomCenter,
                      child: RepaintBoundary(
                        child: Stack(
                          children: <Widget>[
                            DatingProfileCard(profile: widget.profile),
                            Positioned(
                              left: 20,
                              top: 24,
                              child: _ChoiceStamp(
                                label: 'LIKE',
                                icon: Icons.favorite_rounded,
                                color: DatingAppTheme.mint,
                                opacity: progress.clamp(0.0, 1.0),
                                angle: -0.08,
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 24,
                              child: _ChoiceStamp(
                                label: 'PASS',
                                icon: Icons.close_rounded,
                                color: DatingAppTheme.coral,
                                opacity: (-progress).clamp(0.0, 1.0),
                                angle: 0.08,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 24,
                              child: Center(
                                child: _ChoiceStamp(
                                  label: 'SPARK',
                                  icon: Icons.auto_awesome_rounded,
                                  color: DatingAppTheme.sun,
                                  opacity: sparkProgress,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  double get _decisionThreshold => (_cardWidth * 0.24).clamp(84.0, 118.0);

  void _startDrag(DragStartDetails details) {
    _motionController.stop();
    _thresholdFeedbackSent = _offset.dx.abs() >= _decisionThreshold;
  }

  void _updateDrag(DragUpdateDetails details) {
    final nextOffset = Offset(
      (_offset.dx + details.delta.dx).clamp(-_cardWidth * 0.72, _cardWidth * 0.72),
      (_offset.dy + details.delta.dy * 0.16).clamp(-26.0, 26.0),
    );
    final crossedThreshold = nextOffset.dx.abs() >= _decisionThreshold;
    if (crossedThreshold && !_thresholdFeedbackSent) {
      unawaited(HapticFeedback.selectionClick());
    }
    _thresholdFeedbackSent = crossedThreshold;
    setState(() => _offset = nextOffset);
  }

  void _endDrag(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final hasDistance = _offset.dx.abs() >= _decisionThreshold;
    final hasVelocity = velocity.abs() >= _decisionVelocity;
    if (!hasDistance && !hasVelocity) {
      unawaited(_snapBack());
      return;
    }

    final direction = hasVelocity ? velocity.sign : _offset.dx.sign;
    unawaited(_choose(direction < 0 ? DatingProfileChoice.pass : DatingProfileChoice.like));
  }

  void _cancelDrag() => unawaited(_snapBack());

  Future<void> _snapBack() async {
    _thresholdFeedbackSent = false;
    if (MediaQuery.disableAnimationsOf(context)) {
      setState(() => _offset = Offset.zero);
      return;
    }
    await _animateTo(Offset.zero, duration: _snapDuration, curve: Curves.easeOutBack);
  }

  Future<void> _choose(DatingProfileChoice choice) async {
    if (_isCommitting) {
      return;
    }
    _isCommitting = true;
    _thresholdFeedbackSent = false;
    unawaited(HapticFeedback.mediumImpact());

    if (!MediaQuery.disableAnimationsOf(context)) {
      final target = switch (choice) {
        DatingProfileChoice.pass => Offset(-_cardWidth * 1.25, _offset.dy - 18),
        DatingProfileChoice.spark => Offset(0, -_cardWidth * 1.35),
        DatingProfileChoice.like => Offset(_cardWidth * 1.25, _offset.dy - 18),
      };
      await _animateTo(target, duration: _decisionDuration, curve: Curves.easeInCubic);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _offset = Offset.zero;
      _isCommitting = false;
    });
    widget.onChoice(choice);
  }

  Future<void> _animateTo(Offset target, {required Duration duration, required Curve curve}) async {
    _motionController.duration = duration;
    _motion = Tween<Offset>(
      begin: _offset,
      end: target,
    ).animate(CurvedAnimation(parent: _motionController, curve: curve));
    try {
      await _motionController.forward(from: 0).orCancel;
    } on TickerCanceled {
      // A new direct manipulation replaces the interrupted snap-back motion.
    }
  }

  void _followAnimation() {
    if (mounted) {
      setState(() => _offset = _motion.value);
    }
  }
}

class _ChoiceStamp extends StatelessWidget {
  const _ChoiceStamp({
    required this.label,
    required this.icon,
    required this.color,
    required this.opacity,
    this.angle = 0,
  });

  final String label;
  final IconData icon;
  final Color color;
  final double opacity;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: angle,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xE617111E),
              border: Border.all(color: color, width: 3),
              borderRadius: DatingAppTheme.controlRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, color: color, size: 17),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
