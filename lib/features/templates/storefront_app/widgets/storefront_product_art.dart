import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../storefront_app_theme.dart';

class StorefrontProductArt extends StatelessWidget {
  const StorefrontProductArt({required this.kind, this.compact = false, super.key});

  final StoreProductKind kind;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(kind);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: BorderRadius.all(Radius.circular(compact ? 18 : 24)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            right: compact ? -14 : -24,
            top: compact ? -16 : -28,
            child: Container(
              width: compact ? 58 : 92,
              height: compact ? 58 : 92,
              decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
            ),
          ),
          Icon(_iconFor(kind), size: compact ? 38 : 64, color: StorefrontAppTheme.ink),
        ],
      ),
    );
  }

  List<Color> _colorsFor(StoreProductKind kind) => switch (kind) {
    StoreProductKind.chair => const <Color>[Color(0xFFF2DCCF), StorefrontAppTheme.blush],
    StoreProductKind.headphones => const <Color>[Color(0xFFDDE8DE), StorefrontAppTheme.sage],
    StoreProductKind.lamp => const <Color>[Color(0xFFF7E7C9), StorefrontAppTheme.sand],
    StoreProductKind.watch => const <Color>[Color(0xFFE1DDED), Color(0xFFBDB4D2)],
  };

  IconData _iconFor(StoreProductKind kind) => switch (kind) {
    StoreProductKind.chair => Icons.chair_alt_rounded,
    StoreProductKind.headphones => Icons.headphones_rounded,
    StoreProductKind.lamp => Icons.light_rounded,
    StoreProductKind.watch => Icons.watch_rounded,
  };
}
