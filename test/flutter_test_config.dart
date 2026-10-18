import 'dart:async';
import 'dart:ui' show Locale;

import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/sdf_rounded_rectangle_border.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await SdfRoundedRectangleBorder.initialize();
  await GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  await _loadBundledFonts();
  await testMain();
}

Future<void> _loadBundledFonts() async {
  for (final font in _fonts.entries) {
    final loader = FontLoader(font.key);
    for (final asset in font.value) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }
}

const _fonts = <String, List<String>>{
  'WorkSans': <String>[
    'assets/fonts/WorkSans-Regular.ttf',
    'assets/fonts/WorkSans-Medium.ttf',
    'assets/fonts/WorkSans-SemiBold.ttf',
    'assets/fonts/WorkSans-Bold.ttf',
  ],
  'Roboto': <String>[
    'assets/fonts/Roboto-Regular.ttf',
    'assets/fonts/Roboto-Medium.ttf',
    'assets/fonts/Roboto-Bold.ttf',
  ],
  'BricolageGrotesque': <String>['assets/fonts/BricolageGrotesque.ttf'],
  'Fraunces': <String>['assets/fonts/Fraunces.ttf'],
  'SpaceGrotesk': <String>['assets/fonts/SpaceGrotesk.ttf'],
};
