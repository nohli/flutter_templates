import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../finance_formatters.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({required this.balanceIsVisible, required this.onToggleBalance, super.key});

  final bool balanceIsVisible;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final balance = balanceIsVisible ? formatCurrency(context, 24860.20) : '••••••';
    final income = formatCurrency(context, 4200, decimalDigits: 0);
    final spending = formatCurrency(context, -2340, decimalDigits: 0);
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final cardColor = dark ? const Color(0xFF080C13) : FinanceAppTheme.ink;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: FinanceAppTheme.mint.withValues(alpha: 0.32)),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: FinanceAppTheme.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: CustomPaint(painter: _MarketGridPainter())),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _BalanceHeader(balanceIsVisible: balanceIsVisible, onToggleBalance: onToggleBalance),
                const SizedBox(height: 14),
                _BalanceValue(balance: balance, balanceIsVisible: balanceIsVisible),
                const SizedBox(height: 10),
                const _BalanceTrend(),
                const SizedBox(height: 12),
                const _PortfolioSparkline(),
                const SizedBox(height: 14),
                const Divider(color: Color(0x2EFFFFFF), height: 1),
                const SizedBox(height: 14),
                if (usesLargeText)
                  Column(
                    children: <Widget>[
                      _BalanceMetric(label: 'Income', value: '+$income', code: 'IN', positive: true),
                      const SizedBox(height: 12),
                      _BalanceMetric(label: 'Spent', value: spending, code: 'OUT', positive: false),
                    ],
                  )
                else
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _BalanceMetric(label: 'Income', value: '+$income', code: 'IN', positive: true),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _BalanceMetric(label: 'Spent', value: spending, code: 'OUT', positive: false),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader({required this.balanceIsVisible, required this.onToggleBalance});

  final bool balanceIsVisible;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(color: FinanceAppTheme.mint, shape: BoxShape.circle),
          child: SizedBox.square(dimension: 7),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Total balance',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: TextStyle(color: Color(0xFFB9C3D5), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.3),
          ),
        ),
        IconButton(
          tooltip: balanceIsVisible ? 'Hide balance' : 'Show balance',
          onPressed: onToggleBalance,
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Color(0x3DFFFFFF)),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
          ),
          icon: Icon(balanceIsVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 18),
        ),
      ],
    );
  }
}

class _BalanceValue extends StatelessWidget {
  const _BalanceValue({required this.balance, required this.balanceIsVisible});

  final String balance;
  final bool balanceIsVisible;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: balanceIsVisible ? 'Balance $balance' : 'Balance hidden',
      child: ExcludeSemantics(
        child: AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 180),
          child: Text(
            balance,
            key: ValueKey<bool>(balanceIsVisible),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -2,
              height: 0.95,
            ),
          ),
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
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          runSpacing: 4,
          children: <Widget>[
            const Icon(Icons.north_east_rounded, size: 15, color: FinanceAppTheme.mint),
            Text(
              '$percentage this month',
              style: const TextStyle(color: FinanceAppTheme.mint, fontSize: 11, fontWeight: FontWeight.w700),
            ),
            const Text('17:42 UTC', style: TextStyle(color: Color(0xFF7B8598), fontSize: 9, letterSpacing: 0.8)),
          ],
        ),
      ),
    );
  }
}

class _PortfolioSparkline extends StatelessWidget {
  const _PortfolioSparkline();

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return TweenAnimationBuilder<double>(
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 950),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double progress, Widget? child) {
        return SizedBox(
          height: 72,
          width: double.infinity,
          child: CustomPaint(painter: _PortfolioLinePainter(progress: progress)),
        );
      },
    );
  }
}

class _BalanceMetric extends StatelessWidget {
  const _BalanceMetric({required this.label, required this.value, required this.code, required this.positive});

  final String label;
  final String value;
  final String code;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? FinanceAppTheme.mint : FinanceAppTheme.coral;

    return Row(
      children: <Widget>[
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            border: Border.all(color: color.withValues(alpha: 0.38)),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          alignment: Alignment.center,
          child: Text(
            code,
            style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.7),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, maxLines: 1, style: const TextStyle(color: Color(0xFF8F99AB), fontSize: 10)),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MarketGridPainter extends CustomPainter {
  const _MarketGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x10FFFFFF)
      ..strokeWidth = 0.6;
    for (var x = 0.0; x <= size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MarketGridPainter oldDelegate) => false;
}

class _PortfolioLinePainter extends CustomPainter {
  const _PortfolioLinePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final linePath = Path()
      ..moveTo(0, size.height * 0.75)
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.95,
        size.width * 0.22,
        size.height * 0.23,
        size.width * 0.36,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.72,
        size.width * 0.61,
        size.height * 0.18,
        size.width * 0.74,
        size.height * 0.31,
      )
      ..cubicTo(
        size.width * 0.84,
        size.height * 0.42,
        size.width * 0.9,
        size.height * 0.08,
        size.width,
        size.height * 0.15,
      );
    final metric = linePath.computeMetrics().first;
    final visiblePath = metric.extractPath(0, metric.length * progress);
    final fillPath = Path.from(visiblePath)
      ..lineTo(size.width * progress, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[FinanceAppTheme.mint.withValues(alpha: 0.22), Colors.transparent],
      ).createShader(Offset.zero & size);
    final linePaint = Paint()
      ..color = FinanceAppTheme.mint
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawPath(fillPath, fillPaint)
      ..drawPath(visiblePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _PortfolioLinePainter oldDelegate) => oldDelegate.progress != progress;
}
