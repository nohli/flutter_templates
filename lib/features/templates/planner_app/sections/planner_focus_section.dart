import 'package:flutter/material.dart';

import '../planner_app_theme.dart';

class PlannerFocusSection extends StatelessWidget {
  const PlannerFocusSection({
    required this.isRunning,
    required this.scrollController,
    required this.onToggle,
    super.key,
  });

  final bool isRunning;
  final ScrollController scrollController;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final animationDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 260);

    return ListView(
      key: const PageStorageKey<String>('planner-focus'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Quiet focus', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text(
          'A distraction-free timer concept with truthful preview state.',
          style: TextStyle(color: PlannerAppTheme.mutedInk),
        ),
        const SizedBox(height: 28),
        AnimatedContainer(
          duration: animationDuration,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isRunning
                  ? const <Color>[PlannerAppTheme.primary, Color(0xFF7890FF)]
                  : const <Color>[PlannerAppTheme.navy, Color(0xFF334996)],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(34)),
            boxShadow: PlannerAppTheme.softShadow,
          ),
          child: Column(
            children: <Widget>[
              Text(
                isRunning ? 'FOCUSING' : 'READY',
                style: const TextStyle(
                  color: PlannerAppTheme.lime,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 18),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '25:00',
                  style: TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w700, letterSpacing: -2),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Review the launch flow',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFD9DFFC), fontSize: 15),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: onToggle,
                style: FilledButton.styleFrom(
                  backgroundColor: PlannerAppTheme.lime,
                  foregroundColor: PlannerAppTheme.navy,
                ),
                icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                label: Text(isRunning ? 'Pause preview' : 'Start focus'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const _FocusTip(),
      ],
    );
  }
}

class _FocusTip extends StatelessWidget {
  const _FocusTip();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: colors.surface, borderRadius: const BorderRadius.all(Radius.circular(22))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.lightbulb_outline_rounded, color: colors.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Use this state pattern with your own timer service and lifecycle handling.',
              style: TextStyle(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
