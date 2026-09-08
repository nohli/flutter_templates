import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app_identity.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('platform targets share the canonical identity and Flutter version source', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    final String appEntryPoint = File('lib/main.dart').readAsStringSync();
    final String iosInfo = File('ios/Runner/Info.plist').readAsStringSync();
    final String iosFrameworkInfo = File('ios/Flutter/AppFrameworkInfo.plist').readAsStringSync();
    final String iosPodfile = File('ios/Podfile').readAsStringSync();
    final String iosProject = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    final String macOSConfig = File('macos/Runner/Configs/AppInfo.xcconfig').readAsStringSync();
    final String androidBuild = File('android/app/build.gradle').readAsStringSync();
    final String androidManifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    final String androidDebugManifest = File('android/app/src/debug/AndroidManifest.xml').readAsStringSync();
    final String androidProfileManifest = File('android/app/src/profile/AndroidManifest.xml').readAsStringSync();
    final String androidActivity = File(
      'android/app/src/main/kotlin/com/achimsapps/templates/MainActivity.kt',
    ).readAsStringSync();
    final String linuxProject = File('linux/CMakeLists.txt').readAsStringSync();
    final String windowsCMake = File('windows/runner/CMakeLists.txt').readAsStringSync();
    final String windowsMetadata = File('windows/runner/Runner.rc').readAsStringSync();
    final String windowsRunner = File('windows/runner/main.cpp').readAsStringSync();
    final String codemagic = File('codemagic.yaml').readAsStringSync();
    final fvmConfig = jsonDecode(File('.fvmrc').readAsStringSync()) as Map<String, dynamic>;

    final RegExpMatch? version = RegExp(r'^version: ([^+\s]+)\+(\d+)$', multiLine: true).firstMatch(pubspec);
    expect(version, isNotNull);
    expect(version!.group(1), isNotEmpty);
    expect(int.parse(version.group(2)!), greaterThan(0));

    expect(iosInfo, contains(r'<string>$(FLUTTER_BUILD_NAME)</string>'));
    expect(iosInfo, contains(r'<string>$(FLUTTER_BUILD_NUMBER)</string>'));
    final String? iPadOrientations = RegExp(
      r'<key>UISupportedInterfaceOrientations~ipad</key>\s*<array>(.*?)</array>',
      dotAll: true,
    ).firstMatch(iosInfo)?.group(1);
    expect(iPadOrientations, isNotNull);
    expect(iPadOrientations, contains('UIInterfaceOrientationPortrait'));
    expect(iPadOrientations, contains('UIInterfaceOrientationPortraitUpsideDown'));
    expect(iPadOrientations, contains('UIInterfaceOrientationLandscapeLeft'));
    expect(iPadOrientations, contains('UIInterfaceOrientationLandscapeRight'));
    expect(appEntryPoint, isNot(contains('setPreferredOrientations')));
    expect(iosProject, contains('com.achimsapps.templates'));
    expect(iosProject, isNot(contains('com.example.templates')));
    expect(iosProject, isNot(contains('MARKETING_VERSION')));
    expect(iosPodfile, contains("platform :ios, '15.0'"));
    expect(RegExp(r'IPHONEOS_DEPLOYMENT_TARGET = 15\.0;').allMatches(iosProject), hasLength(3));
    expect(iosProject, isNot(contains('IPHONEOS_DEPLOYMENT_TARGET = 13.0;')));
    expect(iosFrameworkInfo, contains('<key>MinimumOSVersion</key>\n  <string>15.0</string>'));
    expect(File('ios/Runner/Runner.entitlements').existsSync(), isFalse);
    expect(macOSConfig, contains('PRODUCT_BUNDLE_IDENTIFIER = com.achimsapps.templates'));
    expect(androidBuild, contains('namespace = "com.achimsapps.templates"'));
    expect(androidBuild, contains('applicationId = "com.achimsapps.templates"'));
    expect(androidBuild, contains('compileSdk = flutter.compileSdkVersion'));
    expect(androidBuild, contains('targetSdk = flutter.targetSdkVersion'));
    expect(fvmConfig['flutter'], '3.44.9');
    expect(RegExp(r'flutter: 3\.44\.9').allMatches(codemagic), hasLength(2));
    expect(androidBuild, contains('releaseTaskRequested && !releaseSigningConfigured'));
    expect(androidActivity, contains('package com.achimsapps.templates'));
    expect(androidManifest, isNot(contains('android.permission.INTERNET')));
    expect(androidDebugManifest, contains('android.permission.INTERNET'));
    expect(androidProfileManifest, contains('android.permission.INTERNET'));
    expect(linuxProject, contains('set(APPLICATION_ID "com.achimsapps.templates")'));
    expect(windowsMetadata, contains('VALUE "CompanyName", "com.achimsapps"'));
    expect(windowsCMake, contains(r'FLUTTER_VERSION=\"${FLUTTER_VERSION}\"'));
    for (final component in <String>['MAJOR', 'MINOR', 'PATCH', 'BUILD']) {
      expect(windowsCMake, contains('FLUTTER_VERSION_$component=\${FLUTTER_VERSION_$component}'));
    }
    expect(
      windowsMetadata,
      contains(
        '#define VERSION_AS_NUMBER '
        'FLUTTER_VERSION_MAJOR,FLUTTER_VERSION_MINOR,FLUTTER_VERSION_PATCH,FLUTTER_VERSION_BUILD',
      ),
    );
    expect(windowsMetadata, contains('#define VERSION_AS_STRING FLUTTER_VERSION'));
    expect(iosInfo, contains('<string>${AppIdentity.name}</string>'));
    expect(macOSConfig, contains('PRODUCT_NAME = ${AppIdentity.name}'));
    expect(windowsMetadata, contains('VALUE "ProductName", "${AppIdentity.name}"'));
    expect(windowsMetadata, isNot(contains('com.example')));
    expect(windowsRunner, contains('CreateAndShow(L"${AppIdentity.name}"'));
  });

  test('release workflows are deterministic and keep secrets external', () {
    final YamlMap codemagic = _loadYamlMap('codemagic.yaml');
    final YamlMap workflows = _asYamlMap(codemagic['workflows']);
    expect(workflows.keys, containsAll(<String>['templates-ios', 'templates-android']));
    expect(workflows, hasLength(2));

    for (final workflowCase in <({String buildStep, String id, String platform})>[
      (id: 'templates-ios', platform: 'iOS', buildStep: 'Build IPA'),
      (id: 'templates-android', platform: 'Android', buildStep: 'Build App Bundle'),
    ]) {
      final YamlMap workflow = _asYamlMap(workflows[workflowCase.id]);
      final YamlMap environment = _asYamlMap(workflow['environment']);
      final YamlMap variables = _asYamlMap(environment['vars']);
      final YamlList scripts = _asYamlList(workflow['scripts']);
      final YamlMap buildStep = scripts
          .map(_asYamlMap)
          .singleWhere((YamlMap step) => step['name'] == workflowCase.buildStep);
      final List<Object?> scriptNames = scripts.map(_asYamlMap).map((YamlMap step) => step['name']).toList();
      final getPackagesScript =
          scripts.map(_asYamlMap).singleWhere((YamlMap step) => step['name'] == 'Get Packages')['script'] as String;
      final YamlMap email = _asYamlMap(_asYamlMap(workflow['publishing'])['email']);
      final YamlMap notifications = _asYamlMap(email['notify']);
      final buildScript = buildStep['script'] as String;

      expect(workflow['name'], '${AppIdentity.name} ${workflowCase.platform}');
      expect(environment['flutter'], '3.44.9');
      expect(variables['CM_CLONE_UNSHALLOW'], 'true');
      expect(_asYamlList(environment['groups']), contains('deployment'));
      expect(scriptNames, isNot(contains('Analyze')));
      expect(scriptNames, isNot(contains('Test')));
      expect(getPackagesScript, contains(r'${CODEMAGIC_NOTIFICATION_EMAIL:?'));
      expect(buildScript, contains(r'git rev-parse --is-shallow-repository'));
      expect(buildScript, contains(r'build_number="$(git rev-list --count HEAD)"'));
      expect(buildScript, contains(r'--build-number="$build_number"'));
      expect(buildScript, isNot(contains('--build-name')));
      expect(_asYamlList(email['recipients']), <String>[r'$CODEMAGIC_NOTIFICATION_EMAIL']);
      expect(notifications['success'], isFalse);
      expect(notifications['failure'], isTrue);
    }

    final YamlMap iosEnvironment = _asYamlMap(_asYamlMap(workflows['templates-ios'])['environment']);
    final YamlList iosScripts = _asYamlList(_asYamlMap(workflows['templates-ios'])['scripts']);
    final fetchSigningScript =
        iosScripts.map(_asYamlMap).singleWhere((YamlMap step) => step['name'] == 'Fetch Signing Files')['script']
            as String;
    expect(_asYamlList(iosEnvironment['groups']), <String>['appstore_credentials', 'deployment']);
    final YamlMap iosVariables = _asYamlMap(iosEnvironment['vars']);
    expect(iosVariables.containsKey('APP_STORE_CONNECT_KEY_IDENTIFIER'), isFalse);
    expect(iosVariables.containsKey('APP_STORE_CONNECT_ISSUER_ID'), isFalse);
    expect(iosVariables['BUNDLE_ID'], 'com.achimsapps.templates');
    expect(fetchSigningScript, contains(r'${APP_STORE_CONNECT_KEY_IDENTIFIER:?'));
    expect(fetchSigningScript, contains(r'${APP_STORE_CONNECT_ISSUER_ID:?'));
    expect(fetchSigningScript, contains(r'${APP_STORE_CONNECT_PRIVATE_KEY:?'));
    expect(fetchSigningScript, contains(r'${CERTIFICATE_PRIVATE_KEY:?'));
    final YamlMap iosPublishing = _asYamlMap(_asYamlMap(workflows['templates-ios'])['publishing']);
    final YamlMap appStoreConnect = _asYamlMap(iosPublishing['app_store_connect']);
    expect(appStoreConnect['api_key'], r'$APP_STORE_CONNECT_PRIVATE_KEY');
    expect(appStoreConnect['key_id'], r'$APP_STORE_CONNECT_KEY_IDENTIFIER');
    expect(appStoreConnect['issuer_id'], r'$APP_STORE_CONNECT_ISSUER_ID');
    expect(appStoreConnect['submit_to_testflight'], isTrue);
    expect(_asYamlList(appStoreConnect['beta_groups']), <String>['Tester']);

    final releaseNotes = (jsonDecode(File('release_notes.json').readAsStringSync()) as List<Object?>);
    expect(releaseNotes, <Object?>[
      <String, String>{
        'language': 'en-US',
        'text': "Please explore the app's main flows and report anything confusing, incorrect, or unstable.",
      },
    ]);
    expect(File('release_notes_en-US.txt').existsSync(), isFalse);

    final YamlMap androidWorkflow = _asYamlMap(workflows['templates-android']);
    final YamlMap androidEnvironment = _asYamlMap(androidWorkflow['environment']);
    expect(_asYamlList(androidEnvironment['groups']), contains('google_play_credentials'));
    final YamlMap androidPublishing = _asYamlMap(androidWorkflow['publishing']);
    final YamlMap googlePlay = _asYamlMap(androidPublishing['google_play']);
    expect(googlePlay['credentials'], r'$GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS');
    expect(googlePlay['track'], 'internal');

    final String codemagicSource = File('codemagic.yaml').readAsStringSync();
    expect(codemagicSource, isNot(contains('FCI_CLONE_UNSHALLOW')));
    expect(codemagicSource, isNot(contains('storePassword:')));
    expect(codemagicSource, isNot(contains('keyPassword:')));
    expect(codemagicSource, isNot(contains('BEGIN PRIVATE KEY')));
    expect(File('android/key.properties').existsSync(), isFalse);

    final String gitignore = File('.gitignore').readAsStringSync();
    for (final secretPattern in <String>[
      '.env',
      '*.jks',
      '*.keystore',
      '*.key',
      '*.mobileprovision',
      '*.p12',
      '*.p8',
      '*.pem',
      '*service-account*.json',
      '*service_account*.json',
      '*serviceAccount*.json',
    ]) {
      expect(gitignore, contains(secretPattern));
    }

    for (final workflowFile in <String>[
      '.github/workflows/flutter_build.yml',
      '.github/workflows/flutter_checks.yml',
    ]) {
      final YamlMap workflow = _loadYamlMap(workflowFile);
      final YamlMap triggers = _asYamlMap(workflow['on']);
      expect(triggers.keys, containsAll(<String>['workflow_dispatch', 'pull_request']), reason: workflowFile);
      expect(triggers.containsKey('push'), isFalse, reason: workflowFile);

      final YamlMap jobs = _asYamlMap(workflow['jobs']);
      final expectedJobs = workflowFile.endsWith('flutter_build.yml')
          ? <String>{'build_android', 'build_ios'}
          : <String>{'check_formatting', 'analyze', 'test'};
      expect(jobs.keys.cast<String>().toSet(), expectedJobs, reason: workflowFile);
      for (final Object? jobValue in jobs.values) {
        final YamlList steps = _asYamlList(_asYamlMap(jobValue)['steps']);
        final YamlMap installFlutter = steps
            .map(_asYamlMap)
            .singleWhere((YamlMap step) => step['uses'] == 'subosito/flutter-action@v2');
        expect(_asYamlMap(installFlutter['with'])['flutter-version'], '3.44.9', reason: workflowFile);
      }
      if (workflowFile.endsWith('flutter_checks.yml')) {
        final Iterable<String> commands = jobs.values
            .expand((Object? jobValue) => _asYamlList(_asYamlMap(jobValue)['steps']))
            .map(_asYamlMap)
            .map((YamlMap step) => step['run'])
            .whereType<String>();
        expect(commands, contains('dart format --page-width 120 --output=none --set-exit-if-changed lib test'));
        expect(commands.any((String command) => command.contains('--line-length')), isFalse);
        expect(commands, contains('flutter test --coverage'));
      }
    }
  });

  test('store metadata is factual, bounded, and carries the required trademark notice', () {
    final String appleName = File('store/app-store/en-US/name.txt').readAsStringSync().trim();
    final String appleSubtitle = File('store/app-store/en-US/subtitle.txt').readAsStringSync().trim();
    final String appleDescription = File('store/app-store/en-US/description.txt').readAsStringSync();
    final String playTitle = File('store/google-play/en-US/title.txt').readAsStringSync().trim();
    final String playShortDescription = File('store/google-play/en-US/short_description.txt').readAsStringSync().trim();
    final String playDescription = File('store/google-play/en-US/full_description.txt').readAsStringSync();
    final String applePrivacyPolicyUrl = File('store/app-store/en-US/privacy_policy_url.txt').readAsStringSync().trim();
    final String appleSupportUrl = File('store/app-store/en-US/support_url.txt').readAsStringSync().trim();
    final String playPrivacyPolicyUrl = File('store/google-play/privacy_policy_url.txt').readAsStringSync().trim();
    final String playSupportEmail = File('store/google-play/support_email.txt').readAsStringSync().trim();
    final String playWebsiteUrl = File('store/google-play/website_url.txt').readAsStringSync().trim();

    expect(appleName, AppIdentity.storeName);
    expect(playTitle, AppIdentity.storeName);
    expect(appleName.runes.length, lessThanOrEqualTo(30));
    expect(appleSubtitle.runes.length, lessThanOrEqualTo(30));
    expect(playTitle.runes.length, lessThanOrEqualTo(30));
    expect(playShortDescription.runes.length, lessThanOrEqualTo(80));
    expect(appleDescription, contains(AppIdentity.sampleContentNotice));
    expect(playDescription, contains(AppIdentity.sampleContentNotice));
    expect(appleDescription, contains(AppIdentity.trademarkDisclaimer));
    expect(playDescription, contains(AppIdentity.trademarkDisclaimer));
    expect(appleDescription.toLowerCase(), isNot(contains('testimonial')));
    expect(playDescription.toLowerCase(), isNot(contains('testimonial')));
    expect(applePrivacyPolicyUrl, AppIdentity.privacyPolicyUrl);
    expect(appleSupportUrl, AppIdentity.supportUrl);
    expect(playPrivacyPolicyUrl, AppIdentity.privacyPolicyUrl);
    expect(playSupportEmail, AppIdentity.supportEmail);
    expect(playWebsiteUrl, AppIdentity.supportUrl);
  });

  test('bundled font licenses preserve their exact upstream notices', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    final String workSansLicense = File('assets/fonts/WorkSans-LICENSE.txt').readAsStringSync();
    final String robotoLicense = File('assets/fonts/Roboto-LICENSE.txt').readAsStringSync();
    final String smoothStarRatingLicense = File('assets/licenses/smooth_star_rating-LICENSE.txt').readAsStringSync();

    expect(pubspec, contains('- assets/fonts/WorkSans-LICENSE.txt'));
    expect(pubspec, contains('- assets/fonts/Roboto-LICENSE.txt'));
    expect(pubspec, contains('- assets/licenses/smooth_star_rating-LICENSE.txt'));
    expect(pubspec, contains('- asset: assets/fonts/Roboto-Bold.ttf\n          weight: 700'));
    expect(pubspec, contains('- asset: assets/fonts/Roboto-Medium.ttf\n          weight: 500'));
    expect(workSansLicense, startsWith('Copyright (c) 2014-2015 Wei Huang'));
    expect(workSansLicense, contains('SIL Open Font License v1.1'));
    expect(robotoLicense, startsWith('Copyright 2011 Google Inc. All Rights Reserved.'));
    expect(robotoLicense, contains('Apache License\n                           Version 2.0, January 2004'));
    expect(smoothStarRatingLicense, contains('Copyright (c) 2019 Thangrobul Infimate'));
    expect(smoothStarRatingLicense, contains('The MIT License (MIT)'));
  });

  test('Google Play artwork has exact dimensions and PNG color contracts', () async {
    final ({int bitDepth, int colorType, int height, int width}) playIcon = _readPngHeader('icon/googleplay.png');
    final ({int bitDepth, int colorType, int height, int width}) featureGraphic = _readPngHeader(
      'store/google-play/feature-graphic.png',
    );

    expect(playIcon, (width: 512, height: 512, bitDepth: 8, colorType: 6));
    expect(File('icon/googleplay.png').lengthSync(), lessThanOrEqualTo(1024 * 1024));
    await _expectFullyOpaqueAlpha('icon/googleplay.png');
    expect(featureGraphic, (width: 1024, height: 500, bitDepth: 8, colorType: 2));
  });

  test('store screenshot package contains only current RGB captures at accepted sizes', () {
    const expectedScreenshots = <String, ({int height, int width})>{
      'store/screenshots/app-store/iphone/01-gallery.png': (width: 1284, height: 2778),
      'store/screenshots/app-store/ipad/01-gallery.png': (width: 2064, height: 2752),
      'store/screenshots/google-play/phone/01-gallery.png': (width: 1080, height: 1920),
      'store/screenshots/google-play/phone/02-hotel.png': (width: 1080, height: 1920),
      'store/screenshots/google-play/phone/03-fitness.png': (width: 1080, height: 1920),
      'store/screenshots/google-play/phone/04-design-courses.png': (width: 1080, height: 1920),
      'store/screenshots/google-play/phone/05-course-detail.png': (width: 1080, height: 1920),
    };
    final actualScreenshots = Directory(
      'store/screenshots',
    ).listSync(recursive: true).whereType<File>().map((File file) => file.path).toSet();

    expect(actualScreenshots, expectedScreenshots.keys.toSet());
    for (final MapEntry<String, ({int height, int width})> screenshot in expectedScreenshots.entries) {
      final header = _readPngHeader(screenshot.key);
      expect(header, (
        width: screenshot.value.width,
        height: screenshot.value.height,
        bitDepth: 8,
        colorType: 2,
      ), reason: screenshot.key);
    }
  });

  test('one canonical icon source owns every generated launcher family', () async {
    final YamlMap launcherConfig = _asYamlMap(_loadYamlMap('pubspec.yaml')['flutter_launcher_icons']);
    expect(launcherConfig['image_path'], 'icon/app_icon.png');
    expect(launcherConfig['adaptive_icon_foreground'], 'icon/adaptive_foreground.png');
    expect(_asYamlMap(launcherConfig['web'])['image_path'], 'icon/app_icon.png');
    expect(_asYamlMap(launcherConfig['windows'])['image_path'], 'icon/app_icon.png');
    expect(_asYamlMap(launcherConfig['macos'])['image_path'], 'icon/app_icon.png');
    expect(File('icon/app_icon.png').existsSync(), isTrue);
    expect(File('icon/adaptive_foreground.png').existsSync(), isTrue);
    expect(File('icon/googleplay.png').existsSync(), isTrue);
    expect(File('icon/icon.afphoto').existsSync(), isFalse);
    expect(File('icon/ios.png').existsSync(), isFalse);
    expect(File('icon/android.png').existsSync(), isFalse);
    expect(File('icon/adaptive.png').existsSync(), isFalse);
    const appleIcon = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png';
    expect(_readPngHeader(appleIcon), (width: 1024, height: 1024, bitDepth: 8, colorType: 2));
    await _expectFullyOpaqueAlpha(appleIcon);
    expect(File('android/app/src/main/res/drawable-xxxhdpi/ic_launcher_foreground.png').existsSync(), isTrue);
    expect(File('web/icons/Icon-maskable-512.png').existsSync(), isTrue);
    expect(File('windows/runner/resources/app_icon.ico').existsSync(), isTrue);
  });

  test('startup surfaces keep the adaptive iOS launch and fixed-light platform shells', () {
    final String launchStoryboard = File('ios/Runner/Base.lproj/LaunchScreen.storyboard').readAsStringSync();
    final String mainStoryboard = File('ios/Runner/Base.lproj/Main.storyboard').readAsStringSync();
    final String iosInfo = File('ios/Runner/Info.plist').readAsStringSync();
    final String androidLaunch = File('android/app/src/main/res/drawable/launch_background.xml').readAsStringSync();
    final String androidModernLaunch = File(
      'android/app/src/main/res/drawable-v21/launch_background.xml',
    ).readAsStringSync();
    final String androidNightStyles = File('android/app/src/main/res/values-night/styles.xml').readAsStringSync();
    final String webIndex = File('web/index.html').readAsStringSync();
    final webManifest = jsonDecode(File('web/manifest.json').readAsStringSync()) as Map<String, dynamic>;

    expect(launchStoryboard, contains('<color key="backgroundColor" systemColor="systemBackgroundColor"'));
    expect(launchStoryboard, isNot(contains('<color key="backgroundColor" white="1"')));
    expect(launchStoryboard, isNot(contains('<color key="backgroundColor" red="1" green="1" blue="1"')));
    expect(
      mainStoryboard,
      anyOf(
        contains('<color key="backgroundColor" white="1"'),
        contains('<color key="backgroundColor" red="1" green="1" blue="1"'),
      ),
    );
    expect(mainStoryboard, isNot(contains('systemColor="systemBackgroundColor"')));
    expect(launchStoryboard, isNot(contains('LaunchImage')));
    expect(FileSystemEntity.typeSync('ios/Runner/Assets.xcassets/LaunchImage.imageset'), FileSystemEntityType.notFound);
    expect(iosInfo, isNot(contains('<key>UIUserInterfaceStyle</key>')));
    expect(androidLaunch, contains('@android:color/white'));
    expect(androidModernLaunch, contains('@android:color/white'));
    expect(RegExp(r'parent="@android:style/Theme.Light.NoTitleBar"').allMatches(androidNightStyles), hasLength(2));
    expect(androidNightStyles, isNot(contains('Theme.Black')));
    expect(webIndex, contains('name="color-scheme" content="light"'));
    expect(webIndex, contains('name="theme-color" content="#FEFEFE"'));
    expect(webIndex, isNot(contains('prefers-color-scheme')));
    expect(webManifest['background_color'], '#FEFEFE');
    expect(webManifest.containsKey('orientation'), isFalse);
  });
}

