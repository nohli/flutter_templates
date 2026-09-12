import 'package:flutter/material.dart';

import '../food_delivery_app_theme.dart';
import '../models/meal.dart';
import 'meal_art.dart';

class DeliveryGalleryPreview extends StatelessWidget {
  const DeliveryGalleryPreview({this.brightness = Brightness.light, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark ? const Color(0xFF17120E) : const Color(0xFFF04D2F);
    final paper = dark ? const Color(0xFF2B211A) : const Color(0xFFFFF2D5);
    final ink = dark ? const Color(0xFFFFF4E9) : FoodDeliveryAppTheme.ink;
    final titleColor = dark ? ink : paper;

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Savor illustrated food delivery menu preview',
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
                  child: CustomPaint(painter: _PicnicPainter(color: paper)),
                ),
                Positioned(
                  left: 14,
                  top: 13,
                  child: Text(
                    'SAVOR!',
                    style: TextStyle(
                      color: titleColor,
                      fontFamily: FoodDeliveryAppTheme.fontName,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                Positioned(
                  left: 17,
                  top: 46,
                  width: 78,
                  child: Text(
                    'A VERY GOOD\nLUNCH IS\nCOMING.',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Positioned(
                  left: 102,
                  top: 14,
                  bottom: 14,
                  width: 142,
                  child: Transform.rotate(
                    angle: -0.045,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: paper,
                        border: Border.all(color: ink, width: 1.2),
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(18, 12, 18, 22),
                        child: MealArt(kind: MealKind.bowl, compact: true),
                      ),
                    ),
                  ),
                ),
                Positioned(right: 28, bottom: 22, child: _MealCaption(ink: ink)),
                Positioned(right: 17, top: 19, child: _DeliveryStamp(ink: ink)),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: _TimeTicket(paper: paper, ink: ink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MealCaption extends StatelessWidget {
  const _MealCaption({required this.ink});

  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Text(
      r'SUNSET BOWL  ·  $14',
      style: TextStyle(color: ink, fontSize: 6, fontWeight: FontWeight.w900, letterSpacing: 0.5),
    );
  }
}

class _DeliveryStamp extends StatelessWidget {
  const _DeliveryStamp({required this.ink});

  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.12,
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: FoodDeliveryAppTheme.yellow,
          shape: BoxShape.circle,
          border: Border.all(color: ink),
        ),
        alignment: Alignment.center,
        child: Text(
          'FRESH\n& FAST',
          textAlign: TextAlign.center,
          style: TextStyle(color: ink, fontSize: 5, fontWeight: FontWeight.w900, height: 1.05),
        ),
      ),
    );
  }
}

class _TimeTicket extends StatelessWidget {
  const _TimeTicket({required this.paper, required this.ink});

  final Color paper;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: paper, borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: <Widget>[
          Icon(Icons.delivery_dining_rounded, size: 11, color: ink),
          const SizedBox(width: 5),
          Text(
            '18 MIN',
            style: TextStyle(color: ink, fontSize: 6, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _PicnicPainter extends CustomPainter {
  const _PicnicPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.09);
    for (var x = -size.height; x < size.width; x += 26) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 12, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PicnicPainter oldDelegate) => oldDelegate.color != color;
}
