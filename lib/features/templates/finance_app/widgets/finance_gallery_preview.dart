import 'package:flutter/material.dart';

import '../finance_app_theme.dart';

class FinanceGalleryPreview extends StatelessWidget {
  const FinanceGalleryPreview({this.brightness = Brightness.light, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? const Color(0xFF070A0F) : const Color(0xFF11162A);
    final ink = dark ? const Color(0xFFF8FAFF) : Colors.white;
    final muted = ink.withValues(alpha: 0.55);

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Orbit finance market dashboard preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: background,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(painter: _TerminalGridPainter(color: ink)),
                ),
                const Positioned(
                  left: 16,
                  top: 14,
                  child: Text(
                    'ORBIT / LIVE PORTFOLIO',
                    style: TextStyle(
                      color: FinanceAppTheme.mint,
                      fontFamily: FinanceAppTheme.fontName,
                      fontSize: 6,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 43,
                  child: Text(
                    r'$24,860',
                    style: TextStyle(
                      color: ink,
                      fontFamily: FinanceAppTheme.fontName,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.8,
                      height: 0.9,
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  top: 76,
                  child: Text(
                    '+12.4%  /  THIS MONTH',
                    style: TextStyle(
                      color: muted,
                      fontFamily: FinanceAppTheme.fontName,
                      fontSize: 5.5,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Positioned(left: 12, right: 92, top: 101, bottom: 34, child: _MarketChart()),
                const Positioned(right: 18, top: 31, child: _AssetOrbit()),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 10,
                  child: _Ticker(ink: ink, muted: muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarketChart extends StatelessWidget {
  const _MarketChart();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(painter: _MarketChartPainter());
  }
}

class _AssetOrbit extends StatelessWidget {
  const _AssetOrbit();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 74,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: 0.78,
            strokeWidth: 9,
            color: FinanceAppTheme.primary,
            backgroundColor: Color(0xFF252B40),
          ),
          CircularProgressIndicator(
            value: 0.34,
            strokeWidth: 3,
            color: FinanceAppTheme.mint,
            backgroundColor: Colors.transparent,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'BTC',
                style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w800),
              ),
              Text(
                '42%',
                style: TextStyle(color: FinanceAppTheme.mint, fontSize: 11, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Ticker extends StatelessWidget {
  const _Ticker({required this.ink, required this.muted});

  final Color ink;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ink.withValues(alpha: 0.18))),
      ),
      child: Row(
        children: <Widget>[
          _TickerValue(symbol: 'BTC', value: '+3.8%', color: FinanceAppTheme.amber, ink: ink),
          const Spacer(),
          _TickerValue(symbol: 'ETH', value: '+1.2%', color: FinanceAppTheme.primary, ink: ink),
          const Spacer(),
          _TickerValue(symbol: 'SOL', value: '−0.4%', color: FinanceAppTheme.mint, ink: ink),
          const Spacer(),
          Text('17:42 UTC', style: TextStyle(color: muted, fontSize: 5, letterSpacing: 0.6)),
        ],
      ),
    );
  }
}

class _TickerValue extends StatelessWidget {
  const _TickerValue({required this.symbol, required this.value, required this.color, required this.ink});

  final String symbol;
  final String value;
  final Color color;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(width: 5, height: 5, color: color),
        const SizedBox(width: 4),
        Text(
          symbol,
          style: TextStyle(color: ink, fontSize: 5.5, fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 3),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 5.5, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _TerminalGridPainter extends CustomPainter {
  const _TerminalGridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..strokeWidth = 0.6;
    for (var x = 0.0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TerminalGridPainter oldDelegate) => oldDelegate.color != color;
}

class _MarketChartPainter extends CustomPainter {
  const _MarketChartPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.82)
      ..cubicTo(
        size.width * 0.18,
        size.height,
        size.width * 0.23,
        size.height * 0.3,
        size.width * 0.4,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.58,
        size.height * 0.68,
        size.width * 0.68,
        size.height * 0.05,
        size.width,
        size.height * 0.16,
      );
    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0x5563D7B0), Color(0x0063D7B0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = FinanceAppTheme.mint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.square,
    );
  }

  @override
  bool shouldRepaint(covariant _MarketChartPainter oldDelegate) => false;
}
