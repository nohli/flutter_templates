import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../finance_formatters.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({required this.balanceIsVisible, required this.onToggleBalance, super.key});

  final bool balanceIsVisible;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final balance = balanceIsVisible ? formatCurrency(context, 24860.20) : '••••••';
    final income = formatCurrency(context, 4200, decimalDigits: 0);
    final spending = formatCurrency(context, -2340, decimalDigits: 0);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final usesLargeText = textScale >= 2;

    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[FinanceAppTheme.primaryDark, FinanceAppTheme.primary],
        ),
        boxShadow: FinanceAppTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Stack(
          children: <Widget>[
            const Positioned(right: -52, top: -78, child: _GlowCircle(size: 190, color: Color(0x2963D7B0))),
            const Positioned(left: -70, bottom: -100, child: _GlowCircle(size: 210, color: Color(0x245F6FFF))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 14, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'Total balance',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(color: Color(0xFFCFD4FF), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        tooltip: balanceIsVisible ? 'Hide balance' : 'Show balance',
                        onPressed: onToggleBalance,
                        icon: Icon(
                          balanceIsVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Semantics(
                    liveRegion: true,
                    label: balanceIsVisible ? 'Balance $balance' : 'Balance hidden',
                    child: ExcludeSemantics(
                      child: AnimatedSwitcher(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 180),
                        child: Text(
                          balance,
                          key: ValueKey<bool>(balanceIsVisible),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _BalanceTrend(),
                  const SizedBox(height: 20),
                  if (usesLargeText)
                    Column(
                      children: <Widget>[
                        _BalanceMetric(label: 'Income', value: '+$income', icon: Icons.south_west_rounded),
                        const SizedBox(height: 12),
                        _BalanceMetric(label: 'Spent', value: spending, icon: Icons.north_east_rounded),
                      ],
                    )
                  else
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _BalanceMetric(label: 'Income', value: '+$income', icon: Icons.south_west_rounded),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _BalanceMetric(label: 'Spent', value: spending, icon: Icons.north_east_rounded),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceTrend extends StatelessWidget {
  const _BalanceTrend();

  @override
  Widget build(BuildContext context) {
    final percentage = formatPercentage(context, 0.124, decimalDigits: 1);

    return Semantics(
      label: 'Balance increased $percentage this month',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0x26FFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.trending_up_rounded, size: 16, color: FinanceAppTheme.mint),
                const SizedBox(width: 5),
                Text(
                  '$percentage this month',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceMetric extends StatelessWidget {
  const _BalanceMetric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        DecoratedBox(
          decoration: const BoxDecoration(color: Color(0x26FFFFFF), shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, size: 17, color: FinanceAppTheme.mint),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, maxLines: 1, style: const TextStyle(color: Color(0xFFCFD4FF), fontSize: 11)),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
