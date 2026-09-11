import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../widgets/storefront_product_card.dart';

class StorefrontSavedSection extends StatelessWidget {
  const StorefrontSavedSection({
    required this.products,
    required this.scrollController,
    required this.onToggleSaved,
    required this.onAddToBag,
    super.key,
  });

  final List<StoreProduct> products;
  final ScrollController scrollController;
  final ValueChanged<StoreProduct> onToggleSaved;
  final ValueChanged<StoreProduct> onAddToBag;

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.textScalerOf(context).scale(1) >= 2 ? 300.0 : 176.0;

    return ListView(
      key: const PageStorageKey<String>('storefront-saved'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Saved pieces', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(
          'Keep a shortlist while you shape your space.',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        if (products.isEmpty)
          const _EmptySavedState()
        else
          for (final product in products) ...<Widget>[
            SizedBox(
              height: cardHeight,
              child: StorefrontProductCard(
                product: product,
                horizontal: true,
                isSaved: true,
                onToggleSaved: () => onToggleSaved(product),
                onAddToBag: () => onAddToBag(product),
              ),
            ),
            if (product != products.last) const SizedBox(height: 14),
          ],
      ],
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.favorite_border_rounded, size: 42, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 14),
          const Text('Your shortlist is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Tap a heart in Shop to save a sample product.', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
