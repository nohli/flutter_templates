import 'dart:convert';
import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart' show GlobalWidgetsLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
import 'package:templates/l10n/localizations.dart';

void main() {
  test('app delegates use the standalone Material and Cupertino libraries', () {
    expect(AppLocalizations.localizationsDelegates, [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ]);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    test('${locale.toLanguageTag()} generated messages match the current catalog', () async {
      final catalog = jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync()) as Map<String, dynamic>;
      final messages = await AppLocalizations.delegate.load(locale);
      expect(messages.home, catalog['home']);
      expect(messages.localeName, locale.toString());
    });
  }
}
