import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_identity.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('platform targets share the canonical identity and Flutter version source', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final appEntryPoint = File('lib/main.dart').readAsStringSync();
    final iosInfo = File('ios/Runner/Info.plist').readAsStringSync();
    final iosProject = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    final iosScheme = File('ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme').readAsStringSync();
    final iosWorkspace = File('ios/Runner.xcworkspace/contents.xcworkspacedata').readAsStringSync();
    final iosDebugConfig = File('ios/Flutter/Debug.xcconfig').readAsStringSync();
    final iosReleaseConfig = File('ios/Flutter/Release.xcconfig').readAsStringSync();
    final macOSConfig = File('macos/Runner/Configs/AppInfo.xcconfig').readAsStringSync();
    final macOSProject = File('macos/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    final macOSScheme = File('macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme').readAsStringSync();
    final macOSWorkspace = File('macos/Runner.xcworkspace/contents.xcworkspacedata').readAsStringSync();
    final macOSDebugConfig = File('macos/Flutter/Flutter-Debug.xcconfig').readAsStringSync();
    final macOSReleaseConfig = File('macos/Flutter/Flutter-Release.xcconfig').readAsStringSync();
    final androidBuild = File('android/app/build.gradle').readAsStringSync();
    final androidManifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    final androidDebugManifest = File('android/app/src/debug/AndroidManifest.xml').readAsStringSync();
    final androidProfileManifest = File('android/app/src/profile/AndroidManifest.xml').readAsStringSync();
    final androidActivity = File(
      'android/app/src/main/kotlin/com/achimsapps/templates/MainActivity.kt',
    ).readAsStringSync();
    final linuxProject = File('linux/CMakeLists.txt').readAsStringSync();
    final windowsCMake = File('windows/runner/CMakeLists.txt').readAsStringSync();
    final windowsMetadata = File('windows/runner/Runner.rc').readAsStringSync();
    final windowsRunner = File('windows/runner/main.cpp').readAsStringSync();
    final codemagic = File('codemagic.yaml').readAsStringSync();
    final fvmConfig = jsonDecode(File('.fvmrc').readAsStringSync()) as Map<String, dynamic>;

    final version = RegExp(r'^version: ([^+\s]+)\+(\d+)$', multiLine: true).firstMatch(pubspec);
    expect(version, isNotNull);
    expect(version!.group(1), isNotEmpty);
    expect(int.parse(version.group(2)!), greaterThan(0));

    expect(iosInfo, contains(r'<string>$(FLUTTER_BUILD_NAME)</string>'));
    expect(iosInfo, contains(r'<string>$(FLUTTER_BUILD_NUMBER)</string>'));
    final iPadOrientations = RegExp(
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
    expect(File('ios/Podfile').existsSync(), isFalse);
    expect(File('ios/Podfile.lock').existsSync(), isFalse);
    expect(iosProject, contains('FlutterGeneratedPluginSwiftPackage'));
    expect(iosProject, isNot(contains('Pods')));
    expect(iosScheme, contains('Run Prepare Flutter Framework Script'));
    expect(iosScheme, contains('xcode_backend.sh&quot; prepare'));
    expect(iosWorkspace, isNot(contains('Pods/Pods.xcodeproj')));
    expect(iosDebugConfig, isNot(contains('Pods/')));
    expect(iosReleaseConfig, isNot(contains('Pods/')));
    expect(RegExp(r'IPHONEOS_DEPLOYMENT_TARGET = 15\.0;').allMatches(iosProject), hasLength(3));
    expect(iosProject, isNot(contains('IPHONEOS_DEPLOYMENT_TARGET = 13.0;')));
    expect(File('ios/Runner/Runner.entitlements').existsSync(), isFalse);
    expect(macOSConfig, contains('PRODUCT_BUNDLE_IDENTIFIER = com.achimsapps.templates'));
    expect(macOSConfig, contains('PRODUCT_COPYRIGHT = Copyright © UI Templates contributors.'));
    expect(File('macos/Podfile').existsSync(), isFalse);
    expect(File('macos/Podfile.lock').existsSync(), isFalse);
    expect(macOSProject, contains('FlutterGeneratedPluginSwiftPackage'));
    expect(macOSProject, isNot(contains('Pods')));
    expect(RegExp(r'MACOSX_DEPLOYMENT_TARGET = 12\.0;').allMatches(macOSProject), hasLength(3));
    expect(
      RegExp(
        r'PBXShellScriptBuildPhase;[^}]*alwaysOutOfDate = 1;[^}]*macos_assemble\.sh && touch',
        dotAll: true,
      ).hasMatch(macOSProject),
      isTrue,
    );
    expect(macOSScheme, contains('Run Prepare Flutter Framework Script'));
    expect(macOSScheme, contains('macos_assemble.sh prepare'));
    expect(macOSWorkspace, isNot(contains('Pods/Pods.xcodeproj')));
    expect(macOSDebugConfig, isNot(contains('Pods/')));
    expect(macOSReleaseConfig, isNot(contains('Pods/')));
    expect(androidBuild, contains('namespace = "com.achimsapps.templates"'));
    expect(androidBuild, contains('applicationId = "com.achimsapps.templates"'));
    expect(androidBuild, contains('compileSdk = flutter.compileSdkVersion'));
    expect(androidBuild, contains('targetSdk = flutter.targetSdkVersion'));
    expect(fvmConfig['flutter'], 'stable');
    expect(RegExp(r'flutter: stable').allMatches(codemagic), hasLength(3));
    expect(codemagic, contains('android_signing:\n        - Keystore'));
    expect(androidBuild, contains('releaseTaskRequested && !releaseSigningConfigured'));
    expect(androidActivity, contains('package com.achimsapps.templates'));
    expect(androidManifest, isNot(contains('android.permission.INTERNET')));
    expect(androidDebugManifest, contains('android.permission.INTERNET'));
    expect(androidProfileManifest, contains('android.permission.INTERNET'));
    expect(linuxProject, contains('set(APPLICATION_ID "com.achimsapps.templates")'));
    expect(windowsMetadata, contains('VALUE "CompanyName", "UI Templates contributors"'));
    expect(windowsMetadata, contains('VALUE "LegalCopyright", "Copyright (C) UI Templates contributors."'));
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
    final codemagic = _loadYamlMap('codemagic.yaml');
    final workflows = _asYamlMap(codemagic['workflows']);
    expect(workflows.keys, unorderedEquals(<String>['ios', 'android', 'web']));
    expect(workflows, hasLength(3));

    for (final MapEntry<Object?, Object?> workflowEntry in workflows.entries) {
      final workflow = _asYamlMap(workflowEntry.value);
      final triggering = _asYamlMap(workflow['triggering']);

      expect(triggering['cancel_previous_builds'], isTrue, reason: '${workflowEntry.key}');
      if (workflowEntry.key == 'ios') {
        final branchPatterns = _asYamlList(triggering['branch_patterns']).map(_asYamlMap).toList();
        expect(_asYamlList(triggering['events']), <String>['push']);
        expect(branchPatterns, hasLength(1));
        expect(branchPatterns.single['pattern'], 'main');
        expect(branchPatterns.single['include'], isTrue);
        expect(branchPatterns.single['source'], isTrue);
      } else {
        expect(triggering['events'], isNull, reason: '${workflowEntry.key} must be manual-only');
        expect(triggering['branch_patterns'], isNull, reason: '${workflowEntry.key} must be manual-only');
      }
    }

    for (final workflowCase in <({String buildStep, String id})>[
      (id: 'ios', buildStep: 'Build IPA'),
      (id: 'android', buildStep: 'Build App Bundle'),
    ]) {
      final workflow = _asYamlMap(workflows[workflowCase.id]);
      final environment = _asYamlMap(workflow['environment']);
      final variables = _asYamlMap(environment['vars']);
      final scripts = _asYamlList(workflow['scripts']);
      final buildStep = scripts.map(_asYamlMap).singleWhere((YamlMap step) => step['name'] == workflowCase.buildStep);
      final scriptNames = scripts.map(_asYamlMap).map((YamlMap step) => step['name']).toList();
      final getPackagesScript =
          scripts.map(_asYamlMap).singleWhere((YamlMap step) => step['name'] == 'Get Packages')['script'] as String;
      final publishing = _asYamlMap(workflow['publishing']);
      final buildScript = buildStep['script'] as String;

      expect(workflow['name'], workflowCase.id);
      expect(environment['flutter'], 'stable');
      expect(variables['CM_CLONE_UNSHALLOW'], 'true');
      if (workflowCase.id == 'ios') {
        expect(environment['groups'], isNull);
      } else {
        expect(_asYamlList(environment['groups']), <String>['google_play_credentials']);
      }
      expect(scriptNames, isNot(contains('Analyze')));
      expect(scriptNames, isNot(contains('Test')));
      expect(getPackagesScript, isNot(contains('CODEMAGIC_NOTIFICATION_EMAIL')));
      expect(buildScript, contains(r'git rev-parse --is-shallow-repository'));
      expect(buildScript, contains(r'build_number="$(git rev-list --count HEAD)"'));
      expect(buildScript, contains(r'--build-number="$build_number"'));
      expect(buildScript, isNot(contains('--build-name')));
      expect(publishing, isNot(contains('email')));
      _expectFailureOnlySlackPublishing(publishing);
    }

    final iosWorkflow = _asYamlMap(workflows['ios']);
    final iosIntegrations = _asYamlMap(iosWorkflow['integrations']);
    final iosEnvironment = _asYamlMap(_asYamlMap(workflows['ios'])['environment']);
    final iosSigning = _asYamlMap(iosEnvironment['ios_signing']);
    expect(iosIntegrations['app_store_connect'], 'Codemagic');
    expect(iosEnvironment['xcode'], 'latest');
    expect(iosSigning['distribution_type'], 'app_store');
    expect(iosSigning['bundle_identifier'], 'com.achimsapps.templates');
    final iosScripts = _asYamlList(_asYamlMap(workflows['ios'])['scripts']);
    final applySigningScript =
        iosScripts.map(_asYamlMap).singleWhere((YamlMap step) => step['name'] == 'Apply Signing Profiles')['script']
            as String;
    expect(applySigningScript, 'xcode-project use-profiles --project ios/Runner.xcodeproj');
    final iosPublishing = _asYamlMap(_asYamlMap(workflows['ios'])['publishing']);
    final appStoreConnect = _asYamlMap(iosPublishing['app_store_connect']);
    expect(appStoreConnect['auth'], 'integration');
    expect(appStoreConnect['submit_to_testflight'], isTrue);
    expect(_asYamlList(appStoreConnect['beta_groups']), <String>['Tester']);

    final releaseNotes = (jsonDecode(File('release_notes.json').readAsStringSync()) as List<Object?>);
    expect(releaseNotes, <Object?>[
      <String, String>{
        'language': 'en-US',
        'text':
            '• Thanks for testing UI Templates.\n'
            '• Please explore the whole app.\n'
            '• Feel free to send any feedback through the app’s Feedback action.',
      },
    ]);
    expect(File('release_notes_en-US.txt').existsSync(), isFalse);

    final androidWorkflow = _asYamlMap(workflows['android']);
    final androidEnvironment = _asYamlMap(androidWorkflow['environment']);
    expect(_asYamlList(androidEnvironment['groups']), contains('google_play_credentials'));
    final androidPublishing = _asYamlMap(androidWorkflow['publishing']);
    final googlePlay = _asYamlMap(androidPublishing['google_play']);
    expect(googlePlay['credentials'], r'$GOOGLE_PLAY_SERVICE_ACCOUNT_CREDENTIALS');
    expect(googlePlay['track'], 'internal');

    final webWorkflow = _asYamlMap(workflows['web']);
    final webEnvironment = _asYamlMap(webWorkflow['environment']);
    final webScripts = _asYamlList(webWorkflow['scripts']).map(_asYamlMap).toList();
    expect(webWorkflow['name'], 'web');
    expect(webEnvironment['flutter'], 'stable');
    expect(_asYamlList(webEnvironment['groups']), <String>['cloudflare_credentials']);
    expect(webScripts.map((YamlMap step) => step['name']), <String>['Get Packages', 'Build Web', 'Publish Web']);
    expect(
      webScripts.singleWhere((YamlMap step) => step['name'] == 'Get Packages')['script'],
      contains('flutter pub get'),
    );
    expect(
      webScripts.singleWhere((YamlMap step) => step['name'] == 'Build Web')['script'],
      'flutter build web --release',
    );
    final webPublishing = _asYamlMap(webWorkflow['publishing']);
    expect(webPublishing, isNot(contains('email')));
    _expectFailureOnlySlackPublishing(webPublishing);

    final codemagicSource = File('codemagic.yaml').readAsStringSync();
    expect(codemagicSource, isNot(contains('FCI_CLONE_UNSHALLOW')));
    expect(codemagicSource, isNot(contains('storePassword:')));
    expect(codemagicSource, isNot(contains('keyPassword:')));
    expect(codemagicSource, isNot(contains('BEGIN PRIVATE KEY')));
    expect(File('android/key.properties').existsSync(), isFalse);

    final gitignore = File('.gitignore').readAsStringSync();
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

    expect(File('integration_test/app_smoke_test.dart').existsSync(), isTrue);
    expect(File('test_driver/integration_test.dart').existsSync(), isTrue);

    for (final workflowFile in <String>[
      '.github/workflows/flutter_build.yml',
      '.github/workflows/flutter_checks.yml',
      '.github/workflows/integration_tests.yml',
    ]) {
      final workflow = _loadYamlMap(workflowFile);
      final triggers = _asYamlMap(workflow['on']);
      if (workflowFile.endsWith('integration_tests.yml')) {
        expect(workflow['name'], 'Integration Tests', reason: workflowFile);
      }
      expect(triggers.keys.cast<String>().toSet(), <String>{
        'workflow_dispatch',
        'pull_request',
        'push',
      }, reason: workflowFile);
      expect(workflow['concurrency'], isNull, reason: workflowFile);

      final jobs = _asYamlMap(workflow['jobs']);
      final expectedJobs = switch (workflowFile) {
        '.github/workflows/flutter_build.yml' => <String>{
          'build_android',
          'build_ios',
          'build_web',
          'build_linux',
          'build_macos',
          'build_windows',
        },
        '.github/workflows/flutter_checks.yml' => <String>{'check_dependencies', 'check_formatting', 'analyze', 'test'},
        _ => <String>{'android', 'ios', 'web', 'linux', 'macos', 'windows'},
      };
      expect(jobs.keys.cast<String>().toSet(), expectedJobs, reason: workflowFile);
      final commands = jobs.values
          .expand((Object? jobValue) => _asYamlList(_asYamlMap(jobValue)['steps']))
          .map(_asYamlMap)
          .map((YamlMap step) => step['run'])
          .whereType<String>()
          .toList();
      for (final MapEntry<Object?, Object?> jobEntry in jobs.entries) {
        final job = _asYamlMap(jobEntry.value);
        final steps = _asYamlList(job['steps']);
        expect(steps.map(_asYamlMap).any((YamlMap step) => _usesAction(step, 'actions/checkout')), isTrue);
        final installFlutter = steps
            .map(_asYamlMap)
            .singleWhere((YamlMap step) => _usesAction(step, 'subosito/flutter-action'));
        final flutterOptions = _asYamlMap(installFlutter['with']);
        expect(flutterOptions['channel'], 'stable', reason: workflowFile);
        expect(flutterOptions, isNot(contains('flutter-version')), reason: workflowFile);
        expect(flutterOptions, isNot(contains('flutter-version-file')), reason: workflowFile);

        final isAppleJob = <String>{'build_ios', 'build_macos', 'ios', 'macos'}.contains(jobEntry.key);

        if (isAppleJob) {
          final selectXcode = steps
              .map(_asYamlMap)
              .singleWhere((YamlMap step) => step['uses'] == 'maxim-lobanov/setup-xcode@v1');
          expect(job['runs-on'], 'macos-latest', reason: '$workflowFile:${jobEntry.key}');
          expect(_asYamlMap(selectXcode['with'])['xcode-version'], 'latest-stable');
        }
      }
      final dependencyCommands = commands.where((String command) => command.startsWith('flutter pub get'));
      expect(dependencyCommands, isNotEmpty, reason: workflowFile);
      expect(dependencyCommands, everyElement('flutter pub get'), reason: workflowFile);
      if (workflowFile.endsWith('flutter_checks.yml')) {
        expect(
          commands,
          contains(
            'dart format --page-width 120 --output=none --set-exit-if-changed lib test integration_test test_driver',
          ),
        );
        expect(commands.any((String command) => command.contains('--line-length')), isFalse);
        expect(commands, contains('flutter test --coverage'));
        expect(commands.any((String command) => command.contains('coverage < 90')), isTrue);
      }
      if (workflowFile.endsWith('integration_tests.yml')) {
        expect(commands.any((String command) => command.contains('flutter test integration_test -d linux')), isTrue);
        expect(commands.any((String command) => command.contains('flutter test integration_test -d macos')), isTrue);
        expect(commands.any((String command) => command.contains('flutter test integration_test -d windows')), isTrue);
        final webSteps = _asYamlList(_asYamlMap(jobs['web'])['steps']).map(_asYamlMap);
        final browser = webSteps.singleWhere((YamlMap step) => step['uses'] == 'browser-actions/setup-chrome@v2');
        expect(
          _asYamlMap(browser['with']),
          allOf(containsPair('chrome-version', 'stable'), containsPair('install-chromedriver', true)),
        );
        final webTest = webSteps.singleWhere((YamlMap step) => step['name'] == 'Test');
        final webCommand = webTest['run'] as String;
        expect(webCommand, contains(r'"${{ steps.browser.outputs.chromedriver-path }}" --port=4444'));
        expect(webCommand, contains('flutter drive --driver=test_driver/integration_test.dart'));
        expect(webCommand, contains('-d web-server'));
        expect(webCommand, contains(r'--chrome-binary="${{ steps.browser.outputs.chrome-path }}"'));
        expect(
          webSteps.map((YamlMap step) => step['run']).whereType<String>().join('\n'),
          isNot(contains('@puppeteer/browsers')),
        );
        final android = _asYamlMap(jobs['android']);
        final androidMatrix = _asYamlMap(_asYamlMap(android['strategy'])['matrix']);
        expect(_asYamlList(androidMatrix['include']), <Object?>[
          <Object?, Object?>{'api-level': 24, 'target': 'default'},
          <Object?, Object?>{'api-level': 30, 'target': 'aosp_atd'},
          <Object?, Object?>{'api-level': 35, 'target': 'aosp_atd'},
        ]);
        final androidSteps = _asYamlList(android['steps']).map(_asYamlMap);
        final androidTest = androidSteps.singleWhere(
          (YamlMap step) => _usesAction(step, 'reactivecircus/android-emulator-runner'),
        );
        final androidTestOptions = _asYamlMap(androidTest['with']);
        expect(androidTestOptions, containsPair('target', r'${{ matrix.target }}'));
        expect(androidTestOptions.containsKey('emulator-options'), isFalse);
        final iosSteps = _asYamlList(_asYamlMap(jobs['ios'])['steps']).map(_asYamlMap);
        final simulator = iosSteps.singleWhere((YamlMap step) => _usesAction(step, 'futureware-tech/simulator-action'));
        expect(_asYamlMap(simulator['with']), containsPair('os_version', '26.2'));
        expect(_asYamlMap(simulator['with']), containsPair('model', 'iPhone 17'));
      }
    }

    final dependencyReview = _loadYamlMap('.github/workflows/dependency_review.yml');
    final dependencyTriggers = _asYamlMap(dependencyReview['on']);
    expect(dependencyTriggers.keys.cast<String>().toSet(), <String>{'pull_request', 'push'});
    expect(dependencyReview['concurrency'], isNull);
    final dependencySteps = _asYamlList(
      _asYamlMap(_asYamlMap(dependencyReview['jobs'])['review'])['steps'],
    ).map(_asYamlMap);
    expect(
      dependencySteps.where((YamlMap step) => step['uses'] == 'actions/dependency-review-action@v5'),
      hasLength(2),
    );
    final pushReview = dependencySteps.singleWhere((YamlMap step) => step['name'] == 'Review pushed dependencies');
    expect(pushReview['if'], "github.event_name == 'push'");
    expect(_asYamlMap(pushReview['with'])['base-ref'], contains('github.event.before'));
    expect(_asYamlMap(pushReview['with'])['head-ref'], r'${{ github.sha }}');
    expect(_asYamlMap(dependencyReview['permissions'])['contents'], 'read');
    expect(dependencySteps.any((YamlMap step) => _usesAction(step, 'actions/dependency-review-action')), isTrue);
  });

  test('web deployment uses one Cloudflare project and public domain', () {
    const pagesProject = 'fluttertemplates';
    const publicDomain = 'templates.achim.io';
    final codemagic = _loadYamlMap('codemagic.yaml');
    final webWorkflow = _asYamlMap(_asYamlMap(codemagic['workflows'])['web']);
    final webScripts = _asYamlList(webWorkflow['scripts']).map(_asYamlMap);
    final publishScript = webScripts.singleWhere((YamlMap step) => step['name'] == 'Publish Web')['script'] as String;
    final cloudflareConfig = File('infrastructure/cloudflare/main.tf').readAsStringSync();
    final cloudflareDocumentation = File('infrastructure/cloudflare/README.md').readAsStringSync();
    final projectReadme = File('README.md').readAsStringSync();

    expect(publishScript, contains('--project-name=$pagesProject'));
    expect(cloudflareConfig, contains('name              = "$pagesProject"'));
    expect(cloudflareConfig, contains('name         = "$publicDomain"'));
    expect(cloudflareDocumentation, contains('$pagesProject.pages.dev'));
    expect(projectReadme, contains('https://$publicDomain'));
  });

  test('source files follow the feature-based application structure', () {
    expect(_entryNames('lib'), <String>{'app', 'features', 'main.dart'});
    expect(_entryNames('lib/features'), <String>{'gallery', 'support', 'templates'});
    expect(_entryNames('lib/features/templates'), <String>{
      'banking_super_app',
      'channel_messenger',
      'design_course',
      'dating_app',
      'finance_app',
      'fitness_app',
      'hotel_booking',
      'language_learning',
      'private_messenger',
      'shared',
      'social_feed',
    });
  });

  test('bundled font licenses preserve their exact upstream notices', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final workSansLicense = File('assets/fonts/WorkSans-LICENSE.txt').readAsStringSync();
    final robotoLicense = File('assets/fonts/Roboto-LICENSE.txt').readAsStringSync();
    final smoothStarRatingLicense = File('assets/licenses/smooth_star_rating-LICENSE.txt').readAsStringSync();

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

    const additionalFonts = <({String asset, String copyright, String family})>[
      (
        family: 'BricolageGrotesque',
        asset: 'BricolageGrotesque.ttf',
        copyright: 'Copyright 2022 The Bricolage Grotesque Project Authors',
      ),
      (family: 'Fraunces', asset: 'Fraunces.ttf', copyright: 'Copyright 2018 The Fraunces Project Authors'),
      (
        family: 'SpaceGrotesk',
        asset: 'SpaceGrotesk.ttf',
        copyright: 'Copyright 2020 The Space Grotesk Project Authors',
      ),
    ];

    for (final font in additionalFonts) {
      final licensePath = 'assets/fonts/${font.family}-LICENSE.txt';
      final license = File(licensePath).readAsStringSync();
      expect(pubspec, contains('- $licensePath'), reason: font.family);
      expect(pubspec, contains('- family: ${font.family}'), reason: font.family);
      expect(pubspec, contains('- asset: assets/fonts/${font.asset}'), reason: font.family);
      expect(license, startsWith(font.copyright), reason: font.family);
      expect(license, contains('SIL Open Font License, Version 1.1'), reason: font.family);
    }
  });

  test('Google Play icon has exact dimensions and PNG color contracts', () async {
    final ({int bitDepth, int colorType, int height, int width}) playIcon = _readPngHeader('icon/googleplay.png');

    expect(playIcon, (width: 512, height: 512, bitDepth: 8, colorType: 6));
    expect(File('icon/googleplay.png').lengthSync(), lessThanOrEqualTo(1024 * 1024));
    await _expectFullyOpaqueAlpha('icon/googleplay.png');
  });

  test('one canonical icon source owns every generated launcher family', () async {
    final launcherConfig = _asYamlMap(_loadYamlMap('pubspec.yaml')['flutter_launcher_icons']);
    final webIconConfig = _asYamlMap(launcherConfig['web']);
    final androidColors = File('android/app/src/main/res/values/colors.xml').readAsStringSync();
    final webIndex = File('web/index.html').readAsStringSync();
    final webManifest = jsonDecode(File('web/manifest.json').readAsStringSync()) as Map<String, dynamic>;
    final favicon = _readPngHeader('web/favicon.png');

    expect(launcherConfig['image_path'], 'icon/app_icon.png');
    expect(launcherConfig['adaptive_icon_foreground'], 'icon/adaptive_foreground.png');
    expect(androidColors, contains(launcherConfig['adaptive_icon_background']));
    expect(webIconConfig['image_path'], 'icon/app_icon.png');
    expect(webIndex, contains('<link rel="icon" type="image/png" href="favicon.png"/>'));
    expect(favicon.width, 32);
    expect(favicon.height, 32);
    expect(favicon.bitDepth, 8);
    expect(favicon.colorType, anyOf(2, 6));
    expect(webManifest['background_color'], webIconConfig['background_color']);
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

  test('startup surfaces keep adaptive iOS and web launch surfaces', () {
    final launchStoryboard = File('ios/Runner/Base.lproj/LaunchScreen.storyboard').readAsStringSync();
    final mainStoryboard = File('ios/Runner/Base.lproj/Main.storyboard').readAsStringSync();
    final iosInfo = File('ios/Runner/Info.plist').readAsStringSync();
    final androidLaunch = File('android/app/src/main/res/drawable/launch_background.xml').readAsStringSync();
    final androidModernLaunch = File('android/app/src/main/res/drawable-v21/launch_background.xml').readAsStringSync();
    final androidNightStyles = File('android/app/src/main/res/values-night/styles.xml').readAsStringSync();
    final webIndex = File('web/index.html').readAsStringSync();
    final webManifest = jsonDecode(File('web/manifest.json').readAsStringSync()) as Map<String, dynamic>;

    expect(launchStoryboard, contains('<color key="backgroundColor" systemColor="systemBackgroundColor"'));
    expect(launchStoryboard, isNot(contains('<color key="backgroundColor" white="1"')));
    expect(launchStoryboard, isNot(contains('<color key="backgroundColor" red="1" green="1" blue="1"')));
    expect(mainStoryboard, contains('<color key="backgroundColor" systemColor="systemBackgroundColor"'));
    expect(mainStoryboard, isNot(contains('<color key="backgroundColor" white="1"')));
    expect(mainStoryboard, isNot(contains('<color key="backgroundColor" red="1" green="1" blue="1"')));
    expect(launchStoryboard, isNot(contains('LaunchImage')));
    expect(FileSystemEntity.typeSync('ios/Runner/Assets.xcassets/LaunchImage.imageset'), FileSystemEntityType.notFound);
    expect(iosInfo, isNot(contains('<key>UIUserInterfaceStyle</key>')));
    expect(androidLaunch, contains('@android:color/white'));
    expect(androidModernLaunch, contains('@android:color/white'));
    expect(RegExp(r'parent="@android:style/Theme.Light.NoTitleBar"').allMatches(androidNightStyles), hasLength(2));
    expect(androidNightStyles, isNot(contains('Theme.Black')));
    expect(webIndex, contains('name="color-scheme" content="light dark"'));
    expect(webIndex, contains('name="theme-color" content="#FEFEFE" media="(prefers-color-scheme: light)"'));
    expect(webIndex, contains('name="theme-color" content="#111719" media="(prefers-color-scheme: dark)"'));
    expect(webIndex, contains('@media (prefers-color-scheme: dark)'));
    expect(webIndex, contains('background-color: #FEFEFE;'));
    expect(webIndex, contains('background-color: #111719;'));
    expect(webManifest['background_color'], '#F8F2E8');
    expect(webManifest.containsKey('orientation'), isFalse);
  });
}

Set<String> _entryNames(String directory) => Directory(directory)
    .listSync()
    .map((FileSystemEntity entry) => entry.uri.pathSegments.where((String segment) => segment.isNotEmpty).last)
    .toSet();

YamlMap _loadYamlMap(String fileName) => _asYamlMap(loadYaml(File(fileName).readAsStringSync()));

YamlMap _asYamlMap(Object? value) {
  expect(value, isA<YamlMap>());
  return value! as YamlMap;
}

YamlList _asYamlList(Object? value) {
  expect(value, isA<YamlList>());
  return value! as YamlList;
}

bool _usesAction(YamlMap step, String action) {
  final reference = step['uses'];
  return reference is String && RegExp('^${RegExp.escape(action)}@\\S+\$').hasMatch(reference);
}

void _expectFailureOnlySlackPublishing(YamlMap publishing) {
  final slack = _asYamlMap(publishing['slack']);

  expect(slack['channel'], '#codemagic-builds');
  expect(slack['notify_on_build_start'], isFalse);
  expect(_asYamlMap(slack['notify']), <String, bool>{'success': false, 'failure': true});
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
