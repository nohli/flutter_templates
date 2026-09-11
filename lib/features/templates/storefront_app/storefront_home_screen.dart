import 'package:flutter/material.dart';

import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'models/store_product.dart';
import 'models/storefront_section.dart';
import 'sections/storefront_bag_section.dart';
import 'sections/storefront_saved_section.dart';
import 'sections/storefront_shop_section.dart';
import 'storefront_app_theme.dart';
import 'widgets/storefront_section_tabs.dart';

class StorefrontHomeScreen extends StatefulWidget {
  const StorefrontHomeScreen({super.key});

  @override
  State<StorefrontHomeScreen> createState() => _StorefrontHomeScreenState();
}

class _StorefrontHomeScreenState extends State<StorefrontHomeScreen> {
  late final _scrollControllers = <StorefrontSection, ScrollController>{
    for (final section in StorefrontSection.values) section: ScrollController(),
  };

  final _savedProductIds = <String>{};
  final _bagProductIds = <String>[];
  var _selectedSection = StorefrontSection.shop;
  var _selectedCategory = StoreCategory.all;
  var _query = '';

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchingProducts = StoreProduct.samples.where(_matchesFilters).toList(growable: false);
    final savedProducts = StoreProduct.samples
        .where((StoreProduct product) => _savedProductIds.contains(product.id))
        .toList(growable: false);
    final bagProducts = _bagProductIds
        .map((String id) => StoreProduct.samples.firstWhere((StoreProduct product) => product.id == id))
        .toList(growable: false);
    final scrollController = _scrollControllers[_selectedSection]!;

    return TemplateAppearanceShell(
      themeBuilder: StorefrontAppTheme.build,
      builder: (BuildContext context, Widget appearanceButton) {
        return PrimaryScrollController(
          controller: scrollController,
          child: Scaffold(
            appBar: AppBar(
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      tooltip: 'Back to template gallery',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : null,
              titleSpacing: 8,
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Nest', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
                  Text('Objects for everyday', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
                ],
              ),
              actions: <Widget>[appearanceButton, const SizedBox(width: 8)],
            ),
            body: TemplateEntrance(
              child: Column(
                children: <Widget>[
                  StorefrontSectionTabs(
                    selectedSection: _selectedSection,
                    bagItemCount: _bagProductIds.length,
                    onSelected: _selectSection,
                  ),
                  Expanded(
                    child: TemplateSectionSwitcher(
                      selectedIndex: _selectedSection.index,
                      children: <Widget>[
                        StorefrontShopSection(
                          products: matchingProducts,
                          selectedCategory: _selectedCategory,
                          savedProductIds: _savedProductIds,
                          scrollController: _scrollControllers[StorefrontSection.shop]!,
                          onCategorySelected: (StoreCategory category) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          onQueryChanged: (String query) {
                            setState(() {
                              _query = query.trim().toLowerCase();
                            });
                          },
                          onToggleSaved: _toggleSaved,
                          onAddToBag: _addToBag,
                        ),
                        StorefrontSavedSection(
                          products: savedProducts,
                          scrollController: _scrollControllers[StorefrontSection.saved]!,
                          onToggleSaved: _toggleSaved,
                          onAddToBag: _addToBag,
                        ),
                        StorefrontBagSection(
                          products: bagProducts,
                          scrollController: _scrollControllers[StorefrontSection.bag]!,
                          onRemove: _removeFromBag,
                          onCheckout: () => _showMessage('Checkout is shown as an interface preview.'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _matchesFilters(StoreProduct product) {
    final matchesCategory = _selectedCategory == StoreCategory.all || product.category == _selectedCategory;
    final matchesQuery =
        _query.isEmpty ||
        product.name.toLowerCase().contains(_query) ||
        product.description.toLowerCase().contains(_query);
    return matchesCategory && matchesQuery;
  }

  void _selectSection(StorefrontSection section) {
    if (section == _selectedSection) {
      final controller = _scrollControllers[section]!;
      if (controller.hasClients) {
        if (MediaQuery.disableAnimationsOf(context)) {
          controller.jumpTo(0);
        } else {
          controller.animateTo(0, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
        }
      }
      return;
    }
    setState(() {
      _selectedSection = section;
    });
  }

  void _toggleSaved(StoreProduct product) {
    setState(() {
      if (!_savedProductIds.remove(product.id)) {
        _savedProductIds.add(product.id);
      }
    });
  }

  void _addToBag(StoreProduct product) {
    setState(() {
      _bagProductIds.add(product.id);
    });
    _showMessage('${product.name} added to the sample bag.');
  }

  void _removeFromBag(StoreProduct product) {
    setState(() {
      _bagProductIds.remove(product.id);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
