import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';
import '../ui_view/wave_view.dart';

class WaterView extends StatefulWidget {
  const WaterView({required this.mainScreenAnimationController, required this.mainScreenAnimation, super.key});

  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  State<WaterView> createState() => _WaterViewState();
}

class _WaterViewState extends State<WaterView> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final stackContent = MediaQuery.textScalerOf(context).scale(1) >= 2;
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, _) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                  child: stackContent
                      ? _buildLargeTextContent(colors)
                      : Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left: 4, bottom: 3),
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
                                            padding: EdgeInsets.only(left: 8, bottom: 8),
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
                                        padding: EdgeInsets.only(left: 4, top: 2, bottom: 14),
                                        child: Text(
                                          'of daily goal 3.5L',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
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
                                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4),
                                              child: Icon(Icons.access_time, color: colors.onSurfaceVariant, size: 16),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 4.0),
                                                child: Text(
                                                  'Last drink 8:26 AM',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    letterSpacing: 0.0,
                                                    color: colors.onSurfaceVariant,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Image.asset('assets/fitness_app/bell.png'),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Your bottle is empty, refill it!.',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: FitnessAppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    letterSpacing: 0.0,
                                                    color: colors.error,
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
                            ),
                            SizedBox(
                              width: 34,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colors.surfaceContainerHighest,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: colors.shadow.withValues(alpha: 0.3),
                                          offset: const Offset(4.0, 4.0),
                                          blurRadius: 8.0,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(Icons.add, color: colors.primary, size: 24),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colors.surfaceContainerHighest,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: colors.shadow.withValues(alpha: 0.3),
                                          offset: const Offset(4.0, 4.0),
                                          blurRadius: 8.0,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(Icons.remove, color: colors.primary, size: 24),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
                              child: Container(
                                width: 60,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: colors.primaryContainer,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(80.0),
                                    bottomLeft: Radius.circular(80.0),
                                    bottomRight: Radius.circular(80.0),
                                    topRight: Radius.circular(80.0),
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: colors.shadow.withValues(alpha: 0.3),
                                      offset: const Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const WaveView(percentageValue: 60.0),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLargeTextContent(ColorScheme colors) {
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Icon(Icons.access_time, color: colors.onSurfaceVariant, size: 16),
            ),
            Expanded(
              child: Text(
                'Last drink 8:26 AM',
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 24, height: 24, child: Image.asset('assets/fitness_app/bell.png')),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Your bottle is empty, refill it!.',
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: colors.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildAdjustmentIcon(colors, Icons.add),
                const SizedBox(height: 28),
                _buildAdjustmentIcon(colors, Icons.remove),
              ],
            ),
            Container(
              width: 176,
              height: 240,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(80)),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: colors.shadow.withValues(alpha: 0.3), offset: const Offset(2, 2), blurRadius: 4),
                ],
              ),
              child: const WaveView(percentageValue: 60.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdjustmentIcon(ColorScheme colors, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(color: colors.shadow.withValues(alpha: 0.3), offset: const Offset(4, 4), blurRadius: 8),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Icon(icon, color: colors.primary, size: 24),
    );
  }
}
