import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/ai_assistant_app/ai_assistant_home_screen.dart';
import 'package:templates/features/templates/ai_assistant_app/models/assistant_message.dart';
import 'package:templates/features/templates/ai_assistant_app/widgets/assistant_bottom_bar.dart';
import 'package:templates/features/templates/ai_assistant_app/widgets/assistant_gallery_preview.dart';
import 'package:templates/features/templates/ai_assistant_app/widgets/assistant_message_bubble.dart';
import 'package:templates/features/templates/shared/template_gallery_preview.dart';

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
    await tester.pump();

    expect(find.text('Sketch a launch plan'), findsWidgets);
    expect(find.text('Start with the goal, then shape the smallest useful first version.'), findsOneWidget);
    expect(find.byType(AssistantMessageBubble), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('assistant keeps preference state and opens specialists in chat', (WidgetTester tester) async {
    await _pumpAssistant(tester);

    await tester.tap(find.text('Profile'));
    await tester.pump();
    final conciseReplies = find.widgetWithText(SwitchListTile, 'Concise replies');
    expect(tester.widget<SwitchListTile>(conciseReplies).value, isTrue);
    await tester.tap(conciseReplies);
    await tester.pump();
    expect(tester.widget<SwitchListTile>(conciseReplies).value, isFalse);

    await tester.tap(find.text('Discover'));
    await tester.pump();
    await tester.tap(find.text('Product partner'));
    await tester.pump();

    expect(find.text('What can I help you create?'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, 'Help me with Product partner');
    expect(tester.takeException(), isNull);
  });

  testWidgets('assistant gallery preview uses a polished two-device composition', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(child: SizedBox(width: 214, height: 143, child: AssistantGalleryPreview())),
      ),
    );

    expect(find.text('NOVA'), findsWidgets);
    expect(find.text('Message Nova'), findsOneWidget);
    expect(find.byType(TemplatePreviewDevice), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('assistant remains usable at compact maximum text size', (WidgetTester tester) async {
    await _pumpAssistant(tester, size: const Size(320, 568), textScale: 3.2);

    for (final label in <String>['Discover', 'Profile', 'Chat']) {
      await tester.tap(find.descendant(of: find.byType(AssistantBottomBar), matching: find.text(label)).hitTestable());
      await tester.pump();
      expect(tester.takeException(), isNull, reason: label);
    }
  });
}

Future<void> _pumpAssistant(WidgetTester tester, {Size size = const Size(430, 932), double textScale = 1}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);

  final mediaQuery = MediaQueryData.fromView(
    tester.view,
  ).copyWith(textScaler: TextScaler.linear(textScale), disableAnimations: true);
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(data: mediaQuery, child: const AiAssistantHomeScreen()),
    ),
  );
  await tester.pump();
}
