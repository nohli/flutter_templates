import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../storefront_app_theme.dart';
import 'storefront_product_art.dart';

class StorefrontGalleryPreview extends StatelessWidget {
  const StorefrontGalleryPreview({this.brightness = Brightness.light, super.key});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final paper = dark ? StorefrontAppTheme.darkBackground : const Color(0xFFF2E7D6);
    final ink = dark ? StorefrontAppTheme.darkInk : StorefrontAppTheme.ink;
    final panel = dark ? StorefrontAppTheme.darkSurface : StorefrontAppTheme.surface;

    return Semantics(
      excludeSemantics: true,
      image: true,
      label: 'Nest editorial furniture collection preview',
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: 300,
          height: 200,
          child: ColoredBox(
            color: paper,
            child: Stack(
              children: <Widget>[
                const Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 9,
                  child: ColoredBox(color: StorefrontAppTheme.primary),
                ),
                Positioned(
                  left: 24,
                  top: 17,
                  child: Text(
                    'NEST / EDIT 04',
                    style: TextStyle(color: ink, fontSize: 6, fontWeight: FontWeight.w700, letterSpacing: 1.6),
                  ),
                ),
                Positioned(
                  left: 22,
                  top: 48,
                  width: 120,
                  child: Text(
                    'Objects\nwith a\npoint of view.',
                    style: TextStyle(
                      color: ink,
                      fontFamily: StorefrontAppTheme.displayFontName,
                      fontSize: 27,
                      height: 0.78,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Positioned(left: 24, bottom: 20, child: _PriceStamp(ink: ink)),
                Positioned(
                  right: 18,
                  top: 16,
                  bottom: 16,
                  width: 126,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: panel,
                      border: Border.all(color: ink.withValues(alpha: 0.18)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 18, 12, 8),
                      child: StorefrontProductArt(kind: StoreProductKind.chair, compact: true),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 60,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      'FORM / FUNCTION / FEELING',
                      style: TextStyle(color: ink.withValues(alpha: 0.55), fontSize: 5, letterSpacing: 1.2),
                    ),
                  ),
                ),
                const Positioned(right: 105, top: 26, child: _ObjectNumber()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceStamp extends StatelessWidget {
  const _PriceStamp({required this.ink});

  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.07,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: StorefrontAppTheme.sage,
          border: Border.all(color: ink, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(99)),
        ),
        child: Text(
          r'NEST CHAIR  ·  $249',
          style: TextStyle(color: ink, fontSize: 6, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ObjectNumber extends StatelessWidget {
  const _ObjectNumber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      color: StorefrontAppTheme.primary,
      alignment: Alignment.center,
      child: const Text(
        '01',
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
      ),
    );
  }
}
