import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'app_drawer.dart';
import 'app_theme.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'home_screen.dart';
import 'invite_friend_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with SingleTickerProviderStateMixin {
  AppSection _section = AppSection.home;
  late final AnimationController _drawerController;
  late final Animation<double> _menuIconAnimation;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      animationBehavior: AnimationBehavior.preserve,
    );
    _menuIconAnimation = ReverseAnimation(_drawerController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) && _drawerController.isAnimating) {
      _drawerController.value = _drawerController.value >= 0.5 ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void _openDrawer() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (MediaQuery.disableAnimationsOf(context)) {
      _drawerController.value = 1;
    } else {
      _drawerController.animateTo(1, curve: Curves.fastOutSlowIn);
    }
  }

  void _closeDrawer() {
    if (MediaQuery.disableAnimationsOf(context)) {
      _drawerController.value = 0;
    } else {
      _drawerController.animateTo(0, curve: Curves.fastOutSlowIn);
    }
  }

  void _toggleDrawer() {
    if (_drawerController.value == 0) {
      _openDrawer();
    } else {
      _closeDrawer();
    }
  }

  void _selectSection(AppSection section) {
    if (section != _section) {
      setState(() {
        _section = section;
      });
    }
    _closeDrawer();
  }

  void _updateDrawerDrag(DragUpdateDetails details, double drawerWidth) {
    _drawerController.value += details.delta.dx / drawerWidth;
  }

  void _endDrawerDrag(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldOpen = velocity > 300 || (velocity >= -300 && _drawerController.value >= 0.5);
    _settleDrawer(shouldOpen: shouldOpen);
  }

  void _cancelDrawerDrag() {
    _settleDrawer(shouldOpen: _drawerController.value >= 0.5);
  }

  void _settleDrawer({required bool shouldOpen}) {
    if (shouldOpen) {
      _openDrawer();
    } else {
      _closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final drawerWidth = constraints.maxWidth * 0.75;
        return AnimatedBuilder(
          animation: _drawerController,
          builder: (BuildContext context, Widget? child) {
            final drawerIsClosed = _drawerController.value == 0;
            return PopScope(
              canPop: drawerIsClosed,
              onPopInvokedWithResult: (bool didPop, Object? result) {
                if (!didPop) {
                  _closeDrawer();
                }
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  _updateDrawerDrag(details, drawerWidth);
                },
                onHorizontalDragEnd: _endDrawerDrag,
                onHorizontalDragCancel: _cancelDrawerDrag,
                child: ClipRect(
                  child: Stack(
                    children: <Widget>[
                      ExcludeSemantics(
                        excluding: drawerIsClosed,
                        child: FocusScope(
                          autofocus: !drawerIsClosed,
                          canRequestFocus: !drawerIsClosed,
                          child: ExcludeFocus(
                            excluding: drawerIsClosed,
                            child: IgnorePointer(
                              ignoring: drawerIsClosed,
                              child: SizedBox(
                                width: drawerWidth,
                                child: AppDrawer(
                                  selectedSection: _section,
                                  drawerAnimation: _drawerController,
                                  onSelected: _selectSection,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(drawerWidth * _drawerController.value, 0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: AppTheme.grey.withValues(alpha: 0.6), blurRadius: 24, spreadRadius: 8),
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: ExcludeSemantics(
                                  excluding: !drawerIsClosed,
                                  child: ExcludeFocus(
                                    excluding: !drawerIsClosed,
                                    child: IgnorePointer(ignoring: !drawerIsClosed, child: _screen),
                                  ),
                                ),
                              ),
                              if (!drawerIsClosed)
                                Positioned.fill(
                                  child: ExcludeSemantics(
                                    child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _closeDrawer),
                                  ),
                                ),
                              SafeArea(
                                bottom: false,
                                minimum: const EdgeInsets.only(top: 8, left: 8),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: SizedBox.square(
                                    dimension: 48,
                                    child: IconButton(
                                      tooltip: drawerIsClosed ? 'Open navigation menu' : 'Close navigation menu',
                                      onPressed: _toggleDrawer,
                                      icon: AnimatedIcon(
                                        icon: AnimatedIcons.arrow_menu,
                                        progress: _menuIconAnimation,
                                        color: AppTheme.nearlyBlack,
                                        semanticLabel: drawerIsClosed
                                            ? 'Open navigation menu'
                                            : 'Close navigation menu',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget get _screen => switch (_section) {
    AppSection.home => const MyHomePage(),
    AppSection.help => const HelpScreen(),
    AppSection.feedback => const FeedbackScreen(),
    AppSection.invite => const InviteFriend(),
    AppSection.about => const AboutScreen(),
  };
}
