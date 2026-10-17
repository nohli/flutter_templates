import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../finance_formatters.dart';
import '../models/spending_category.dart';
import 'finance_surface.dart';
import '../../../../l10n/localizations.dart';

class SpendingOverview extends StatelessWidget {
  const SpendingOverview({required this.animation, super.key});

  static const _dailySpending = <double>[0.38, 0.62, 0.46, 0.88, 0.55, 0.72, 0.42];

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final categories = SpendingCategory.samples(context.l10n);
    final weekdays = MaterialLocalizations.of(context).narrowWeekdays;

    return FinanceSurface(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(context.l10n.spending, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(context.l10n.thisMonth, style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
              Text(
                formatCurrency(context, 2340, decimalDigits: 0),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.primary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 104,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List<Widget>.generate(_dailySpending.length, (int index) {
                final fraction = _dailySpending[index];
                final isCurrentDay = index == 4;
                return Expanded(
                  child: _SpendingBar(
                    animation: animation,
                    day: weekdays[(index + 1) % DateTime.daysPerWeek],
                    fraction: fraction,
                    color: isCurrentDay ? colors.primary : colors.primaryContainer,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 22),
          Divider(height: 1, color: colors.outlineVariant),
          const SizedBox(height: 18),
          for (final category in categories) ...<Widget>[
            _CategoryProgress(animation: animation, category: category),
            if (category != categories.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _SpendingBar extends StatelessWidget {
  const _SpendingBar({required this.animation, required this.day, required this.fraction, required this.color});

  final Animation<double> animation;
  final String day;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final growth = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.28, 0.88, curve: Curves.easeOutCubic),
    );
    return Semantics(
      label: context.l10n.valueSpendingValueOfTheDailyMaximum(day, formatPercentage(context, fraction)),
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: growth,
          builder: (BuildContext context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: fraction * growth.value,
                      child: Container(
                        width: 16,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(day, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  const _CategoryProgress({required this.animation, required this.category});

  final Animation<double> animation;
  final SpendingCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(context, category.kind);
    final spent = formatCurrency(context, category.spent, decimalDigits: 0);
    final budget = formatCurrency(context, category.budget, decimalDigits: 0);

    return Semantics(
      label: context.l10n.valueValueSpentOfValueValue(
        category.label,
        spent,
        budget,
        formatPercentage(context, category.progress),
      ),
      child: ExcludeSemantics(
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              alignment: Alignment.center,
              child: Icon(_iconFor(category.kind), size: 19, color: colors.foreground),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(category.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        context.l10n.valueOfValue(spent, budget),
                        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, _) {
                        final progress = Curves.easeOutCubic.transform(animation.value) * category.progress;
                        return LinearProgressIndicator(
                          minHeight: 6,
                          value: progress,
                          color: colors.foreground,
                          backgroundColor: colors.background,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({Color background, Color foreground}) _colorsFor(BuildContext context, SpendingCategoryKind kind) => switch (kind) {
    SpendingCategoryKind.home => (
      background: Theme.of(context).colorScheme.primaryContainer,
      foreground: Theme.of(context).colorScheme.primary,
    ),
    SpendingCategoryKind.food => (background: const Color(0xFFFFE7E2), foreground: FinanceAppTheme.coral),
    SpendingCategoryKind.transport => (background: const Color(0xFFE0F7EF), foreground: const Color(0xFF258E70)),
  };

  IconData _iconFor(SpendingCategoryKind kind) => switch (kind) {
    SpendingCategoryKind.home => Icons.home_rounded,
    SpendingCategoryKind.food => Icons.restaurant_rounded,
    SpendingCategoryKind.transport => Icons.directions_bus_rounded,
  };
}
