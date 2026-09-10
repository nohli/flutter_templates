import 'package:flutter/material.dart';

import '../finance_app_theme.dart';

class FinanceGalleryPreview extends StatelessWidget {
  const FinanceGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FinanceAppTheme.background,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            const Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Finance',
                    maxLines: 1,
                    style: TextStyle(color: FinanceAppTheme.ink, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                _PreviewBadge(),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[FinanceAppTheme.primaryDark, FinanceAppTheme.primary],
                  ),
                ),
                child: const Row(
                  children: <Widget>[
                    Expanded(flex: 5, child: _PreviewBalance()),
                    SizedBox(width: 8),
                    Expanded(flex: 4, child: _PreviewChart()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewBadge extends StatelessWidget {
  const _PreviewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 20,
      decoration: const BoxDecoration(
        color: FinanceAppTheme.lavender,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.account_balance_wallet_rounded, size: 11, color: FinanceAppTheme.primaryDark),
    );
  }
}

class _PreviewBalance extends StatelessWidget {
  const _PreviewBalance();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('BALANCE', style: TextStyle(color: Color(0xFFCFD4FF), fontSize: 7, letterSpacing: 0.6)),
        SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            r'$24,860',
            maxLines: 1,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Spacer(),
        Row(
          children: <Widget>[
            _PreviewPill(color: FinanceAppTheme.mint, width: 28),
            SizedBox(width: 5),
            _PreviewPill(color: FinanceAppTheme.coral, width: 22),
          ],
        ),
      ],
    );
  }
}

class _PreviewChart extends StatelessWidget {
  const _PreviewChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(7, 7, 7, 6),
      decoration: const BoxDecoration(color: Color(0x24FFFFFF), borderRadius: BorderRadius.all(Radius.circular(11))),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'WEEK',
            style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _PreviewBar(heightFactor: 0.45),
                _PreviewBar(heightFactor: 0.72),
                _PreviewBar(heightFactor: 0.58, highlighted: true),
                _PreviewBar(heightFactor: 0.88),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewBar extends StatelessWidget {
  const _PreviewBar({required this.heightFactor, this.highlighted = false});

  final double heightFactor;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: heightFactor,
          child: Container(
            width: 5,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: highlighted ? FinanceAppTheme.mint : const Color(0x99FFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(3)),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 5,
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(3))),
    );
  }
}
