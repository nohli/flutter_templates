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

  IconData get icon => switch (this) {
    AppAppearance.system => Icons.brightness_auto_rounded,
    AppAppearance.light => Icons.light_mode_rounded,
    AppAppearance.dark => Icons.dark_mode_rounded,
  };

  Brightness resolve(BuildContext context) => switch (this) {
    AppAppearance.system => MediaQuery.platformBrightnessOf(context),
    AppAppearance.light => Brightness.light,
    AppAppearance.dark => Brightness.dark,
  };
}

class AppAppearanceButton extends StatelessWidget {
  const AppAppearanceButton({required this.appearance, required this.onChanged, super.key});

  final AppAppearance appearance;
  final ValueChanged<AppAppearance> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppAppearance>(
      tooltip: 'Appearance: ${appearance.label}',
      initialValue: appearance,
      onSelected: onChanged,
      icon: Icon(appearance.icon),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<AppAppearance>>[
        for (final option in AppAppearance.values)
          PopupMenuItem<AppAppearance>(
            value: option,
            child: Row(
              children: <Widget>[
                Icon(option.icon, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(option.label)),
                if (appearance == option) ...<Widget>[
                  const SizedBox(width: 12),
                  const Icon(Icons.check_rounded, size: 20),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