YamlMap _loadYamlMap(String fileName) => _asYamlMap(loadYaml(File(fileName).readAsStringSync()));

YamlMap _asYamlMap(Object? value) {
  expect(value, isA<YamlMap>());
  return value! as YamlMap;
}

YamlList _asYamlList(Object? value) {
  expect(value, isA<YamlList>());
  return value! as YamlList;
}

({int bitDepth, int colorType, int height, int width}) _readPngHeader(String fileName) {
  final Uint8List bytes = File(fileName).readAsBytesSync();
  expect(bytes.take(8), orderedEquals(<int>[137, 80, 78, 71, 13, 10, 26, 10]));
  expect(String.fromCharCodes(bytes.sublist(12, 16)), 'IHDR');
  final data = ByteData.sublistView(bytes);

  return (width: data.getUint32(16), height: data.getUint32(20), bitDepth: bytes[24], colorType: bytes[25]);
}

Future<void> _expectFullyOpaqueAlpha(String fileName) async {
  final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(File(fileName).readAsBytesSync());
  final ui.Codec codec = await ui.instantiateImageCodecFromBuffer(buffer);
  final ui.FrameInfo frame = await codec.getNextFrame();
  final ByteData? pixels = await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
  expect(pixels, isNotNull);
  final Uint8List bytes = pixels!.buffer.asUint8List();
  int? firstNonOpaquePixel;
  for (var alphaIndex = 3; alphaIndex < bytes.length; alphaIndex += 4) {
    final isOpaque = bytes[alphaIndex] == 255;

    if (!isOpaque) {
      firstNonOpaquePixel = (alphaIndex - 3) ~/ 4;
      break;
    }
  }
  expect(firstNonOpaquePixel, isNull, reason: 'Every icon pixel must be fully opaque');
  frame.image.dispose();
  codec.dispose();
}
