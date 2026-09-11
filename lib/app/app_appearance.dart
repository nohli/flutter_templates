import 'package:flutter/material.dart';

enum AppAppearance {
  system,
  light,
  dark;

  String get label => switch (this) {
    AppAppearance.system => 'System',
    AppAppearance.light => 'Light',
    AppAppearance.dark => 'Dark',
  };

  Brightness resolve(BuildContext context) => switch (this) {
    AppAppearance.system => MediaQuery.platformBrightnessOf(context),
    AppAppearance.light => Brightness.light,
    AppAppearance.dark => Brightness.dark,
  };

  IconData icon(BuildContext context) => switch (resolve(context)) {
    Brightness.light => Icons.light_mode_rounded,
    Brightness.dark => Icons.dark_mode_rounded,
  };
}

class AppAppearanceButton extends StatelessWidget {
  const AppAppearanceButton({required this.appearance, required this.onChanged, super.key});

  final AppAppearance appearance;
  final ValueChanged<AppAppearance> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MenuAnchor(
      useRootOverlay: true,
      consumeOutsideTap: true,
      animated: true,
      alignmentOffset: const Offset(0, 6),
      style: MenuStyle(
        alignment: AlignmentDirectional.bottomEnd,
        backgroundColor: WidgetStatePropertyAll(colors.surface),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(colors.shadow.withValues(alpha: 0.22)),
        elevation: const WidgetStatePropertyAll(12),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(6)),
        fixedSize: const WidgetStatePropertyAll(Size.fromWidth(196)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
        ),
      ),
      menuChildren: <Widget>[
        for (final option in AppAppearance.values)
          MenuItemButton(
            key: ValueKey<String>('appearance-${option.name}'),
            onPressed: () => onChanged(option),
            leadingIcon: _AppearanceOptionIcon(option: option, selected: appearance == option),
            trailingIcon: SizedBox.square(
              dimension: 20,
              child: appearance == option ? Icon(Icons.check_rounded, color: colors.primary, size: 19) : null,
            ),
            style: ButtonStyle(
              minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
              foregroundColor: WidgetStatePropertyAll(colors.onSurface),
              backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
              overlayColor: WidgetStatePropertyAll(colors.primary.withValues(alpha: 0.08)),
              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            child: Text(
              option.label,
              style: TextStyle(
                color: appearance == option ? colors.primary : colors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          tooltip: 'Appearance: ${appearance.label}',
          onPressed: controller.isOpen ? controller.close : controller.open,
          style: IconButton.styleFrom(
            foregroundColor: colors.onSurface,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          ),
          icon: AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 180),
            transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Icon(appearance.icon(context), key: ValueKey<IconData>(appearance.icon(context)), size: 21),
          ),
        );
      },
    );
  }
}

class _AppearanceOptionIcon extends StatelessWidget {
  const _AppearanceOptionIcon({required this.option, required this.selected});

  final AppAppearance option;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 30,
      child: Icon(option.icon(context), color: selected ? colors.primary : colors.onSurfaceVariant, size: 19),
    );
  }
}
