import 'package:flutter/material.dart';

enum TemplateAppearance {
  system,
  light,
  dark;

  String get label => switch (this) {
    TemplateAppearance.system => 'System',
    TemplateAppearance.light => 'Light',
    TemplateAppearance.dark => 'Dark',
  };

  IconData get icon => switch (this) {
    TemplateAppearance.system => Icons.brightness_auto_rounded,
    TemplateAppearance.light => Icons.light_mode_rounded,
    TemplateAppearance.dark => Icons.dark_mode_rounded,
  };

  Brightness resolve(BuildContext context) => switch (this) {
    TemplateAppearance.system => MediaQuery.platformBrightnessOf(context),
    TemplateAppearance.light => Brightness.light,
    TemplateAppearance.dark => Brightness.dark,
  };
}

typedef TemplateThemeBuilder = ThemeData Function(Brightness brightness);
typedef TemplateContentBuilder = Widget Function(BuildContext context, Widget appearanceButton);

class TemplateAppearanceShell extends StatefulWidget {
  const TemplateAppearanceShell({
    required this.themeBuilder,
    required this.builder,
    this.initialAppearance = TemplateAppearance.light,
    super.key,
  });

  final TemplateThemeBuilder themeBuilder;
  final TemplateContentBuilder builder;
  final TemplateAppearance initialAppearance;

  @override
  State<TemplateAppearanceShell> createState() => _TemplateAppearanceShellState();
}

class _TemplateAppearanceShellState extends State<TemplateAppearanceShell> {
  late var _appearance = widget.initialAppearance;

  @override
  void didUpdateWidget(covariant TemplateAppearanceShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAppearance != widget.initialAppearance) {
      _appearance = widget.initialAppearance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = _appearance.resolve(context);

    return Theme(
      data: widget.themeBuilder(brightness),
      child: Builder(
        builder: (BuildContext themedContext) {
          return widget.builder(
            themedContext,
            TemplateAppearanceButton(
              appearance: _appearance,
              onChanged: (TemplateAppearance appearance) {
                setState(() {
                  _appearance = appearance;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class TemplateAppearanceButton extends StatelessWidget {
  const TemplateAppearanceButton({required this.appearance, required this.onChanged, super.key});

  final TemplateAppearance appearance;
  final ValueChanged<TemplateAppearance> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TemplateAppearance>(
      tooltip: 'Appearance: ${appearance.label}',
      initialValue: appearance,
      onSelected: onChanged,
      icon: Icon(appearance.icon),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TemplateAppearance>>[
        for (final option in TemplateAppearance.values)
          PopupMenuItem<TemplateAppearance>(
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
