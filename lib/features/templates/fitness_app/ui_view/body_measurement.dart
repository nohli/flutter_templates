import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';
import 'animated_fitness_card.dart';

class BodyMeasurementView extends StatelessWidget {
  const BodyMeasurementView({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final useLargeTextLayout = MediaQuery.textScalerOf(context).scale(1) > 1;

    return AnimatedFitnessCard(
      animation: animation,
      backgroundColor: FitnessAppTheme.white,
      shadowColor: FitnessAppTheme.grey,
      builder: (_) =>
          useLargeTextLayout ? _LargeBodyMeasurements(colors: colors) : _CompactBodyMeasurements(colors: colors),
    );
  }
}

class _CompactBodyMeasurements extends StatelessWidget {
  const _CompactBodyMeasurements({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CompactWeightSummary(colors: colors),
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
        const Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
          child: Row(
            children: <Widget>[
              _CompactMeasurement(value: '185 cm', label: 'Height', alignment: Alignment.centerLeft),
              _CompactMeasurement(value: '27.3 BMI', label: 'Overweight'),
              _CompactMeasurement(
                value: '20%',
                label: 'Body fat',
                alignment: Alignment.centerRight,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactWeightSummary extends StatelessWidget {
  const _CompactWeightSummary({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8, top: 16),
            child: Text(
              'Weight',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: -0.1,
                color: FitnessAppTheme.darkText,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 3),
                        child: Text(
                          '206.8',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: FitnessAppTheme.nearlyDarkBlue,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 8),
                        child: Text(
                          'lbs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            letterSpacing: -0.2,
                            color: FitnessAppTheme.nearlyDarkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: _MeasurementMetadata(colors: colors, compact: true)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeasurementMetadata extends StatelessWidget {
  const _MeasurementMetadata({required this.colors, this.compact = false});

  final ColorScheme colors;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final timestampText = Text(
      'Today 8:26 AM',
      textAlign: compact ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontFamily: FitnessAppTheme.fontName,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: compact ? 0 : null,
        color: colors.onSurfaceVariant,
      ),
    );
    final timestamp = Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: compact ? 0 : 4, right: compact ? 0 : 8),
          child: Icon(Icons.access_time, color: colors.onSurfaceVariant, size: 16),
        ),
        if (compact) const SizedBox(width: 4),
        if (compact) Flexible(child: timestampText) else Expanded(child: timestampText),
      ],
    );

    if (!compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          timestamp,
          const SizedBox(height: 8),
          Text(
            'Connected smart scale',
            style: TextStyle(
              fontFamily: FitnessAppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: compact ? 0 : null,
              color: colors.primary,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: timestamp),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 14),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              'Connected smart scale',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: 0,
                color: colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactMeasurement extends StatelessWidget {
  const _CompactMeasurement({
    required this.value,
    required this.label,
    this.alignment = Alignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final String value;
  final String label;
  final Alignment alignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            Text(
              value,
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
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                label,
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
    );
  }
}

class _LargeBodyMeasurements extends StatelessWidget {
  const _LargeBodyMeasurements({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Weight',
            style: TextStyle(
              fontFamily: FitnessAppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: <Widget>[
              Text(
                '206.8',
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  color: colors.primary,
                ),
              ),
              Text(
                'lbs',
                style: TextStyle(
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MeasurementMetadata(colors: colors),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: colors.outlineVariant),
          ),
          _MeasurementMetric(value: '185 cm', label: 'Height', colors: colors),
          const SizedBox(height: 16),
          _MeasurementMetric(value: '27.3 BMI', label: 'Overweight', colors: colors),
          const SizedBox(height: 16),
          _MeasurementMetric(value: '20%', label: 'Body fat', colors: colors),
        ],
      ),
    );
  }
}

class _MeasurementMetric extends StatelessWidget {
  const _MeasurementMetric({required this.value, required this.label, required this.colors});

  final String value;
  final String label;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
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
