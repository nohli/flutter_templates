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
  'ArchivoBlack': <String>['assets/fonts/ArchivoBlack-Regular.ttf'],
  'Anybody': <String>['assets/fonts/Anybody.ttf'],
  'BricolageGrotesque': <String>['assets/fonts/BricolageGrotesque.ttf'],
  'DMSerifDisplay': <String>['assets/fonts/DMSerifDisplay-Regular.ttf'],
  'Fraunces': <String>['assets/fonts/Fraunces.ttf'],
  'InstrumentSerif': <String>['assets/fonts/InstrumentSerif-Regular.ttf'],
  'SpaceGrotesk': <String>['assets/fonts/SpaceGrotesk.ttf'],
  'Syne': <String>['assets/fonts/Syne.ttf'],
  'Unbounded': <String>['assets/fonts/Unbounded.ttf'],
};
