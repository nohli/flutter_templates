import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'language_learning_theme.dart';
import 'language_lesson_screen.dart';
import 'widgets/learning_path.dart';

class LanguageLearningHomeScreen extends StatelessWidget {
  const LanguageLearningHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: appearance,
      themeBuilder: LanguageLearningTheme.build,
      builder: (BuildContext context) => const _LearningHome(),
    );
  }
}

class _LearningHome extends StatefulWidget {
  const _LearningHome();

  @override
  State<_LearningHome> createState() => _LearningHomeState();
}

class _LearningHomeState extends State<_LearningHome> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _scrollController,
      child: Scaffold(
        bottomNavigationBar: const _LearningNavigation(),
        body: SafeArea(
          bottom: false,
          child: TemplateEntrance(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  sliver: SliverList.list(
                    children: <Widget>[
                      const _LearningHeader(),
                      const SizedBox(height: 24),
                      const _UnitBanner(),
                      const SizedBox(height: 30),
                      LearningPath(onLessonPressed: _openLesson),
                      const SizedBox(height: 34),
                      const _DailyQuest(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLesson() {
    unawaited(
      Navigator.of(
        context,
      ).push<void>(templatePageRoute<void>(context: context, builder: (_) => const LanguageLessonScreen())),
    );
  }
}

class _LearningHeader extends StatelessWidget {
  const _LearningHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          tooltip: 'Back to template gallery',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: const Text('FR  🇫🇷', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        const Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              children: <Widget>[
                _Score(icon: Icons.local_fire_department_rounded, color: LanguageLearningTheme.coral, value: '12'),
                SizedBox(width: 14),
                _Score(icon: Icons.diamond_rounded, color: LanguageLearningTheme.sky, value: '860'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Score extends StatelessWidget {
  const _Score({required this.icon, required this.color, required this.value});

  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _UnitBanner extends StatelessWidget {
  const _UnitBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 16, 18),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.primary.withValues(alpha: 0.28), blurRadius: 22, offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'SECTION 1 · UNIT 4',
                  style: TextStyle(
                    color: colors.onPrimary.withValues(alpha: 0.78),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Order food with confidence',
                  style: TextStyle(color: colors.onPrimary, fontSize: 23, fontWeight: FontWeight.w800, height: 1.05),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Open unit guide',
            onPressed: () {},
            icon: const Icon(Icons.menu_book_rounded),
          ),
        ],
      ),
    );
  }
}

class _DailyQuest extends StatelessWidget {
  const _DailyQuest();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: const Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: LanguageLearningTheme.mango,
            foregroundColor: Color(0xFF463400),
            child: Icon(Icons.bolt_rounded),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Daily quest', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 3),
                Text('Complete one lesson · 0/1'),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded),
        ],
      ),
    );
  }
}

class _LearningNavigation extends StatelessWidget {
  const _LearningNavigation();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _LearningNavIcon(icon: Icons.route_rounded, label: 'Learn', selected: true),
            _LearningNavIcon(icon: Icons.fitness_center_rounded, label: 'Practice'),
            _LearningNavIcon(icon: Icons.shield_rounded, label: 'Leagues'),
            _LearningNavIcon(icon: Icons.person_rounded, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _LearningNavIcon extends StatelessWidget {
  const _LearningNavIcon({required this.icon, required this.label, this.selected = false});

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant;
    return Semantics(
      label: label,
      selected: selected,
      child: Icon(icon, color: color, size: 28),
    );
  }
}
