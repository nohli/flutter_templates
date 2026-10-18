import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app_identity.dart';
import 'app/app_shell.dart';
import 'app/app_theme.dart';
import 'app/font_licenses.dart';
import 'app/sdf_rounded_rectangle_border.dart';
import 'l10n/localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SdfRoundedRectangleBorder.initialize();
  registerBundledFontLicenses();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const UiTemplatesApp());
}

class UiTemplatesApp extends StatelessWidget {
  const UiTemplatesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppIdentity.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    );
  }
}
