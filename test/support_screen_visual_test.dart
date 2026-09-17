import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/support/about_screen.dart';
import 'package:templates/app/app_identity.dart';
import 'package:templates/app/app_theme.dart';
import 'package:templates/features/support/feedback_screen.dart';
import 'package:templates/features/support/help_screen.dart';
import 'package:templates/features/support/invite_friend_screen.dart';

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
        screen: InviteFriendScreen(sharer: (_, _) async {}),
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
      final illustration = find.byType(Image);
      expect(tester.getSize(illustration).width, greaterThan(260));
      expect(tester.widget<Image>(illustration).excludeFromSemantics, isTrue);

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      final style = button.style!;
      final enabled = <WidgetState>{};
      final shape = style.shape!.resolve(enabled)!;

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

    final composer = tester.widget<TextField>(find.byType(TextField));

    expect(composer.style?.color, const Color(0xFF313A44));
    expect(composer.cursorColor, Colors.blue);
    expect(composer.decoration?.hintStyle?.color, const Color(0xFF4A6572));
    expect(
      find.byWidgetPredicate((Widget widget) => widget is Container && widget.color == Colors.white),
      findsOneWidget,
    );
  });

  testWidgets('support copy and actions keep consistent safe spacing', (WidgetTester tester) async {
    final scenarios = <Widget>[
      HelpScreen(launcher: (_) async => false),
      FeedbackScreen(launcher: (_) async => false),
      InviteFriendScreen(sharer: (_, _) async {}),
    ];
    for (final viewport in <({Size size, double bottomInset})>[
      (size: const Size(430, 932), bottomInset: 34),
      (size: const Size(1600, 1024), bottomInset: 0),
    ]) {
      double? actionBottom;
      for (final screen in scenarios) {
        await _pumpScreen(tester, screen, size: viewport.size, bottomInset: viewport.bottomInset);
        final actionBounds = tester.getRect(find.byType(FilledButton));

        expect(actionBounds.center.dx, viewport.size.width / 2);
        expect(actionBounds.bottom, viewport.size.height - viewport.bottomInset - 24);
        actionBottom ??= actionBounds.bottom;
        expect(actionBounds.bottom, actionBottom);
      }
    }

    await _pumpScreen(tester, FeedbackScreen(launcher: (_) async => false));
    final descriptionBounds = tester.getRect(find.text('Tell us what you liked or what we could improve.'));

    expect(descriptionBounds.left, greaterThanOrEqualTo(24));
    expect(descriptionBounds.right, lessThanOrEqualTo(406));
  });

  testWidgets('support screens use semantic dark surfaces with readable actions', (WidgetTester tester) async {
    final scenarios = <({Widget screen, String heading, String? imagePath, String? actionLabel})>[
      (
        screen: HelpScreen(launcher: (_) async => false),
        heading: 'How can we help you?',
        imagePath: 'assets/images/helpImage.png',
        actionLabel: 'Email Us',
      ),
      (
        screen: FeedbackScreen(launcher: (_) async => false),
        heading: 'Your Feedback',
        imagePath: 'assets/images/feedbackImage.png',
        actionLabel: 'Send',
      ),
      (
        screen: InviteFriendScreen(sharer: (_, _) async {}),
        heading: 'Invite Your Friends',
        imagePath: 'assets/images/inviteImage.png',
        actionLabel: 'Share',
      ),
      (screen: const AboutScreen(), heading: AppIdentity.name, imagePath: null, actionLabel: null),
    ];
    final colors = AppTheme.build(Brightness.dark).colorScheme;

    for (final scenario in scenarios) {
      if (scenario.imagePath case final imagePath?) rootBundle.evict(imagePath);
      await _pumpScreen(tester, scenario.screen, brightness: Brightness.dark);

      final screen = find.byWidget(scenario.screen);
      final background = tester.widget<ColoredBox>(
        find.descendant(of: screen, matching: find.byType(ColoredBox)).first,
      );
      final headingContext = tester.element(find.text(scenario.heading));
      final foreground = DefaultTextStyle.of(headingContext).style.color!;

      expect(Theme.of(headingContext).brightness, Brightness.dark);
      expect(background.color, colors.surface);
      expect(foreground, colors.onSurface);
      expect(_contrastRatio(foreground, background.color), greaterThanOrEqualTo(4.5));

      if (scenario.actionLabel case final actionLabel?) {
        final button = tester.widget<FilledButton>(find.widgetWithText(FilledButton, actionLabel));
        final enabled = <WidgetState>{};
        final buttonBackground = button.style!.backgroundColor!.resolve(enabled)!;
        final buttonForeground = button.style!.foregroundColor!.resolve(enabled)!;

        expect(buttonBackground, colors.primary);
        expect(buttonForeground, colors.onPrimary);
        expect(_contrastRatio(buttonForeground, buttonBackground), greaterThanOrEqualTo(4.5));
      }
    }
  });

  testWidgets('feedback composer follows the dark surface palette', (WidgetTester tester) async {
    rootBundle.evict('assets/images/feedbackImage.png');
    await _pumpScreen(tester, FeedbackScreen(launcher: (_) async => false), brightness: Brightness.dark);
    final colors = AppTheme.build(Brightness.dark).colorScheme;
    final composer = tester.widget<TextField>(find.byType(TextField));
    final composerSurface = Color.alphaBlend(colors.onSurface.withValues(alpha: 0.16), colors.surface);

    expect(composer.style?.color, colors.onSurface);
    expect(composer.cursorColor, colors.primary);
    expect(composer.decoration?.hintStyle?.color, colors.onSurfaceVariant);
    expect(
      find.byWidgetPredicate((Widget widget) => widget is Container && widget.color == composerSurface),
      findsOneWidget,
    );
    final elevatedComposer = tester.widget<Container>(
      find.byWidgetPredicate((Widget widget) {
        if (widget is! Container) return false;
        final decoration = widget.decoration;
        return decoration is BoxDecoration &&
            decoration.color == composerSurface &&
            decoration.border == null &&
            decoration.boxShadow?.isNotEmpty == true;
      }),
    );
    final decoration = elevatedComposer.decoration! as BoxDecoration;

    expect(decoration.border, isNull);
    expect(_contrastRatio(composerSurface, colors.surface), greaterThan(1.4));
  });

  testWidgets('about keeps readable line length and accessible blue links', (WidgetTester tester) async {
    await _pumpScreen(tester, const AboutScreen(), size: const Size(1024, 1366), platform: TargetPlatform.iOS);

    final content = find.byWidgetPredicate(
      (Widget widget) => widget is ConstrainedBox && widget.constraints.maxWidth == 640,
    );
    expect(content, findsOneWidget);
    expect(tester.getSize(content).width, 640);
    expect(find.text(AppIdentity.sampleContentNotice), findsOneWidget);
    expect(find.text(AppIdentity.trademarkDisclaimer), findsOneWidget);

    final enabled = <WidgetState>{};
    final links = tester.widgetList<TextButton>(find.byType(TextButton));
    expect(links, hasLength(5));
    for (final link in links) {
      expect(link.style?.foregroundColor?.resolve(enabled), AppTheme.actionBlue);
      expect(link.style?.minimumSize?.resolve(enabled)?.height, 48);
    }
  });

  testWidgets('support errors are announced as live regions', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    rootBundle.evict('assets/images/helpImage.png');
    await _pumpScreen(tester, HelpScreen(launcher: (_) async => false));

    await tester.tap(find.text('Email Us'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'No email app is available. Contact flutter-ui-templates@achim.io.');

    rootBundle.evict('assets/images/feedbackImage.png');
    await _pumpScreen(tester, FeedbackScreen(launcher: (_) async => false));

    await tester.tap(find.text('Send'));
    await tester.pump();
    _expectLiveRegion(tester, 'Enter your feedback before sending.');

    rootBundle.evict('assets/images/inviteImage.png');
    await _pumpScreen(tester, InviteFriendScreen(sharer: (_, _) => Future<void>.error(StateError('Unavailable'))));

    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'Sharing is temporarily unavailable.');

    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('email launcher exceptions preserve drafts and leave retry controls enabled', (
    WidgetTester tester,
  ) async {
    final semantics = tester.ensureSemantics();
    Future<bool> throwingLauncher(Uri _) => Future<bool>.error(StateError('Unavailable'));

    rootBundle.evict('assets/images/helpImage.png');
    await _pumpScreen(tester, HelpScreen(launcher: throwingLauncher));
    await tester.tap(find.text('Email Us'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'No email app is available. Contact flutter-ui-templates@achim.io.');
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Email Us')).onPressed, isNotNull);

    rootBundle.evict('assets/images/feedbackImage.png');
    await _pumpScreen(tester, FeedbackScreen(launcher: throwingLauncher));
    await tester.enterText(find.byType(TextField), 'Keep this draft');
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    _expectLiveRegion(tester, 'No email app is available. Contact flutter-ui-templates@achim.io.');
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
        InviteFriendScreen(
          sharer: (_, Rect origin) async {
            sharedOrigin = origin;
          },
        ),
        size: size,
      );
      final shareButton = find.widgetWithText(FilledButton, 'Share');
      final shareButtonBounds = tester.getRect(shareButton);

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
  final error = find.bySemanticsLabel(message);
  expect(error, findsOneWidget);
  expect(tester.getSemantics(error).flagsCollection.isLiveRegion, isTrue);
}

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(430, 932),
  TargetPlatform? platform,
  Brightness brightness = Brightness.light,
  double bottomInset = 0,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  Widget home = Scaffold(body: screen);
  if (bottomInset > 0) {
    home = MediaQuery(
      data: MediaQueryData(padding: EdgeInsets.only(bottom: bottomInset)),
      child: home,
    );
  }

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.build(brightness).copyWith(platform: platform),
      home: home,
    ),
  );
  await tester.pumpAndSettle();
}
