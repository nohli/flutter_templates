import 'package:flutter/material.dart';

import '../../../app/motion_preferences.dart';
import '../shared/template_motion.dart';
import 'finance_app_theme.dart';
import 'models/finance_section.dart';
import 'sections/finance_activity_section.dart';
import 'sections/finance_cards_section.dart';
import 'sections/finance_overview_section.dart';
import 'sections/finance_profile_section.dart';
import 'widgets/finance_bottom_bar.dart';
import 'widgets/finance_top_bar.dart';

class FinanceHomeScreen extends StatefulWidget {
  const FinanceHomeScreen({super.key});

  @override
  State<FinanceHomeScreen> createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> with SingleTickerProviderStateMixin {
  late final _scrollControllers = <FinanceSection, ScrollController>{
    for (final section in FinanceSection.values) section: ScrollController(),
  };

  var _selectedSection = FinanceSection.overview;
  var _balanceIsVisible = true;
  late final _entranceController = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startEntranceAnimation(context, _entranceController);
  }

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final financeTheme = FinanceAppTheme.build();
    final scrollController = _scrollControllers[_selectedSection]!;

    return Theme(
      data: financeTheme,
      child: PrimaryScrollController(
        controller: scrollController,
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: TemplateEntrance(
              child: Column(
                children: <Widget>[
                  FinanceTopBar(title: _titleFor(_selectedSection)),
                  Expanded(
                    child: TemplateSectionSwitcher(
                      selectedIndex: _selectedSection.index,
                      children: <Widget>[
                        FinanceOverviewSection(
                          animation: _entranceController,
                          scrollController: _scrollControllers[FinanceSection.overview]!,
                          balanceIsVisible: _balanceIsVisible,
                          onToggleBalance: () {
                            setState(() {
                              _balanceIsVisible = !_balanceIsVisible;
                            });
                          },
                          onQuickAction: _showPreviewMessage,
                          onViewAllActivity: () => _selectSection(FinanceSection.activity),
                        ),
                        FinanceActivitySection(
                          animation: _entranceController,
                          scrollController: _scrollControllers[FinanceSection.activity]!,
                        ),
                        FinanceCardsSection(
                          animation: _entranceController,
                          scrollController: _scrollControllers[FinanceSection.cards]!,
                        ),
                        FinanceProfileSection(
                          animation: _entranceController,
                          scrollController: _scrollControllers[FinanceSection.profile]!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: FinanceBottomBar(selectedSection: _selectedSection, onSelected: _selectSection),
        ),
      ),
    );
  }

  void _selectSection(FinanceSection section) {
    if (section == _selectedSection) {
      final controller = _scrollControllers[section]!;
      if (controller.hasClients) {
        if (MediaQuery.disableAnimationsOf(context)) {
          controller.jumpTo(0);
        } else {
          controller.animateTo(0, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
        }
      }
      return;
    }

    setState(() {
      _selectedSection = section;
    });
    restartTransitionAnimation(context, _entranceController);
  }

  void _showPreviewMessage(String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$action is shown as an interface preview.')));
  }

  String _titleFor(FinanceSection section) => switch (section) {
    FinanceSection.overview => 'Overview',
    FinanceSection.activity => 'Activity',
    FinanceSection.cards => 'Cards',
    FinanceSection.profile => 'Profile',
  };
}
