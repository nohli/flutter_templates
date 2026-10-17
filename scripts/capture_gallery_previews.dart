// Native rendering target for generate_gallery_previews.py; never shipped as app code
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/app/app_theme.dart';
import 'package:templates/features/gallery/models/template_gallery_item.dart';
import 'package:templates/features/templates/banking_super_app/banking_home_screen.dart';
import 'package:templates/features/templates/channel_messenger/channel_messenger_home_screen.dart';
import 'package:templates/features/templates/dating_app/dating_home_screen.dart';
import 'package:templates/features/templates/design_course/home_design_course.dart';
import 'package:templates/features/templates/finance_app/finance_home_screen.dart';
import 'package:templates/features/templates/fitness_app/fitness_app_home_screen.dart';
import 'package:templates/features/templates/hotel_booking/hotel_home_screen.dart';
import 'package:templates/features/templates/language_learning/language_learning_home_screen.dart';
import 'package:templates/features/templates/private_messenger/private_messenger_home_screen.dart';
import 'package:templates/features/templates/social_feed/social_feed_home_screen.dart';
import 'package:templates/l10n/localizations.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final endpoint = Uri.parse(const String.fromEnvironment('GALLERY_PREVIEW_ENDPOINT'));
  final requested = const String.fromEnvironment('GALLERY_PREVIEW_LOCALES').split(',').toSet();
  final appearances = const String.fromEnvironment('GALLERY_PREVIEW_APPEARANCES').split(',').toSet();
  final locales = AppLocalizations.supportedLocales.where((locale) => requested.contains(locale.toString())).toList();
  if (endpoint.scheme != 'http' || endpoint.host != '127.0.0.1' || locales.length != requested.length) {
    throw StateError('Use the host gallery preview generator with valid locales');
  }
  if (appearances.isEmpty || !{'light', 'dark'}.containsAll(appearances)) {
    throw StateError('Choose light and/or dark previews');
  }
  final captures = <String>[];
  for (final locale in locales) {
    testWidgets('renders ${locale.toLanguageTag()} gallery previews with native fonts', (tester) async {
      final onError = FlutterError.onError!;
      FlutterError.onError = (details) {
        FlutterError.dumpErrorToConsole(details, forceReport: true);
        onError(details);
      };
      try {
        for (final appearance in [AppAppearance.light, AppAppearance.dark]) {
          if (!appearances.contains(appearance.name)) continue;
          final brightness = appearance == AppAppearance.dark ? Brightness.dark : Brightness.light;
          for (final destination in TemplateGalleryDestination.values) {
            final key = GlobalKey();
            await tester.pumpWidget(
              MaterialApp(
                key: ValueKey('${locale}_${appearance.name}_${destination.name}'),
                debugShowCheckedModeBanner: false,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.build(brightness),
                home: Align(
                  alignment: Alignment.topLeft,
                  child: OverflowBox(
                    alignment: Alignment.topLeft,
                    minWidth: 402,
                    maxWidth: 402,
                    minHeight: 874,
                    maxHeight: 874,
                    child: MediaQuery(
                      data: MediaQueryData(
                        size: const Size(402, 874),
                        padding: const EdgeInsets.only(top: 62, bottom: 34),
                        platformBrightness: brightness,
                        disableAnimations: true,
                      ),
                      child: RepaintBoundary(key: key, child: _screen(destination, appearance)),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(key.currentContext!.l10n.localeName, locale.toString());
            final providers = <ImageProvider>{
              for (final image in tester.widgetList<Image>(find.byType(Image))) image.image,
            };
            for (final box in tester.widgetList<DecoratedBox>(find.byType(DecoratedBox))) {
              final decoration = box.decoration;
              if (decoration is BoxDecoration && decoration.image != null) {
                providers.add(decoration.image!.image);
              }
            }
            await Future.wait(
              providers.map(
                (provider) => precacheImage(provider, key.currentContext!).timeout(const Duration(seconds: 30)),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull, reason: '$locale ${destination.name} ${appearance.name}');
            final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
            expect(boundary.size, const Size(402, 874));
            final image = await boundary.toImage();
            final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
            image.dispose();
            expect(bytes, isNotNull);
            final name = '$locale/${destination.assetName}${appearance == AppAppearance.dark ? '-dark' : ''}.png';
            final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
            try {
              final request = await client.postUrl(endpoint.resolve(name));
              request.headers.contentType = ContentType('image', 'png');
              request.contentLength = bytes!.lengthInBytes;
              request.add(bytes.buffer.asUint8List());
              final response = await request.close().timeout(const Duration(seconds: 30));
              await response.drain<void>();
              expect(response.statusCode, HttpStatus.created, reason: name);
            } finally {
              client.close(force: true);
            }
            captures.add(name);
          }
        }
        binding.reportData = {'captures': captures, 'locales': locales.length};
      } finally {
        FlutterError.onError = onError;
      }
    }, timeout: const Timeout(Duration(minutes: 3)));
  }
}

Widget _screen(TemplateGalleryDestination destination, AppAppearance appearance) => switch (destination) {
  TemplateGalleryDestination.hotelBooking => HotelHomeScreen(appearance: appearance),
  TemplateGalleryDestination.fitness => FitnessAppHomeScreen(appearance: appearance),
  TemplateGalleryDestination.designCourse => DesignCourseHomeScreen(appearance: appearance),
  TemplateGalleryDestination.personalFinance => FinanceHomeScreen(appearance: appearance),
  TemplateGalleryDestination.dating => DatingHomeScreen(appearance: appearance),
  TemplateGalleryDestination.languageLearning => LanguageLearningHomeScreen(appearance: appearance),
  TemplateGalleryDestination.socialFeed => SocialFeedHomeScreen(appearance: appearance),
  TemplateGalleryDestination.bankingSuperApp => BankingHomeScreen(appearance: appearance),
  TemplateGalleryDestination.channelMessenger => ChannelMessengerHomeScreen(appearance: appearance),
  TemplateGalleryDestination.privateMessenger => PrivateMessengerHomeScreen(appearance: appearance),
};
