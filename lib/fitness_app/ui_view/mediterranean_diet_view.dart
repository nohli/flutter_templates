import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class MediterraneanDietView extends StatelessWidget {
  const MediterraneanDietView({required this.animationController, required this.animation, super.key});

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final useLargeTextLayout = MediaQuery.textScalerOf(context).scale(1) >= 2;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: FitnessAppTheme.grey.withValues(alpha: 0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: useLargeTextLayout
                    ? _buildLargeTextContent(colors)
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF87A0E5).withValues(alpha: 0.5),
                                                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                                                    child: Text(
                                                      'Eaten',
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
                                                        SizedBox(
                                                          width: 28,
                                                          height: 28,
                                                          child: Image.asset('assets/fitness_app/eaten.png'),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 4, bottom: 3),
                                                          child: Text(
                                                            '${(1127 * animation.value).toInt()}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily: FitnessAppTheme.fontName,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                              color: FitnessAppTheme.darkerText,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 4, bottom: 3),
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
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              height: 48,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF56E98).withValues(alpha: 0.5),
                                                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                                                    child: Text(
                                                      'Burned',
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
                                                        SizedBox(
                                                          width: 28,
                                                          height: 28,
                                                          child: Image.asset('assets/fitness_app/burned.png'),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 4, bottom: 3),
                                                          child: Text(
                                                            '${(102 * animation.value).toInt()}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily: FitnessAppTheme.fontName,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                              color: FitnessAppTheme.darkerText,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8, bottom: 3),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Center(
                                    child: Stack(
                                      clipBehavior: Clip.antiAlias,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: colors.surface,
                                              borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                                              border: Border.all(
                                                width: 4,
                                                color: FitnessAppTheme.nearlyDarkBlue.withValues(alpha: 0.2),
                                              ),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    '${(1503 * animation.value).toInt()}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: FitnessAppTheme.fontName,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 24,
                                                      letterSpacing: 0.0,
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
                                                      letterSpacing: 0.0,
                                                      color: FitnessAppTheme.grey.withValues(alpha: 0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CustomPaint(
                                            painter: CurvePainter(
                                              colors: <Color>[
                                                FitnessAppTheme.nearlyDarkBlue,
                                                const Color(0xFF8A98E8),
                                                const Color(0xFF8A98E8),
                                              ],
                                              angle: 140 + (360 - 140) * (1.0 - animation.value),
                                              shadowColor: FitnessAppTheme.grey,
                                              markerColor: FitnessAppTheme.white,
                                            ),
                                            child: const SizedBox(width: 108, height: 108),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.background,
                                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Carbs',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
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
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF87A0E5).withValues(alpha: 0.2),
                                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: (70 / 1.2) * animation.value,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: <Color>[
                                                      const Color(0xFF87A0E5),
                                                      const Color(0xFF87A0E5).withValues(alpha: 0.5),
                                                    ],
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          '12g left',
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
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Protein',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF56E98).withValues(alpha: 0.2),
                                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: (70 / 2) * animationController.value,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: <Color>[
                                                        const Color(0xFFF56E98).withValues(alpha: 0.1),
                                                        const Color(0xFFF56E98),
                                                      ],
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            '30g left',
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
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Fat',
                                            style: TextStyle(
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
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1B440).withValues(alpha: 0.2),
                                                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: (70 / 2.5) * animationController.value,
                                                    height: 4,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: <Color>[
                                                          const Color(0xFFF1B440).withValues(alpha: 0.1),
                                                          const Color(0xFFF1B440),
                                                        ],
                                                      ),
                                                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              '10g left',
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
                                      ),
                                    ],
                                  ),
                                ),
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

  Widget _buildLargeTextContent(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildEnergyMetric(
            colors,
            label: 'Eaten',
            value: (1127 * animation.value).toInt(),
            imagePath: 'assets/fitness_app/eaten.png',
            accent: const Color(0xFF87A0E5),
          ),
          const SizedBox(height: 16),
          _buildEnergyMetric(
            colors,
            label: 'Burned',
            value: (102 * animation.value).toInt(),
            imagePath: 'assets/fitness_app/burned.png',
            accent: const Color(0xFFF56E98),
          ),
          const SizedBox(height: 24),
          Center(
            child: Stack(
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
                  painter: CurvePainter(
                    colors: <Color>[colors.primary, const Color(0xFF8A98E8), const Color(0xFF8A98E8)],
                    angle: 140 + (360 - 140) * (1.0 - animation.value),
                    shadowColor: colors.shadow,
                    markerColor: colors.surface,
                  ),
                  child: const SizedBox(width: 208, height: 208),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${(1503 * animation.value).toInt()}',
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Divider(color: colors.outlineVariant),
          ),
          _buildMacroMetric(
            colors,
            label: 'Carbs',
            remaining: '12g left',
            value: animation.value / 1.2,
            accent: const Color(0xFF87A0E5),
          ),
          const SizedBox(height: 24),
          _buildMacroMetric(
            colors,
            label: 'Protein',
            remaining: '30g left',
            value: animation.value / 2,
            accent: const Color(0xFFF56E98),
          ),
          const SizedBox(height: 24),
          _buildMacroMetric(
            colors,
            label: 'Fat',
            remaining: '10g left',
            value: animation.value / 2.5,
            accent: const Color(0xFFF1B440),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyMetric(
    ColorScheme colors, {
    required String label,
    required int value,
    required String imagePath,
    required Color accent,
  }) {
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

  Widget _buildMacroMetric(
    ColorScheme colors, {
    required String label,
    required String remaining,
    required double value,
    required Color accent,
  }) {
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
          value: value.clamp(0.0, 1.0).toDouble(),
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

class CurvePainter extends CustomPainter {
  CurvePainter({required this.colors, required this.shadowColor, required this.markerColor, this.angle = 140});

  final double angle;
  final List<Color> colors;
  final Color markerColor;
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shadowPaint = Paint()
      ..color = shadowColor.withValues(alpha: 0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final Offset shadowPaintCenter = Offset(size.width / 2, size.height / 2);
    final double shadowPaintRadius = math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    shadowPaint.color = shadowColor.withValues(alpha: 0.3);
    shadowPaint.strokeWidth = 16;
    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    shadowPaint.color = shadowColor.withValues(alpha: 0.2);
    shadowPaint.strokeWidth = 20;
    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    shadowPaint.color = shadowColor.withValues(alpha: 0.1);
    shadowPaint.strokeWidth = 22;
    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final SweepGradient gradient = SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colors,
    );
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      paint,
    );

    final SweepGradient gradient1 = SweepGradient(
      tileMode: TileMode.repeated,
      colors: <Color>[markerColor, markerColor],
    );

    final Paint cPaint = Paint();
    cPaint.shader = gradient1.createShader(rect);
    cPaint.color = markerColor;
    cPaint.strokeWidth = 14 / 2;
    canvas.save();

    final double centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(const Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    final double radian = (math.pi / 180) * degree;
    return radian;
  }
}
