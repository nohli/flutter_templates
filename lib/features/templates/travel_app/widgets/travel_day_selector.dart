import 'package:flutter/material.dart';

import '../models/travel_day.dart';

class TravelDaySelector extends StatelessWidget {
  const TravelDaySelector({required this.days, required this.selectedIndex, required this.onSelected, super.key});

  final List<TravelDay> days;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

    return SizedBox(
      height: usesLargeText ? 230 : 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          final day = days[index];
          return _DayButton(
            day: day,
            isSelected: selectedIndex == index,
            usesLargeText: usesLargeText,
            onPressed: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({required this.day, required this.isSelected, required this.usesLargeText, required this.onPressed});

  final TravelDay day;
  final bool isSelected;
  final bool usesLargeText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${day.weekday} ${day.date}',
      child: InkWell(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: usesLargeText ? 150 : 72,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface,
            border: Border.all(color: isSelected ? colors.primary : colors.outlineVariant, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                day.weekday,
                style: TextStyle(
                  color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                day.date,
                style: TextStyle(
                  color: isSelected ? colors.onPrimary : colors.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
