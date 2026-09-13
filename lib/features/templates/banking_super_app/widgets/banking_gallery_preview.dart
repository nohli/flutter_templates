import 'package:flutter/material.dart';

import '../banking_app_theme.dart';

class BankingGalleryPreview extends StatelessWidget {
  const BankingGalleryPreview({required this.brightness, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? BankingAppTheme.darkBackground : BankingAppTheme.lightBackground;
    final surface = dark ? BankingAppTheme.darkSurface : BankingAppTheme.lightSurface;
    final ink = dark ? const Color(0xFFF7F4FB) : const Color(0xFF17141C);
    return Semantics(
      image: true,
      label: 'Arc banking app preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: background,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 16,
                  top: 11,
                  child: Text(
                    'arc',
                    style: TextStyle(
                      color: ink,
                      fontFamily: BankingAppTheme.displayFontName,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  top: 38,
                  child: Container(
                    height: 88,
                    padding: const EdgeInsets.all(13),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Color(0xFF31216D), BankingAppTheme.violet, Color(0xFF8C65FF)],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(17),
                        topRight: Radius.circular(17),
                        bottomLeft: Radius.circular(17),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'TOTAL BALANCE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '€8,942.70',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        Spacer(),
                        Text(
                          '+ 4.8% this month',
                          style: TextStyle(color: BankingAppTheme.acid, fontSize: 6, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Row(
                    children: <Widget>[
                      _PreviewCurrency(label: 'EUR', amount: '€8,942', color: BankingAppTheme.acid, ink: ink),
                      const SizedBox(width: 7),
                      _PreviewCurrency(label: 'USD', amount: r'$2,180', color: BankingAppTheme.ice, ink: ink),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: const BorderRadius.all(Radius.circular(11)),
                          ),
                          child: Icon(Icons.north_east_rounded, color: ink, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewCurrency extends StatelessWidget {
  const _PreviewCurrency({required this.label, required this.amount, required this.color, required this.ink});

  final String label;
  final String amount;
  final Color color;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 54,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(13),
          bottomLeft: Radius.circular(13),
          bottomRight: Radius.circular(13),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(color: ink, fontSize: 5, fontWeight: FontWeight.w900),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(color: ink, fontSize: 9, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
