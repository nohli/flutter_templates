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
    final content = horizontal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 112, height: 126, child: StorefrontProductArt(kind: product.kind, compact: true)),
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: StorefrontAppTheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(26)),
          boxShadow: StorefrontAppTheme.softShadow,
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: content),
            Positioned(
              right: 4,
              top: 4,
              child: IconButton.filledTonal(
                tooltip: isSaved ? 'Remove ${product.name} from saved items' : 'Save ${product.name}',
                onPressed: onToggleSaved,
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        Text(
          product.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: StorefrontAppTheme.mutedInk, fontSize: 11, height: 1.3),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                formatStorePrice(context, product.price),
                style: const TextStyle(color: StorefrontAppTheme.primary, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            IconButton.filled(
              tooltip: 'Add ${product.name} to bag',
              onPressed: onAddToBag,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
