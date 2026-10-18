import 'package:flutter/material.dart';

import 'package:templates/l10n/gen/app_localizations_en.dart';
import 'package:templates/l10n/localizations.dart';

final english = AppLocalizationsEn();

class LocalizedTestApp extends MaterialApp {
  const LocalizedTestApp({
    super.key,
    super.home,
    super.theme,
    super.darkTheme,
    super.themeMode,
    super.themeAnimationDuration,
    super.builder,
    super.locale = const Locale('en'),
    super.navigatorKey,
    super.navigatorObservers,
  }) : super(
         localizationsDelegates: AppLocalizations.localizationsDelegates,
         supportedLocales: AppLocalizations.supportedLocales,
       );
}
