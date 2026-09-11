import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../storefront_app_theme.dart';
import '../storefront_formatters.dart';
import 'storefront_product_art.dart';

class StorefrontProductCard extends StatelessWidget {
  const StorefrontProductCard({
    required this.product,
    required this.isSaved,
    required this.onToggleSaved,
    required this.onAddToBag,
    this.horizontal = false,
    super.key,
  });

  final StoreProduct product;
  final bool isSaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onAddToBag;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final content = horizontal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 112, height: 132, child: StorefrontProductArt(kind: product.kind, compact: true)),
              const SizedBox(width: 16),
              Expanded(
                child: _ProductDetails(product: product, onAddToBag: onAddToBag),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: StorefrontProductArt(kind: product.kind)),
              const SizedBox(height: 12),
              _ProductDetails(product: product, onAddToBag: onAddToBag),
            ],
          );

    return Semantics(
      container: true,
      label: '${product.name}, ${formatStorePrice(context, product.price)}',
      child: AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSaved ? colors.primaryContainer.withValues(alpha: 0.28) : colors.surface,
          border: Border.all(color: isSaved ? colors.primary : colors.outlineVariant, width: isSaved ? 1.5 : 1),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: content),
            Positioned(left: 4, top: 4, child: _ProductNumber(kind: product.kind)),
            Positioned(
              right: 4,
              top: 4,
              child: IconButton.outlined(
                tooltip: isSaved ? 'Remove ${product.name} from saved items' : 'Save ${product.name}',
                onPressed: onToggleSaved,
                style: IconButton.styleFrom(
                  backgroundColor: colors.surface.withValues(alpha: 0.88),
                  side: BorderSide(color: colors.outlineVariant),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                ),
                icon: Icon(isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({required this.product, required this.onAddToBag});

  final StoreProduct product;
  final VoidCallback onAddToBag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: StorefrontAppTheme.displayFontName,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          product.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11, height: 1.3),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                formatStorePrice(context, product.price),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: 'Add ${product.name} to bag',
              onPressed: onAddToBag,
              style: IconButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              icon: const Icon(Icons.arrow_outward_rounded),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductNumber extends StatelessWidget {
  const _ProductNumber({required this.kind});

  final StoreProductKind kind;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: StorefrontAppTheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        child: Text(switch (kind) {
          StoreProductKind.chair => '01',
          StoreProductKind.headphones => '02',
          StoreProductKind.lamp => '03',
          StoreProductKind.watch => '04',
        }, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
