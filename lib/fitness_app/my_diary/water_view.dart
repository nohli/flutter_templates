import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';
import '../ui_view/animated_fitness_card.dart';
import '../ui_view/wave_view.dart';

class WaterView extends StatelessWidget {
  const WaterView({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final useLargeTextLayout = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return AnimatedFitnessCard(
      animation: animation,
      backgroundColor: colors.surfaceContainerLow,
      shadowColor: colors.shadow,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: useLargeTextLayout ? _LargeWaterContent(colors: colors) : _CompactWaterContent(colors: colors),
      ),
    );
  }
}

class _CompactWaterContent extends StatelessWidget {
  const _CompactWaterContent({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _CompactWaterSummary(colors: colors)),
        SizedBox(width: 34, child: _WaterAdjustmentButtons(colors: colors)),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
          child: _WaterBottle(colors: colors, width: 60, height: 160),
        ),
      ],
    );
  }
}

class _CompactWaterSummary extends StatelessWidget {
  const _CompactWaterSummary({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 3),
                  child: Text(
                    '2100',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: colors.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(
                    'ml',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      letterSpacing: -0.2,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2, bottom: 14),
              child: Text(
                'of daily goal 3.5L',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0,
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 16),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: colors.outlineVariant,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _WaterStatus(colors: colors, compact: true),
        ),
      ],
    );
  }
}

class _LargeWaterContent extends StatelessWidget {
  const _LargeWaterContent({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 8,
          runSpacing: 4,
          children: <Widget>[
            Text(
              '2100',
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w600,
                fontSize: 32,
                color: colors.primary,
              ),
            ),
            Text(
              'ml',
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: colors.primary,
              ),
            ),
          ],
        ),
        Text(
          'of daily goal 3.5L',
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: colors.onSurface,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(color: colors.outlineVariant),
        ),
        _WaterStatus(colors: colors),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _WaterAdjustmentButtons(colors: colors),
            _WaterBottle(colors: colors, width: 176, height: 240),
          ],
        ),
      ],
    );
  }
}

class _WaterStatus extends StatelessWidget {
  const _WaterStatus({required this.colors, this.compact = false});

  final ColorScheme colors;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: compact ? CrossAxisAlignment.end : CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: compact ? 4 : 0, top: compact ? 0 : 8, right: compact ? 0 : 8),
              child: Icon(Icons.access_time, color: colors.onSurfaceVariant, size: 16),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: compact ? 4 : 0),
                child: Text(
                  'Last drink 8:26 AM',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: compact ? 0 : null,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: compact ? 4 : 8),
        Row(
          crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 24, height: 24, child: Image.asset('assets/fitness_app/bell.png')),
            if (!compact) const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Your bottle is empty, refill it!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  letterSpacing: compact ? 0 : null,
                  color: colors.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WaterAdjustmentButtons extends StatelessWidget {
  const _WaterAdjustmentButtons({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _AdjustmentIcon(colors: colors, icon: Icons.add),
        const SizedBox(height: 28),
        _AdjustmentIcon(colors: colors, icon: Icons.remove),
      ],
    );
  }
}

class _AdjustmentIcon extends StatelessWidget {
  const _AdjustmentIcon({required this.colors, required this.icon});

  final ColorScheme colors;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.shadow.withValues(alpha: 0.3), offset: const Offset(4, 4), blurRadius: 8),
        ],
      ),
      child: Icon(icon, color: colors.primary, size: 24),
    );
  }
}

class _WaterBottle extends StatelessWidget {
  const _WaterBottle({required this.colors, required this.width, required this.height});

  final ColorScheme colors;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(80)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.shadow.withValues(alpha: 0.3), offset: const Offset(2, 2), blurRadius: 4),
        ],
      ),
      child: const WaveView(percentageValue: 60),
    );
  }
}
