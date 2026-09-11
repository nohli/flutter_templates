import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/shared/template_appearance.dart';

void main() {
  testWidgets('template appearance follows the system and exposes every explicit mode', (WidgetTester tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

    await tester.pumpWidget(
      MaterialApp(
        home: TemplateAppearanceShell(
          initialAppearance: TemplateAppearance.system,
          themeBuilder: (Brightness brightness) => ThemeData(brightness: brightness),
          builder: (BuildContext context, Widget appearanceButton) {
            return Scaffold(
              appBar: AppBar(actions: <Widget>[appearanceButton]),
              body: const Text('Preview'),
            );
          },
        ),
      ),
    );

    expect(Theme.of(tester.element(find.text('Preview'))).brightness, Brightness.dark);
    expect(find.byTooltip('Appearance: System'), findsOneWidget);

    await tester.tap(find.byTooltip('Appearance: System'));
    await tester.pumpAndSettle();
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('Preview'))).brightness, Brightness.light);
    expect(find.byTooltip('Appearance: Light'), findsOneWidget);

    await tester.tap(find.byTooltip('Appearance: Light'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('Preview'))).brightness, Brightness.dark);
    expect(find.byTooltip('Appearance: Dark'), findsOneWidget);
  });
}
