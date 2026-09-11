import 'package:flutter/material.dart';

import '../models/store_product.dart';
import '../storefront_app_theme.dart';
import '../widgets/storefront_product_art.dart';
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

    return CustomScrollView(
      key: const PageStorageKey<String>('storefront-shop'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          sliver: SliverList.list(
            children: <Widget>[
              const _EditorialHero(),
              const SizedBox(height: 18),
              _CollectionControls(
                selectedCategory: selectedCategory,
                onCategorySelected: onCategorySelected,
                onQueryChanged: onQueryChanged,
              ),
              const SizedBox(height: 18),
              const _CollectionHeading(),
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
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.69,
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
}

class _EditorialHero extends StatelessWidget {
  const _EditorialHero();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    if (MediaQuery.textScalerOf(context).scale(1) >= 2) {
      return const _LargeTextEditorialHero();
    }

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1B1712) : const Color(0xFFF1E4CF),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 10, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Curated objects for calmer spaces.',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1),
                  ),
                  const Spacer(),
                  const Text(
                    'Objects\nwith a\npoint of view.',
                    style: TextStyle(
                      fontFamily: StorefrontAppTheme.displayFontName,
                      fontSize: 37,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.8,
                      height: 0.76,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Form / function / feeling',
                    style: TextStyle(color: colors.onSurfaceVariant, fontSize: 9, letterSpacing: 0.8),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ColoredBox(color: dark ? const Color(0xFF32251F) : StorefrontAppTheme.blush),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: StorefrontProductArt(kind: StoreProductKind.chair),
                ),
                const Positioned(
                  left: 0,
                  top: 0,
                  child: ColoredBox(
                    color: StorefrontAppTheme.primary,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '01',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeTextEditorialHero extends StatelessWidget {
  const _LargeTextEditorialHero();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1B1712) : const Color(0xFFF1E4CF),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Curated objects for calmer spaces.',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const SizedBox(height: 18),
            const Text(
              'Objects with a point of view.',
              style: TextStyle(
                fontFamily: StorefrontAppTheme.displayFontName,
                fontSize: 28,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.4,
                height: 0.92,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Form / function / feeling',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 9, letterSpacing: 0.8),
            ),
            const SizedBox(height: 18),
            const SizedBox(height: 180, child: _LargeTextHeroArt()),
          ],
        ),
      ),
    );
  }
}

class _LargeTextHeroArt extends StatelessWidget {
  const _LargeTextHeroArt();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ColoredBox(color: dark ? const Color(0xFF32251F) : StorefrontAppTheme.blush),
        const Padding(
          padding: EdgeInsets.all(20),
          child: StorefrontProductArt(kind: StoreProductKind.chair),
        ),
        const Positioned(
          left: 0,
          top: 0,
          child: ColoredBox(
            color: StorefrontAppTheme.primary,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '01',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionControls extends StatelessWidget {
  const _CollectionControls({
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onQueryChanged,
  });

  final StoreCategory selectedCategory;
  final ValueChanged<StoreCategory> onCategorySelected;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Search the collection',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Center(
                widthFactor: 1,
                child: Text('INDEX', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
              ),
            ),
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: colors.outlineVariant),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.outlineVariant),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final category in StoreCategory.values) ...<Widget>[
                ChoiceChip(
                  label: Text(_categoryLabel(category)),
                  selected: selectedCategory == category,
                  showCheckmark: false,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                  onSelected: (_) => onCategorySelected(category),
                ),
                if (category != StoreCategory.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _categoryLabel(StoreCategory category) => switch (category) {
    StoreCategory.all => 'All',
    StoreCategory.living => 'Living',
    StoreCategory.audio => 'Audio',
    StoreCategory.wearables => 'Wearables',
  };
}

class _CollectionHeading extends StatelessWidget {
  const _CollectionHeading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'THE COLLECTION',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5),
          ),
        ),
        Text('04 OBJECTS', style: TextStyle(fontSize: 9, letterSpacing: 1)),
      ],
    );
  }
}
