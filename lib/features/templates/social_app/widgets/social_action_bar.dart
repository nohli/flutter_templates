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
    return Material(
      color: SocialAppTheme.ink,
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: SocialAppTheme.amber, width: 3)),
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
              color: isSelected ? SocialAppTheme.amber : Colors.transparent,
              border: Border.all(color: isSelected ? SocialAppTheme.amber : const Color(0xFF4B483F)),
            ),
            child: Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? SocialAppTheme.ink : const Color(0xFFFFFBED),
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
              color: SocialAppTheme.coral,
              boxShadow: <BoxShadow>[BoxShadow(color: SocialAppTheme.amber, offset: Offset(5, 5))],
            ),
            child: const Icon(Icons.add_rounded, color: SocialAppTheme.ink, size: 29),
          ),
        ),
      ),
    );
  }
}
