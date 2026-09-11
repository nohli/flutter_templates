import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app_identity.dart';
import 'app/app_shell.dart';
import 'app/app_theme.dart';
import 'app/font_licenses.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: AppTheme.build(),
      themeMode: ThemeMode.light,
      home: const Scaffold(body: AppShell()),
    );
  }
}
