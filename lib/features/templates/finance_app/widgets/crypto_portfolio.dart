import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../finance_formatters.dart';
import 'finance_surface.dart';

class CryptoPortfolio extends StatelessWidget {
  const CryptoPortfolio({super.key});

  static const _assets = <({String amount, String name, String symbol, Color color})>[
    (symbol: 'BTC', name: 'Bitcoin', amount: '0.083', color: Color(0xFFF59E0B)),
    (symbol: 'ETH', name: 'Ethereum', amount: '1.42', color: Color(0xFF7C8CF8)),
    (symbol: 'SOL', name: 'Solana', amount: '14.8', color: Color(0xFF43D6A2)),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FinanceSurface(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Crypto',
                        style: TextStyle(color: colors.onSurfaceVariant, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatCurrency(context, 8420.16),
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: -0.4),
                      ),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: FinanceAppTheme.mint.withValues(alpha: 0.18),
                    borderRadius: const BorderRadius.all(Radius.circular(99)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.north_east_rounded, size: 14, color: Color(0xFF167A5B)),
                        SizedBox(width: 4),
                        Text(
                          '+8.7%',
                          style: TextStyle(color: Color(0xFF167A5B), fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 88,
            width: double.infinity,
            child: CustomPaint(painter: _CryptoChartPainter()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Row(
              children: <Widget>[
                for (final asset in _assets)
                  Expanded(
                    child: _CryptoAsset(
                      symbol: asset.symbol,
                      name: asset.name,
                      amount: asset.amount,
                      color: asset.color,
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

class _CryptoAsset extends StatelessWidget {
  const _CryptoAsset({required this.symbol, required this.name, required this.amount, required this.color});

  final String symbol;
  final String name;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Semantics(
      label: '$name, $amount $symbol',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
                  child: SizedBox.square(
                    dimension: 28,
                    child: Center(
                      child: Text(
                        symbol.substring(0, 1),
                        style: TextStyle(color: color, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(symbol, style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: muted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _CryptoChartPainter extends CustomPainter {
  const _CryptoChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = FinanceAppTheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[FinanceAppTheme.primary.withValues(alpha: 0.22), Colors.transparent],
      ).createShader(Offset.zero & size);
    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.82,
        size.width * 0.17,
        size.height * 0.34,
        size.width * 0.29,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.64,
        size.width * 0.47,
        size.height * 0.18,
        size.width * 0.59,
        size.height * 0.28,
      )
      ..cubicTo(
        size.width * 0.73,
        size.height * 0.42,
        size.width * 0.8,
        size.height * 0.08,
        size.width,
        size.height * 0.16,
      );
    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas
      ..drawPath(area, fill)
      ..drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant _CryptoChartPainter oldDelegate) => false;
}
