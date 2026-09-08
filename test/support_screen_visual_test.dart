import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/about_screen.dart';
import 'package:templates/app_identity.dart';
import 'package:templates/app_theme.dart';
import 'package:templates/feedback_screen.dart';
import 'package:templates/help_screen.dart';
import 'package:templates/invite_friend_screen.dart';

void main() {
  testWidgets('illustrated support screens preserve the light artwork and blue action hierarchy', (
    WidgetTester tester,
  ) async {
    final scenarios = <({Widget screen, String imagePath, double minimumWidth, bool hasIcon})>[
      (
        screen: HelpScreen(launcher: (_) async => false),
        imagePath: 'assets/images/helpImage.png',
        minimumWidth: 140,
        hasIcon: false,
      ),
      (
        screen: FeedbackScreen(launcher: (_) async => false),
        imagePath: 'assets/images/feedbackImage.png',
        minimumWidth: 120,
        hasIcon: false,
      ),
      (
        screen: InviteFriend(sharer: (_, _) async {}),
        imagePath: 'assets/images/inviteImage.png',
        minimumWidth: 120,
        hasIcon: true,
      ),
    ];

    for (final scenario in scenarios) {
      rootBundle.evict(scenario.imagePath);
      await _pumpScreen(tester, scenario.screen);

      expect(
        find.byWidgetPredicate((Widget widget) => widget is ColoredBox && widget.color == const Color(0xFFFEFEFE)),
        findsOneWidget,
      );
      final Finder illustration = find.byType(Image);
      expect(tester.getSize(illustration).width, greaterThan(260));
      expect(tester.widget<Image>(illustration).excludeFromSemantics, isTrue);

      final FilledButton button = tester.widget<FilledButton>(find.byType(FilledButton));
      final ButtonStyle style = button.style!;
      final Set<WidgetState> enabled = <WidgetState>{};
      final OutlinedBorder shape = style.shape!.resolve(enabled)!;

      expect(style.backgroundColor!.resolve(enabled), AppTheme.actionBlue);
      expect(style.foregroundColor!.resolve(enabled), Colors.white);
      expect(_contrastRatio(Colors.white, AppTheme.actionBlue), greaterThanOrEqualTo(4.5));
      expect(style.minimumSize!.resolve(enabled), Size(scenario.minimumWidth, 48));
      expect(style.elevation!.resolve(enabled), 8);
      expect(shape, isA<RoundedRectangleBorder>());
      expect((shape as RoundedRectangleBorder).borderRadius, const BorderRadius.all(Radius.circular(4)));
      expect(
        find.descendant(of: find.byType(FilledButton), matching: find.byType(Icon)),
        scenario.hasIcon ? findsOneWidget : findsNothing,
      );
    }
  });

  testWidgets('feedback composer keeps its accepted light colors', (WidgetTester tester) async {
    rootBundle.evict('assets/images/feedbackImage.png');
    await _pumpScreen(tester, FeedbackScreen(launcher: (_) async => false));

    final TextField composer = tester.widget<TextField>(find.byType(TextField));

    expect(composer.style?.color, const Color(0xFF313A44));
    expect(composer.cursorColor, Colors.blue);
    expect(composer.decoration?.hintStyle?.color, const Color(0xFF4A6572));
    expect(
      find.byWidgetPredicate((Widget widget) => widget is Container && widget.color == Colors.white),
      findsOneWidget,
    );
  });

  testWidgets('about keeps readable line length and accessible blue links', (WidgetTester tester) async {
    await _pumpScreen(tester, const AboutScreen(), size: const Size(1024, 1366));

    final Finder content = find.byWidgetPredicate(
      (Widget widget) => widget is ConstrainedBox && widget.constraints.maxWidth == 640,
    );
    expect(content, findsOneWidget);
    expect(tester.getSize(content).width, 640);
    expect(find.text(AppIdentity.sampleContentNotice), findsOneWidget);
    expect(find.text(AppIdentity.trademarkDisclaimer), findsOneWidget);

    final Set<WidgetState> enabled = <WidgetState>{};
    final Iterable<TextButton> links = tester.widgetList<TextButton>(find.byType(TextButton));
    expect(links, hasLength(5));
    for (final TextButton link in links) {
      expect(link.style?.foregroundColor?.resolve(enabled), AppTheme.actionBlue);
      expect(link.style?.minimumSize?.resolve(enabled)?.height, 48);
    }
  });

  testWidgets('support errors are announced as live regions', (WidgetTester tester) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    rootBundle.evict('assets/images/helpImage.png');
    await _pumpScreen(tester, HelpScreen(launcher: (_) async => false));

    await tester.tap(find.text('Email Us'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'No email app is available. Contact templates-app@achim.io.');

    rootBundle.evict('assets/images/feedbackImage.png');
    await _pumpScreen(tester, FeedbackScreen(launcher: (_) async => false));

    await tester.tap(find.text('Send'));
    await tester.pump();
    _expectLiveRegion(tester, 'Enter your feedback before sending.');

    rootBundle.evict('assets/images/inviteImage.png');
    await _pumpScreen(tester, InviteFriend(sharer: (_, _) => Future<void>.error(StateError('Unavailable'))));

    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'Sharing is temporarily unavailable.');

    await _pumpScreen(tester, AboutScreen(launcher: (_) async => false));
    await tester.ensureVisible(find.text('UI Templates source code'));
    await tester.tap(find.text('UI Templates source code'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('The link could not be opened.'));
    await tester.pump();
    _expectLiveRegion(tester, 'The link could not be opened.');

    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('email launcher exceptions preserve drafts and leave retry controls enabled', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    Future<bool> throwingLauncher(Uri _) => Future<bool>.error(StateError('Unavailable'));

    rootBundle.evict('assets/images/helpImage.png');
    await _pumpScreen(tester, HelpScreen(launcher: throwingLauncher));
    await tester.tap(find.text('Email Us'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'No email app is available. Contact templates-app@achim.io.');
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Email Us')).onPressed, isNotNull);

    rootBundle.evict('assets/images/feedbackImage.png');
    await _pumpScreen(tester, FeedbackScreen(launcher: throwingLauncher));
    await tester.enterText(find.byType(TextField), 'Keep this draft');
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'No email app is available. Contact templates-app@achim.io.');
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, 'Keep this draft');
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Send')).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('invite anchors the share popover inside phone and iPad viewports', (WidgetTester tester) async {
    rootBundle.evict('assets/images/inviteImage.png');
    for (final size in <Size>[const Size(430, 932), const Size(1024, 1366)]) {
      Rect? sharedOrigin;
      await _pumpScreen(
        tester,
        InviteFriend(
          sharer: (_, Rect origin) async {
            sharedOrigin = origin;
          },
        ),
        size: size,
      );
      final Finder shareButton = find.widgetWithText(FilledButton, 'Share');
      final Rect shareButtonBounds = tester.getRect(shareButton);

      await tester.tap(shareButton);
      await tester.pumpAndSettle();

      expect(sharedOrigin, shareButtonBounds);
      expect(sharedOrigin!.isEmpty, isFalse);
      expect((Offset.zero & size).contains(sharedOrigin!.topLeft), isTrue);
      expect((Offset.zero & size).contains(sharedOrigin!.bottomRight), isTrue);
      expect(tester.takeException(), isNull);
    }
  });
}

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance ? foregroundLuminance : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance ? backgroundLuminance : foregroundLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}

void _expectLiveRegion(WidgetTester tester, String message) {
  final Finder error = find.bySemanticsLabel(message);
  expect(error, findsOneWidget);
  expect(tester.getSemantics(error).flagsCollection.isLiveRegion, isTrue);
}

Future<void> _pumpScreen(WidgetTester tester, Widget screen, {Size size = const Size(430, 932)}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(home: Scaffold(body: screen)));
  await tester.pumpAndSettle();
}
