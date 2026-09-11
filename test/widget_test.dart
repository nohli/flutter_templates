import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/support/about_screen.dart';
import 'package:templates/app/app_identity.dart';
import 'package:templates/features/support/external_actions.dart';
import 'package:templates/features/support/feedback_screen.dart';
import 'package:templates/app/font_licenses.dart';
import 'package:templates/features/support/help_screen.dart';
import 'package:templates/features/support/invite_friend_screen.dart';

void main() {
  test('feedback email preserves spaces and reserved characters', () {
    final uri = feedbackEmailUri('Hotel & fitness + course? Yes.');

    expect(uri.scheme, 'mailto');
    expect(uri.path, AppIdentity.supportEmail);
    expect(uri.queryParameters, <String, String>{
      'subject': '${AppIdentity.name} feedback',
      'body': 'Hotel & fitness + course? Yes.',
    });
    expect(uri.toString(), contains('subject=UI%20Templates%20feedback'));
    expect(uri.toString(), contains('body=Hotel%20%26%20fitness%20%2B%20course%3F%20Yes.'));
    expect(uri.toString(), isNot(contains('+')));
  });

  test('support and sharing use the project contact details', () {
    expect(supportEmailUri().scheme, 'mailto');
    expect(supportEmailUri().path, AppIdentity.supportEmail);
    expect(supportEmailUri().queryParameters['subject'], '${AppIdentity.name} support');
    expect(developerPortfolioUri, AppIdentity.supportUri);
    expect(inviteText, contains(AppIdentity.sourceUrl));
  });

  testWidgets('feedback validates text and opens one truthful email draft', (WidgetTester tester) async {
    _evictAssets(<String>['assets/images/feedbackImage.png']);
    final launchResult = Completer<bool>();
    Uri? launchedUri;
    var launchCount = 0;
    await _pumpScreen(
      tester,
      FeedbackScreen(
        launcher: (Uri uri) {
          launchedUri = uri;
          launchCount += 1;
          return launchResult.future;
        },
      ),
    );

    expect(find.text('Tell us what you liked or what we could improve.'), findsOneWidget);
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Enter your feedback before sending.'), findsOneWidget);
    expect(launchCount, 0);

    await tester.enterText(find.byType(TextField), '  The charts are clear.  ');
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Opening…'), findsOneWidget);
    await tester.tap(find.text('Opening…'));
    expect(launchCount, 1);

    launchResult.complete(true);
    await tester.pumpAndSettle();

    expect(launchedUri?.queryParameters['body'], 'The charts are clear.');
    expect(find.text('Your email app is ready. Send the message there when you are satisfied.'), findsOneWidget);
  });

  testWidgets('feedback keeps the draft when no email app is available', (WidgetTester tester) async {
    _evictAssets(<String>['assets/images/feedbackImage.png']);
    await _pumpScreen(tester, FeedbackScreen(launcher: (_) async => false));

    await tester.enterText(find.byType(TextField), 'Please keep this draft.');
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.text('No email app is available. Contact flutter-ui-templates@achim.io.'), findsOneWidget);
    expect(find.text('Please keep this draft.'), findsOneWidget);
  });

  testWidgets('help opens support once and reports launcher failure', (WidgetTester tester) async {
    _evictAssets(<String>['assets/images/helpImage.png']);
    final launchResult = Completer<bool>();
    Uri? launchedUri;
    var launchCount = 0;
    await _pumpScreen(
      tester,
      HelpScreen(
        launcher: (Uri uri) {
          launchedUri = uri;
          launchCount += 1;
          return launchResult.future;
        },
      ),
    );

    await tester.tap(find.text('Email Us'));
    await tester.pump();
    expect(find.text('Opening…'), findsOneWidget);
    await tester.tap(find.text('Opening…'));
    expect(launchCount, 1);

    launchResult.complete(false);
    await tester.pumpAndSettle();

    expect(launchedUri, supportEmailUri());
    expect(find.text('No email app is available. Contact flutter-ui-templates@achim.io.'), findsOneWidget);
  });

  testWidgets('invite sends one native share request with a nonempty origin', (WidgetTester tester) async {
    _evictAssets(<String>['assets/images/inviteImage.png']);
    final shareResult = Completer<void>();
    String? sharedText;
    Rect? sharedOrigin;
    var shareCount = 0;
    await _pumpScreen(
      tester,
      InviteFriendScreen(
        sharer: (String text, Rect origin) {
          sharedText = text;
          sharedOrigin = origin;
          shareCount += 1;
          return shareResult.future;
        },
      ),
    );

    await tester.tap(find.text('Share'));
    await tester.pump();
    expect(find.text('Opening…'), findsOneWidget);
    await tester.tap(find.text('Opening…'));
    expect(shareCount, 1);

    shareResult.complete();
    await tester.pumpAndSettle();

    expect(sharedText, inviteText);
    expect(sharedOrigin, isNotNull);
    expect(sharedOrigin!.isEmpty, isFalse);
  });

  testWidgets('invite remains usable when native sharing fails', (WidgetTester tester) async {
    _evictAssets(<String>['assets/images/inviteImage.png']);
    await _pumpScreen(tester, InviteFriendScreen(sharer: (_, _) => Future<void>.error(StateError('Unavailable'))));

    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();

    expect(find.text('Sharing is temporarily unavailable.'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
  });

  testWidgets('about exposes iOS source and portfolio links without persistent launch errors', (
    WidgetTester tester,
  ) async {
    final launchedUris = <Uri>[];
    await _pumpScreen(
      tester,
      AboutScreen(
        launcher: (Uri uri) async {
          launchedUris.add(uri);
          return false;
        },
      ),
      size: const Size(320, 568),
      platform: TargetPlatform.iOS,
    );

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UI Templates source code'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Original open-source project'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Developer portfolio'));
    await tester.pumpAndSettle();

    expect(launchedUris, <Uri>[
      AppIdentity.sourceUri,
      AppIdentity.upstreamSourceUri,
      AppIdentity.privacyPolicyUri,
      developerPortfolioUri,
    ]);
    expect(find.text(AppIdentity.trademarkDisclaimer), findsOneWidget);
    expect(find.text('The link could not be opened.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('about hides the upstream source link on Android', (WidgetTester tester) async {
    await _pumpScreen(tester, const AboutScreen(), platform: TargetPlatform.android);

    expect(find.text('UI Templates source code'), findsOneWidget);
    expect(find.text('Original open-source project'), findsNothing);
  });

  testWidgets('about recovers cleanly when a native link launcher throws', (WidgetTester tester) async {
    await _pumpScreen(tester, AboutScreen(launcher: (_) => Future<bool>.error(StateError('Unavailable'))));

    final sourceLink = find.widgetWithText(TextButton, 'UI Templates source code');
    await tester.tap(sourceLink);
    await tester.pumpAndSettle();

    expect(find.text('The link could not be opened.'), findsNothing);
    expect(tester.widget<TextButton>(sourceLink).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('successful support actions clear progress without showing errors', (WidgetTester tester) async {
    _evictAssets(<String>['assets/images/helpImage.png']);
    await _pumpScreen(tester, HelpScreen(launcher: (_) async => true));

    await tester.tap(find.text('Email Us'));
    await tester.pumpAndSettle();

    expect(find.textContaining('No email app'), findsNothing);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Email Us')).onPressed, isNotNull);

    await _pumpScreen(tester, AboutScreen(launcher: (_) async => true));
    final sourceLink = find.widgetWithText(TextButton, 'UI Templates source code');
    await tester.tap(sourceLink);
    await tester.pumpAndSettle();

    expect(find.text('The link could not be opened.'), findsNothing);
    expect(tester.widget<TextButton>(sourceLink).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pending native actions may finish after their screens are disposed', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/images/feedbackImage.png',
      'assets/images/helpImage.png',
      'assets/images/inviteImage.png',
    ]);

    final aboutResult = Completer<bool>();
    await _pumpScreen(tester, AboutScreen(launcher: (_) => aboutResult.future));
    await tester.tap(find.text('UI Templates source code'));
    await tester.pump();
    await _pumpScreen(tester, const SizedBox());
    aboutResult.complete(true);
    await tester.pump();

    final helpResult = Completer<bool>();
    await _pumpScreen(tester, HelpScreen(launcher: (_) => helpResult.future));
    await tester.tap(find.text('Email Us'));
    await tester.pump();
    await _pumpScreen(tester, const SizedBox());
    helpResult.complete(true);
    await tester.pump();

    final feedbackResult = Completer<bool>();
    await _pumpScreen(tester, FeedbackScreen(launcher: (_) => feedbackResult.future));
    await tester.enterText(find.byType(TextField), 'Keep this safe.');
    await tester.tap(find.text('Send'));
    await tester.pump();
    await _pumpScreen(tester, const SizedBox());
    feedbackResult.complete(true);
    await tester.pump();

    final shareResult = Completer<void>();
    await _pumpScreen(tester, InviteFriendScreen(sharer: (_, _) => shareResult.future));
    await tester.tap(find.text('Share'));
    await tester.pump();
    await _pumpScreen(tester, const SizedBox());
    shareResult.complete();
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('bundled font license registration is idempotent at the registry boundary', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/fonts/WorkSans-LICENSE.txt',
      'assets/fonts/Roboto-LICENSE.txt',
      'assets/licenses/smooth_star_rating-LICENSE.txt',
    ]);
    registerBundledFontLicenses();
    registerBundledFontLicenses();

    final entries = await LicenseRegistry.licenses.toList();
    final bundledPackages = entries
        .expand((LicenseEntry entry) => entry.packages)
        .where(<String>{'Work Sans', 'Roboto', 'Smooth Star Rating'}.contains)
        .toList(growable: false);

    expect(bundledPackages, containsAll(<String>['Work Sans', 'Roboto', 'Smooth Star Rating']));
    expect(bundledPackages.where((String package) => package == 'Work Sans'), hasLength(1));
    expect(bundledPackages.where((String package) => package == 'Roboto'), hasLength(1));
    expect(bundledPackages.where((String package) => package == 'Smooth Star Rating'), hasLength(1));
  });

  testWidgets('about opens native licenses with every bundled notice', (WidgetTester tester) async {
    _evictAssets(<String>[
      'assets/fonts/WorkSans-LICENSE.txt',
      'assets/fonts/Roboto-LICENSE.txt',
      'assets/licenses/smooth_star_rating-LICENSE.txt',
    ]);
    registerBundledFontLicenses();
    registerBundledFontLicenses();
    await _pumpScreen(tester, const AboutScreen());

    await tester.ensureVisible(find.text('Open-source licenses'));
    await tester.tap(find.text('Open-source licenses'));
    await tester.pumpAndSettle();

    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('Work Sans'), findsOneWidget);
    expect(find.text('Roboto'), findsOneWidget);
    expect(find.text('Smooth Star Rating'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(430, 932),
  TargetPlatform? platform,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: platform == null ? null : ThemeData(platform: platform),
      home: Scaffold(body: screen),
    ),
  );
  await tester.pump();
}

void _evictAssets(Iterable<String> assets) {
  for (final asset in assets) {
    rootBundle.evict(asset);
  }
}
