import 'dart:math' as math;

import 'package:flutter/material.dart';

enum AppSection { home, help, feedback, invite, about }

class AppDrawer extends StatelessWidget {
  const AppDrawer({required this.selectedSection, required this.drawerAnimation, required this.onSelected, super.key});

  final AppSection selectedSection;
  final Animation<double> drawerAnimation;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Navigation menu',
      container: true,
      explicitChildNodes: true,
      child: ColoredBox(
        color: colors.surface,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: drawerAnimation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: (1 - drawerAnimation.value) * 24 * math.pi / 180,
                          child: Transform.scale(scale: 0.8 + drawerAnimation.value * 0.2, child: child),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: 0.3),
                              offset: const Offset(2, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(60)),
                          child: Image.asset('assets/images/userImage.png', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        'Shaquille Oatmeal',
                        style: TextStyle(fontWeight: FontWeight.w600, color: colors.onSurfaceVariant, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ...AppSection.values.map((AppSection section) {
                return _DrawerItem(
                  section: section,
                  isSelected: section == selectedSection,
                  drawerAnimation: drawerAnimation,
                  onPressed: () => onSelected(section),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.section,
    required this.isSelected,
    required this.drawerAnimation,
    required this.onPressed,
  });

  final AppSection section;
  final bool isSelected;
  final Animation<double> drawerAnimation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selectedForeground = colors.onPrimaryContainer;
    return Semantics(
      selected: isSelected,
      button: true,
      label: section.label,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.grey.withValues(alpha: 0.1),
            highlightColor: Colors.transparent,
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  if (isSelected)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: drawerAnimation,
                        builder: (BuildContext context, Widget? child) {
                          return FractionalTranslation(translation: Offset(drawerAnimation.value - 1, 0), child: child);
                        },
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.78,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(28)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 46),
                      child: Row(
                        children: <Widget>[
                          Icon(section.icon, color: isSelected ? selectedForeground : colors.onSurface),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              section.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: isSelected ? selectedForeground : colors.onSurface,
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
        ),
      ),
    );
  }
}

extension on AppSection {
  String get label => switch (this) {
    AppSection.home => 'Home',
    AppSection.help => 'Help',
    AppSection.feedback => 'Feedback',
    AppSection.invite => 'Invite friends',
    AppSection.about => 'About',
  };

  IconData get icon => switch (this) {
    AppSection.home => Icons.home,
    AppSection.help => Icons.help_outline,
    AppSection.feedback => Icons.chat_bubble_outline,
    AppSection.invite => Icons.group,
    AppSection.about => Icons.info,
  };
}
