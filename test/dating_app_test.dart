import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/dating_app/dating_home_screen.dart';
import 'package:templates/features/templates/dating_app/models/dating_profile.dart';
import 'package:templates/features/templates/dating_app/widgets/dating_gallery_preview.dart';

void main() {
  test('dating profiles have stable identities and complete prompts', () {
    expect(DatingProfile.samples, hasLength(4));
    expect(
      DatingProfile.samples.map((DatingProfile profile) => profile.id).toSet(),
      hasLength(DatingProfile.samples.length),
    );
    expect(
      DatingProfile.samples.every(
        (DatingProfile profile) =>
            profile.name.isNotEmpty && profile.answer.isNotEmpty && profile.interests.length >= 3,
      ),
      isTrue,
    );
  });

  testWidgets('dating choices advance profiles and support one-step undo', (WidgetTester tester) async {
    await _pumpDating(tester);

    expect(find.text('Mina, 29'), findsOneWidget);
    await tester.tap(find.byTooltip('Like profile'));
    await tester.pumpAndSettle();
    expect(find.text('Noah, 31'), findsOneWidget);
    expect(find.text('You liked Mina. We’ll let you know if it’s mutual.'), findsOneWidget);

    await tester.tap(find.byTooltip('Undo last choice'));
    await tester.pumpAndSettle();
    expect(find.text('Mina, 29'), findsOneWidget);
    expect(find.text('Your last choice was restored.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dating actions report truthful state in host-selected appearances', (WidgetTester tester) async {
    await _pumpDating(tester);

    expect(Theme.of(tester.element(find.text('Sway'))).brightness, Brightness.dark);
    await tester.tap(find.byTooltip('Send a spark'));
    await tester.pumpAndSettle();
    expect(find.text('A spark was sent to Mina.'), findsOneWidget);

    await _pumpDating(tester, appearance: AppAppearance.light);
    expect(Theme.of(tester.element(find.text('Sway'))).brightness, Brightness.light);
  });

  testWidgets('dating gallery preview has its own editorial portrait composition', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: DatingGalleryPreview())),
      ),
    );

    expect(find.text('Sway'), findsOneWidget);
    expect(find.text('Mina, 29'), findsOneWidget);
    expect(find.bySemanticsLabel('Sway dating profile preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('dating profile content remains reachable at compact maximum text size', (WidgetTester tester) async {
    await _pumpDating(tester, size: const Size(320, 568), textScale: 3.2);

    final destination = find.text('Thursday social');
    final scrollable = find.descendant(
      of: find.byType(DatingHomeScreen),
      matching: find.byWidgetPredicate(
        (Widget widget) => widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    await tester.dragUntilVisible(destination, scrollable, const Offset(0, -260));
    await tester.pump();
    expect(destination, findsOneWidget);
    expect(tester.getRect(destination).overlaps(const Rect.fromLTWH(0, 0, 320, 568)), isTrue);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpDating(
  WidgetTester tester, {
  Size size = const Size(430, 932),
  double textScale = 1,
  AppAppearance appearance = AppAppearance.dark,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: true);
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: mediaQuery,
        child: DatingHomeScreen(appearance: appearance),
      ),
    ),
  );
  await tester.pump();
}
