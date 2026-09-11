import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/app/app_appearance.dart';
import 'package:templates/features/templates/ai_assistant_app/ai_assistant_home_screen.dart';
import 'package:templates/features/templates/ai_assistant_app/models/assistant_message.dart';
import 'package:templates/features/templates/ai_assistant_app/widgets/assistant_gallery_preview.dart';
import 'package:templates/features/templates/ai_assistant_app/widgets/assistant_message_bubble.dart';
import 'package:templates/features/templates/ai_assistant_app/widgets/assistant_navigation_drawer.dart';

void main() {
  test('assistant messages expose stable roles and welcome copy', () {
    expect(AssistantMessage.welcome.id, 'welcome');
    expect(AssistantMessage.welcome.role, AssistantMessageRole.assistant);
    expect(AssistantMessage.welcome.text, isNotEmpty);
  });

  testWidgets('assistant suggestions compose and send a local exchange', (WidgetTester tester) async {
    await _pumpAssistant(tester);

    await tester.tap(find.widgetWithText(ActionChip, 'Sketch a launch plan'));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, 'Sketch a launch plan');

    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();

    expect(find.text('Sketch a launch plan'), findsWidgets);
    expect(find.text('Start with the goal, then shape the smallest useful first version.'), findsOneWidget);
    expect(find.byType(AssistantMessageBubble), findsNWidgets(3));

    await _openWorkspace(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'New conversation'));
    await tester.pumpAndSettle();
    expect(find.byType(AssistantMessageBubble), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('assistant idea constellation changes focus and composes its prompt', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    await _pumpAssistant(tester);

    expect(find.byKey(const Key('idea-constellation')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Interactive idea constellation')), findsOneWidget);
    expect(find.byKey(const Key('selected-idea-label')), findsOneWidget);
    expect(find.text('STORY'), findsOneWidget);

    await tester.tap(find.byKey(const Key('idea-node-system')));
    await tester.pump();

    expect(find.text('SYSTEM'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Turn my idea into a clear product system',
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('assistant keeps preference state and opens specialists in chat', (WidgetTester tester) async {
    await _pumpAssistant(tester);

    await _openWorkspaceAndSelect(tester, 'Profile');
    final conciseReplies = find.widgetWithText(SwitchListTile, 'Concise replies');
    expect(tester.widget<SwitchListTile>(conciseReplies).value, isTrue);
    await tester.tap(conciseReplies);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(conciseReplies).value, isFalse);

    await _openWorkspace(tester);
    await tester.tap(find.text('Launch brief'));
    await tester.pumpAndSettle();
    expect(find.text('What can I help you create?'), findsOneWidget);

    await _openWorkspaceAndSelect(tester, 'Assistants');
    await tester.tap(find.text('Product partner'));
    await tester.pump();

    expect(find.text('What can I help you create?'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, 'Help me with Product partner');
    expect(tester.takeException(), isNull);
  });

  testWidgets('assistant gallery preview uses its own aurora workspace composition', (WidgetTester tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: AssistantGalleryPreview())),
      ),
    );

    expect(find.text('Nova'), findsOneWidget);
    expect(find.text('Message Nova'), findsOneWidget);
    expect(find.bySemanticsLabel('Nova assistant workspace preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('assistant remains usable at compact maximum text size', (WidgetTester tester) async {
    await _pumpAssistant(tester, size: const Size(320, 568), textScale: 3.2);

    final chatScroll = find.descendant(of: find.byType(AiAssistantHomeScreen), matching: find.byType(Scrollable)).first;
    await tester.drag(chatScroll, const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('THOUGHT MAP'), findsOneWidget);
    final systemIdea = find.widgetWithText(OutlinedButton, 'SYSTEM — Connect the pieces');
    await tester.ensureVisible(systemIdea);
    await tester.pumpAndSettle();
    await tester.tap(systemIdea);
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Turn my idea into a clear product system',
    );

    for (final label in <String>['Assistants', 'Profile', 'Chat']) {
      await _openWorkspaceAndSelect(tester, label);
      expect(tester.takeException(), isNull, reason: label);
    }
  });

  testWidgets('assistant supports dark and light appearances selected by its host', (WidgetTester tester) async {
    await _pumpAssistant(tester);

    expect(Theme.of(tester.element(find.text('Nova').first)).brightness, Brightness.dark);
    await _pumpAssistant(tester, appearance: AppAppearance.light);
    expect(Theme.of(tester.element(find.text('Nova').first)).brightness, Brightness.light);
  });

  testWidgets('assistant keeps an empty command in the composer', (WidgetTester tester) async {
    await _pumpAssistant(tester);

    await tester.tap(find.byTooltip('Send message'));
    await tester.pump();

    expect(find.text('Write a message first.'), findsOneWidget);
    expect(find.byType(AssistantMessageBubble), findsOneWidget);
  });

  testWidgets('assistant returns to its gallery route', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) => TextButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AiAssistantHomeScreen())),
            child: const Text('Open assistant template'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open assistant template'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back to template gallery'));
    await tester.pumpAndSettle();

    expect(find.text('Open assistant template'), findsOneWidget);
    expect(find.byType(AiAssistantHomeScreen), findsNothing);
  });
}

Future<void> _openWorkspaceAndSelect(WidgetTester tester, String label) async {
  await _openWorkspace(tester);
  final drawerScroll = find.descendant(of: find.byType(AssistantNavigationDrawer), matching: find.byType(Scrollable));
  final destination = find.descendant(of: find.byType(AssistantNavigationDrawer), matching: find.text(label));
  await tester.scrollUntilVisible(destination, 120, scrollable: drawerScroll);
  final destinationTile = find.ancestor(of: destination, matching: find.byType(ListTile));
  for (var attempt = 0; attempt < 8; attempt++) {
    final viewport = tester.getRect(drawerScroll);
    final center = tester.getCenter(destinationTile);
    if (viewport.contains(center)) {
      break;
    }
    await tester.drag(drawerScroll, Offset(0, center.dy > viewport.bottom ? -120 : 120));
    await tester.pumpAndSettle();
  }
  expect(tester.getRect(drawerScroll).contains(tester.getCenter(destinationTile)), isTrue);
  await tester.tapAt(tester.getCenter(destinationTile));
  await tester.pumpAndSettle();
  expect(find.byType(AssistantNavigationDrawer), findsNothing);
}

Future<void> _openWorkspace(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open workspace'));
  await tester.pumpAndSettle();
  expect(find.byType(AssistantNavigationDrawer), findsOneWidget);
  final scaffold = find.descendant(of: find.byType(AiAssistantHomeScreen), matching: find.byType(Scaffold));
  expect(PrimaryScrollController.of(tester.element(scaffold)).positions, hasLength(1));
}

Future<void> _pumpAssistant(
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
        child: AiAssistantHomeScreen(appearance: appearance),
      ),
    ),
  );
  await tester.pump();
}
