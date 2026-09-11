import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../widgets/storefront_product_card.dart';

class StorefrontShopSection extends StatelessWidget {
  const StorefrontShopSection({
    required this.products,
    required this.selectedCategory,
    required this.savedProductIds,
    required this.scrollController,
    required this.onCategorySelected,
    required this.onQueryChanged,
    required this.onToggleSaved,
    required this.onAddToBag,
    super.key,
  });

  final List<StoreProduct> products;
  final StoreCategory selectedCategory;
  final Set<String> savedProductIds;
  final ScrollController scrollController;
  final ValueChanged<StoreCategory> onCategorySelected;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<StoreProduct> onToggleSaved;
  final ValueChanged<StoreProduct> onAddToBag;

  @override
  Widget build(BuildContext context) {
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      key: const PageStorageKey<String>('storefront-shop'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
          sliver: SliverList.list(
            children: <Widget>[
              const Text(
                'Curated objects for calmer spaces.',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, height: 1.1),
              ),
              const SizedBox(height: 8),
              Text(
                'A tactile storefront made entirely with Flutter widgets.',
                style: TextStyle(color: colors.onSurfaceVariant, height: 1.4),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: onQueryChanged,
                decoration: InputDecoration(
                  hintText: 'Search the collection',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: colors.surface,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (final category in StoreCategory.values) ...<Widget>[
                      ChoiceChip(
                        label: Text(_categoryLabel(category)),
                        selected: selectedCategory == category,
                        showCheckmark: false,
                        onSelected: (_) => onCategorySelected(category),
                      ),
                      if (category != StoreCategory.values.last) const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (products.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No sample products match that search.')),
          )
        else if (usesLargeText)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            sliver: SliverList.separated(
              itemCount: products.length,
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 14),
              itemBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 300, child: _productCard(products[index], horizontal: true)),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            sliver: SliverGrid.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (BuildContext context, int index) => _productCard(products[index]),
            ),
          ),
      ],
    );
  }

  Widget _productCard(StoreProduct product, {bool horizontal = false}) {
    return StorefrontProductCard(
      product: product,
      horizontal: horizontal,
      isSaved: savedProductIds.contains(product.id),
      onToggleSaved: () => onToggleSaved(product),
      onAddToBag: () => onAddToBag(product),
    );
  }

  String _categoryLabel(StoreCategory category) => switch (category) {
    StoreCategory.all => 'All',
    StoreCategory.living => 'Living',
    StoreCategory.audio => 'Audio',
    StoreCategory.wearables => 'Wearables',
  };
}
