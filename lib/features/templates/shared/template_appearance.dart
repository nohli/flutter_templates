import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';

typedef TemplateThemeBuilder = ThemeData Function(Brightness brightness);
typedef TemplateContentBuilder = Widget Function(BuildContext context);

MaterialPageRoute<T> templatePageRoute<T>({required BuildContext context, required WidgetBuilder builder}) {
  return MaterialPageRoute<T>(builder: (_) => InheritedTheme.captureAll(context, Builder(builder: builder)));
}

class TemplateAppearanceShell extends StatelessWidget {
  const TemplateAppearanceShell({
    required this.appearance,
    required this.themeBuilder,
    required this.builder,
    super.key,
  });

  final AppAppearance appearance;
  final TemplateThemeBuilder themeBuilder;
  final TemplateContentBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeBuilder(appearance.resolve(context)),
      child: Builder(builder: builder),
    );
  }
}
