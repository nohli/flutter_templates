import 'package:flutter/material.dart';

import '../models/social_section.dart';
import '../social_app_theme.dart';

class SocialActionBar extends StatelessWidget {
  const SocialActionBar({required this.selectedSection, required this.onSelected, required this.onCreate, super.key});

  final SocialSection selectedSection;
  final ValueChanged<SocialSection> onSelected;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      elevation: 16,
      shadowColor: Colors.black38,
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colors.outlineVariant)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _SocialDestination(
                label: 'Feed',
                icon: Icons.auto_awesome_mosaic_outlined,
                selectedIcon: Icons.auto_awesome_mosaic_rounded,
                isSelected: selectedSection == SocialSection.feed,
                onPressed: () => onSelected(SocialSection.feed),
              ),
              _SocialDestination(
                label: 'Discover',
                icon: Icons.blur_on_outlined,
                selectedIcon: Icons.blur_on_rounded,
                isSelected: selectedSection == SocialSection.discover,
                onPressed: () => onSelected(SocialSection.discover),
              ),
              _CreateAction(onPressed: onCreate),
              _SocialDestination(
                label: 'Profile',
                icon: Icons.face_6_outlined,
                selectedIcon: Icons.face_6_rounded,
                isSelected: selectedSection == SocialSection.profile,
                onPressed: () => onSelected(SocialSection.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialDestination extends StatelessWidget {
  const _SocialDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: InkResponse(
          radius: 31,
          onTap: onPressed,
          child: AnimatedContainer(
            duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 54,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? colors.primaryContainer : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? colors.onPrimaryContainer : colors.onSurfaceVariant,
              size: isSelected ? 25 : 23,
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateAction extends StatelessWidget {
  const _CreateAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Create post',
      child: Semantics(
        button: true,
        label: 'Create post',
        child: InkResponse(
          radius: 34,
          onTap: onPressed,
          child: Ink(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[SocialAppTheme.primary, SocialAppTheme.coral],
              ),
              borderRadius: BorderRadius.all(Radius.circular(19)),
              boxShadow: <BoxShadow>[BoxShadow(color: Color(0x3D6C5CE7), blurRadius: 16, offset: Offset(0, 7))],
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 29),
          ),
        ),
      ),
    );
  }
}
