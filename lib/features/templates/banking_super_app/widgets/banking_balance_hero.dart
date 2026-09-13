import 'package:flutter/material.dart';

import '../banking_app_theme.dart';

class BankingBalanceHero extends StatelessWidget {
  const BankingBalanceHero({required this.balanceVisible, required this.onToggleVisibility, super.key});

  final bool balanceVisible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF31216D), BankingAppTheme.violet, Color(0xFF8C65FF)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0x405537D8), blurRadius: 30, offset: Offset(0, 16))],
      ),
      child: Stack(
        children: <Widget>[
          const Positioned(right: -36, top: -58, child: _BalanceOrbit()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'TOTAL BALANCE',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: balanceVisible ? 'Hide balance' : 'Show balance',
                    onPressed: onToggleVisibility,
                    color: Colors.white,
                    icon: Icon(balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: Text(
                        balanceVisible ? '€8,942.70' : '€••••••',
                        key: ValueKey<bool>(balanceVisible),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: const BoxDecoration(
                      color: BankingAppTheme.acid,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Text(
                      '+ 4.8% this month',
                      style: TextStyle(color: Color(0xFF263000), fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '•• 8042',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceOrbit extends StatelessWidget {
  const _BalanceOrbit();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(dimension: 150, child: CustomPaint(painter: _BalanceOrbitPainter()));
  }
}

class _BalanceOrbitPainter extends CustomPainter {
  const _BalanceOrbitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fill = Paint()..color = Colors.white.withValues(alpha: 0.08);
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(center, 65, fill);
    canvas.drawCircle(center, 46, line);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.23), 8, Paint()..color = BankingAppTheme.acid);
  }

  @override
  bool shouldRepaint(covariant _BalanceOrbitPainter oldDelegate) => false;
}
