import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';
import 'animated_fitness_card.dart';

class MediterraneanDietView extends StatelessWidget {
  const MediterraneanDietView({required this.animationController, required this.animation, super.key});

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final useLargeTextLayout = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return AnimatedFitnessCard(
      animation: animation,
      backgroundColor: FitnessAppTheme.white,
      shadowColor: FitnessAppTheme.grey,
      builder: (_) => useLargeTextLayout
          ? _LargeDietSummary(colors: colors, progress: animation.value)
          : _CompactDietSummary(colors: colors, progress: animation.value, macroProgress: animationController.value),
    );
  }
}

class _CompactDietSummary extends StatelessWidget {
  const _CompactDietSummary({required this.colors, required this.progress, required this.macroProgress});

  final ColorScheme colors;
  final double progress;
  final double macroProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CompactEnergyOverview(colors: colors, progress: progress),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              color: FitnessAppTheme.background,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        _CompactMacroSummary(progress: progress, macroProgress: macroProgress),
      ],
    );
  }
}

class _CompactEnergyOverview extends StatelessWidget {
  const _CompactEnergyOverview({required this.colors, required this.progress});

  final ColorScheme colors;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
              child: Column(
                children: <Widget>[
                  _CompactEnergyMetric(
                    label: 'Eaten',
                    value: (1127 * progress).toInt(),
                    imagePath: 'assets/fitness_app/eaten.png',
                    accent: const Color(0xFF87A0E5),
                    unitInset: 4,
                  ),
                  const SizedBox(height: 8),
                  _CompactEnergyMetric(
                    label: 'Burned',
                    value: (102 * progress).toInt(),
                    imagePath: 'assets/fitness_app/burned.png',
                    accent: const Color(0xFFF56E98),
                    unitInset: 8,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _CompactCalorieRing(colors: colors, progress: progress),
          ),
        ],
      ),
    );
  }
}

class _CompactEnergyMetric extends StatelessWidget {
  const _CompactEnergyMetric({
    required this.label,
    required this.value,
    required this.imagePath,
    required this.accent,
    required this.unitInset,
  });

