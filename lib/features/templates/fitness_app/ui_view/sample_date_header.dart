import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class SampleDateHeader extends StatelessWidget {
  const SampleDateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final navigationColor = colors.brightness == Brightness.dark ? colors.onSurfaceVariant : FitnessAppTheme.grey;
    final useLargeTextLayout = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final previousDay = SizedBox(height: 38, width: 38, child: Icon(Icons.keyboard_arrow_left, color: navigationColor));
    final nextDay = SizedBox(height: 38, width: 38, child: Icon(Icons.keyboard_arrow_right, color: navigationColor));
    return Semantics(
      label: 'Sample day, 15 May',
      excludeSemantics: true,
      child: useLargeTextLayout
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[previousDay, nextDay]),
                const _SampleDateLabel(expand: true),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                previousDay,
                const Padding(padding: EdgeInsets.only(left: 8, right: 8), child: _SampleDateLabel()),
                nextDay,
              ],
            ),
    );
  }
}

class _SampleDateLabel extends StatelessWidget {
  const _SampleDateLabel({this.expand = false});

  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final navigationColor = colors.brightness == Brightness.dark ? colors.onSurfaceVariant : FitnessAppTheme.grey;
    final label = Text(
      '15 May',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: FitnessAppTheme.fontName,
        fontWeight: FontWeight.normal,
        fontSize: 18,
        letterSpacing: -0.2,
        color: colors.onSurface,
      ),
    );
    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.calendar_today, color: navigationColor, size: 18),
        ),
        if (expand) Expanded(child: label) else label,
      ],
    );
  }
}
