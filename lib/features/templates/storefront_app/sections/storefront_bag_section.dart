import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../storefront_app_theme.dart';
import '../storefront_formatters.dart';
import '../widgets/storefront_product_art.dart';

class StorefrontBagSection extends StatelessWidget {
  const StorefrontBagSection({
    required this.products,
    required this.scrollController,
    required this.onRemove,
    required this.onCheckout,
    super.key,
  });

  final List<StoreProduct> products;
  final ScrollController scrollController;
  final ValueChanged<StoreProduct> onRemove;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final total = products.fold<double>(0, (double sum, StoreProduct product) => sum + product.price);

    return ListView(
      key: const PageStorageKey<String>('storefront-bag'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Your bag', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(
          products.isEmpty
              ? 'Add a sample product to see the checkout pattern.'
              : '${products.length} sample ${products.length == 1 ? 'item' : 'items'}',
          style: const TextStyle(color: StorefrontAppTheme.mutedInk),
        ),
        const SizedBox(height: 20),
        if (products.isEmpty)
          const _EmptyBagState()
        else ...<Widget>[
          Container(
            decoration: const BoxDecoration(
              color: StorefrontAppTheme.surface,
              borderRadius: BorderRadius.all(Radius.circular(28)),
              boxShadow: StorefrontAppTheme.softShadow,
            ),
            child: Column(
              children: <Widget>[
                for (final product in products) ...<Widget>[
                  _BagRow(product: product, onRemove: () => onRemove(product)),
                  if (product != products.last)
                    const Padding(
                      padding: EdgeInsets.only(left: 92),
                      child: Divider(height: 1, color: StorefrontAppTheme.divider),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: StorefrontAppTheme.ink,
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text('Sample total', style: TextStyle(color: Color(0xFFD8D1C6))),
                    ),
                    Text(
                      formatStorePrice(context, total),
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onCheckout,
                    style: FilledButton.styleFrom(
                      backgroundColor: StorefrontAppTheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Preview checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _BagRow extends StatelessWidget {
  const _BagRow({required this.product, required this.onRemove});

  final StoreProduct product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          SizedBox(width: 68, height: 68, child: StorefrontProductArt(kind: product.kind, compact: true)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  formatStorePrice(context, product.price),
                  style: const TextStyle(color: StorefrontAppTheme.primary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove ${product.name} from bag',
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _EmptyBagState extends StatelessWidget {
  const _EmptyBagState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: const BoxDecoration(
        color: StorefrontAppTheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: const Column(
        children: <Widget>[
          Icon(Icons.shopping_bag_outlined, size: 44, color: StorefrontAppTheme.primary),
          SizedBox(height: 14),
          Text('Your bag is ready', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 6),
          Text('Choose a product in Shop to try the cart flow.', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
