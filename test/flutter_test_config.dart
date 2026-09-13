import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
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
  'BricolageGrotesque': <String>['assets/fonts/BricolageGrotesque.ttf'],
  'Fraunces': <String>['assets/fonts/Fraunces.ttf'],
  'SpaceGrotesk': <String>['assets/fonts/SpaceGrotesk.ttf'],
};