  final String label;
  final int value;
  final String imagePath;
  final Color accent;
  final double unitInset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 48,
          width: 2,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 2),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.1,
                    color: FitnessAppTheme.grey.withValues(alpha: 0.5),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: 28, height: 28, child: Image.asset(imagePath)),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 3),
                      child: Text(
                        '$value',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: FitnessAppTheme.darkerText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: unitInset, bottom: 3),
                      child: Text(
                        'Kcal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: -0.2,
                          color: FitnessAppTheme.grey.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactCalorieRing extends StatelessWidget {
  const _CompactCalorieRing({required this.colors, required this.progress});

  final ColorScheme colors;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                border: Border.all(width: 4, color: FitnessAppTheme.nearlyDarkBlue.withValues(alpha: 0.2)),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${(1503 * progress).toInt()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: FitnessAppTheme.nearlyDarkBlue,
                      ),
                    ),
                    Text(
                      'Kcal left',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: FitnessAppTheme.grey.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: CustomPaint(
              painter: _CalorieRingPainter(
                colors: const <Color>[FitnessAppTheme.nearlyDarkBlue, Color(0xFF8A98E8), Color(0xFF8A98E8)],
                angle: _ringAngle(progress),
                shadowColor: FitnessAppTheme.grey,
                markerColor: FitnessAppTheme.white,
              ),
              child: const SizedBox(width: 108, height: 108),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactMacroSummary extends StatelessWidget {
  const _CompactMacroSummary({required this.progress, required this.macroProgress});

  final double progress;
  final double macroProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _CompactMacroMetric(
              label: 'Carbs',
              remaining: '12g left',
              width: (70 / 1.2) * progress,
              background: const Color(0xFF87A0E5).withValues(alpha: 0.2),
              gradient: LinearGradient(
                colors: <Color>[const Color(0xFF87A0E5), const Color(0xFF87A0E5).withValues(alpha: 0.5)],
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _CompactMacroMetric(
                label: 'Protein',
                remaining: '30g left',
                width: (70 / 2) * macroProgress,
                background: const Color(0xFFF56E98).withValues(alpha: 0.2),
                gradient: LinearGradient(
                  colors: <Color>[const Color(0xFFF56E98).withValues(alpha: 0.1), const Color(0xFFF56E98)],
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _CompactMacroMetric(
                  label: 'Fat',
                  remaining: '10g left',
                  width: (70 / 2.5) * macroProgress,
                  background: const Color(0xFFF1B440).withValues(alpha: 0.2),
                  gradient: LinearGradient(
                    colors: <Color>[const Color(0xFFF1B440).withValues(alpha: 0.1), const Color(0xFFF1B440)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactMacroMetric extends StatelessWidget {
  const _CompactMacroMetric({
    required this.label,
    required this.remaining,
    required this.width,
    required this.background,
    required this.gradient,
  });

  final String label;
  final String remaining;
  final double width;
  final Color background;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: -0.2,
            color: FitnessAppTheme.darkText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 4,
            width: 70,
            decoration: BoxDecoration(color: background, borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Row(
              children: <Widget>[
                Container(
                  width: width,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            remaining,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FitnessAppTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: FitnessAppTheme.grey.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _LargeDietSummary extends StatelessWidget {
  const _LargeDietSummary({required this.colors, required this.progress});

  final ColorScheme colors;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _LargeEnergyMetric(
            colors: colors,
            label: 'Eaten',
            value: (1127 * progress).toInt(),
            imagePath: 'assets/fitness_app/eaten.png',
            accent: const Color(0xFF87A0E5),
          ),
          const SizedBox(height: 16),
          _LargeEnergyMetric(
            colors: colors,
            label: 'Burned',
            value: (102 * progress).toInt(),
            imagePath: 'assets/fitness_app/burned.png',
            accent: const Color(0xFFF56E98),
          ),
          const SizedBox(height: 24),
          _LargeCalorieRing(colors: colors, progress: progress),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Divider(color: colors.outlineVariant),
          ),
          _LargeMacroMetric(
            colors: colors,
            label: 'Carbs',
            remaining: '12g left',
            value: progress / 1.2,
            accent: const Color(0xFF87A0E5),
          ),
          const SizedBox(height: 24),
          _LargeMacroMetric(
            colors: colors,
            label: 'Protein',
            remaining: '30g left',
            value: progress / 2,
            accent: const Color(0xFFF56E98),
          ),
          const SizedBox(height: 24),
          _LargeMacroMetric(
            colors: colors,
            label: 'Fat',
            remaining: '10g left',
            value: progress / 2.5,
            accent: const Color(0xFFF1B440),
          ),
        ],
      ),
    );
  }
}

class _LargeEnergyMetric extends StatelessWidget {
  const _LargeEnergyMetric({
    required this.colors,
    required this.label,
    required this.value,
    required this.imagePath,
    required this.accent,
  });

  final ColorScheme colors;
  final String label;
  final int value;
  final String imagePath;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 4,
          height: 120,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 8,
                runSpacing: 4,
                children: <Widget>[
                  SizedBox(width: 28, height: 28, child: Image.asset(imagePath)),
                  Text(
                    '$value',
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    'Kcal',
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LargeCalorieRing extends StatelessWidget {
  const _LargeCalorieRing({required this.colors, required this.progress});

  final ColorScheme colors;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(width: 4, color: colors.primaryContainer),
              ),
            ),
            CustomPaint(
              painter: _CalorieRingPainter(
                colors: <Color>[colors.primary, const Color(0xFF8A98E8), const Color(0xFF8A98E8)],
                angle: _ringAngle(progress),
                shadowColor: colors.shadow,
                markerColor: colors.surface,
              ),
              child: const SizedBox(width: 208, height: 208),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '${(1503 * progress).toInt()}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.normal,
            fontSize: 24,
            color: colors.primary,
          ),
        ),
        Text(
          'Kcal left',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LargeMacroMetric extends StatelessWidget {
  const _LargeMacroMetric({
    required this.colors,
    required this.label,
    required this.remaining,
    required this.value,
    required this.accent,
  });

  final ColorScheme colors;
  final String label;
  final String remaining;
  final double value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value.clamp(0, 1),
          minHeight: 4,
          color: accent,
          backgroundColor: accent.withValues(alpha: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        const SizedBox(height: 8),
        Text(
          remaining,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CalorieRingPainter extends CustomPainter {
  _CalorieRingPainter({required this.colors, required this.shadowColor, required this.markerColor, this.angle = 140});

  final double angle;
  final List<Color> colors;
  final Color markerColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 7;
    final arc = Rect.fromCircle(center: center, radius: radius);
    final sweepAngle = _radians(360 - (365 - angle));

    for (final (alpha, strokeWidth) in <(double, double)>[(0.4, 14), (0.3, 16), (0.2, 20), (0.1, 22)]) {
      final shadowPaint = Paint()
        ..color = shadowColor.withValues(alpha: alpha)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(arc, _radians(278), sweepAngle, false, shadowPaint);
    }

    final gradient = SweepGradient(
      startAngle: _radians(268),
      endAngle: _radians(630),
      tileMode: TileMode.repeated,
      colors: colors,
    );
    final ringPaint = Paint()
      ..shader = gradient.createShader(Offset.zero & size)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawArc(arc, _radians(278), sweepAngle, false, ringPaint);

    final centerToCircle = size.width / 2;
    final markerPaint = Paint()..color = markerColor;
    canvas
      ..save()
      ..translate(centerToCircle, centerToCircle)
      ..rotate(_radians(angle + 2))
      ..translate(0, -centerToCircle + 7)
      ..drawCircle(Offset.zero, 14 / 5, markerPaint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) {
    return angle != oldDelegate.angle ||
        markerColor != oldDelegate.markerColor ||
        shadowColor != oldDelegate.shadowColor ||
        !listEquals(colors, oldDelegate.colors);
  }
}

double _ringAngle(double progress) => 140 + 220 * (1 - progress);

double _radians(double degrees) => math.pi / 180 * degrees;
