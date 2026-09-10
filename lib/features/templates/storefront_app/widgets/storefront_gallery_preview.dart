import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../storefront_app_theme.dart';
import 'storefront_product_art.dart';

class StorefrontGalleryPreview extends StatelessWidget {
  const StorefrontGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.fill,
      child: SizedBox(width: 214, height: 143, child: _StorefrontPreviewCanvas()),
    );
  }
}

class _StorefrontPreviewCanvas extends StatelessWidget {
  const _StorefrontPreviewCanvas();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: StorefrontAppTheme.background,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Expanded(
                  child: Text('NEST', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                ),
                Icon(Icons.shopping_bag_outlined, size: 15),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: <Widget>[
                  const Expanded(flex: 5, child: StorefrontProductArt(kind: StoreProductKind.chair, compact: true)),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Calm living', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        const Text(
                          'Curated objects',
                          style: TextStyle(fontSize: 8, color: StorefrontAppTheme.mutedInk),
                        ),
                        const Spacer(),
                        Container(
                          height: 18,
                          decoration: const BoxDecoration(
                            color: StorefrontAppTheme.primary,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'SHOP',
                            style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
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
