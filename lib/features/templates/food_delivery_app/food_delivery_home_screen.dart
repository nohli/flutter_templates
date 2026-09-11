import 'package:flutter/material.dart';

import '../shared/template_motion.dart';
import 'food_delivery_app_theme.dart';
import 'models/delivery_section.dart';
import 'models/meal.dart';
import 'sections/delivery_basket_section.dart';
import 'sections/delivery_discover_section.dart';
import 'sections/delivery_order_section.dart';
import 'widgets/delivery_bottom_bar.dart';

class FoodDeliveryHomeScreen extends StatefulWidget {
  const FoodDeliveryHomeScreen({super.key});

  @override
  State<FoodDeliveryHomeScreen> createState() => _FoodDeliveryHomeScreenState();
}

class _FoodDeliveryHomeScreenState extends State<FoodDeliveryHomeScreen> {
  late final _scrollControllers = <DeliverySection, ScrollController>{
    for (final section in DeliverySection.values) section: ScrollController(),
  };
  final _quantities = <String, int>{};
  var _selectedSection = DeliverySection.discover;
  var _selectedCategory = MealCategory.all;
  var _query = '';
  var _isDelivered = false;

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meals = Meal.samples.where(_matchesFilters).toList(growable: false);
    final itemCount = _quantities.values.fold<int>(0, (int sum, int quantity) => sum + quantity);
    final scrollController = _scrollControllers[_selectedSection]!;

    return Theme(
      data: FoodDeliveryAppTheme.build(),
      child: PrimaryScrollController(
        controller: scrollController,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: FoodDeliveryAppTheme.background,
            surfaceTintColor: Colors.transparent,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    tooltip: 'Back to template gallery',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  )
                : null,
            title: const Text('SAVOR', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.8)),
            actions: const <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: Icon(Icons.location_on_rounded, size: 17),
                  label: Text('Home'),
                  backgroundColor: FoodDeliveryAppTheme.surface,
                  side: BorderSide.none,
                ),
              ),
            ],
          ),
          body: TemplateEntrance(
            child: TemplateSectionSwitcher(
              selectedIndex: _selectedSection.index,
              children: <Widget>[
                DeliveryDiscoverSection(
                  meals: meals,
                  selectedCategory: _selectedCategory,
                  scrollController: _scrollControllers[DeliverySection.discover]!,
                  onQueryChanged: (String query) {
                    setState(() {
                      _query = query.trim().toLowerCase();
                    });
                  },
                  onCategorySelected: (MealCategory category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  onAddMeal: _addMeal,
                ),
                DeliveryOrderSection(
                  isDelivered: _isDelivered,
                  scrollController: _scrollControllers[DeliverySection.order]!,
                  onToggle: () {
                    setState(() {
                      _isDelivered = !_isDelivered;
                    });
                  },
                ),
                DeliveryBasketSection(
                  quantities: _quantities,
                  scrollController: _scrollControllers[DeliverySection.basket]!,
                  onAdd: _addMeal,
                  onRemove: _removeMeal,
                  onCheckout: () => _showMessage('Checkout is shown as an interface preview.'),
                ),
              ],
            ),
          ),
          bottomNavigationBar: DeliveryBottomBar(
            selectedSection: _selectedSection,
            itemCount: itemCount,
            onSelected: _selectSection,
          ),
        ),
      ),
    );
  }

  bool _matchesFilters(Meal meal) {
    final matchesCategory = _selectedCategory == MealCategory.all || meal.category == _selectedCategory;
    final matchesQuery =
        _query.isEmpty ||
        meal.name.toLowerCase().contains(_query) ||
        meal.restaurant.toLowerCase().contains(_query) ||
        meal.description.toLowerCase().contains(_query);
    return matchesCategory && matchesQuery;
  }

  void _selectSection(DeliverySection section) {
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

  void _addMeal(Meal meal) {
    setState(() {
      _quantities.update(meal.id, (int quantity) => quantity + 1, ifAbsent: () => 1);
    });
    _showMessage('${meal.name} added to the sample basket.');
  }

  void _removeMeal(Meal meal) {
    final quantity = _quantities[meal.id];
    if (quantity == null) {
      return;
    }
    setState(() {
      if (quantity == 1) {
        _quantities.remove(meal.id);
      } else {
        _quantities[meal.id] = quantity - 1;
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
