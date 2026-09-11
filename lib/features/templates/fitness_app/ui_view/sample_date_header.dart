import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class SampleDateHeader extends StatelessWidget {
  const SampleDateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final useLargeTextLayout = MediaQuery.textScalerOf(context).scale(1) >= 2;
    const previousDay = SizedBox(
      height: 38,
      width: 38,
      child: Icon(Icons.keyboard_arrow_left, color: FitnessAppTheme.grey),
    );
    const nextDay = SizedBox(
      height: 38,
      width: 38,
      child: Icon(Icons.keyboard_arrow_right, color: FitnessAppTheme.grey),
    );
    return Semantics(
      label: 'Sample day, 15 May',
      excludeSemantics: true,
      child: useLargeTextLayout
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[previousDay, nextDay]),
                _SampleDateLabel(expand: true),
              ],
            )
          : const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                previousDay,
                Padding(padding: EdgeInsets.only(left: 8, right: 8), child: _SampleDateLabel()),
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
    const label = Text(
      '15 May',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: FitnessAppTheme.fontName,
        fontWeight: FontWeight.normal,
        fontSize: 18,
        letterSpacing: -0.2,
        color: FitnessAppTheme.darkerText,
      ),
    );
    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.calendar_today, color: FitnessAppTheme.grey, size: 18),
        ),
        if (expand) const Expanded(child: label) else label,
      ],
    );
  }
}
