import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/design_course/design_course_app_theme.dart';

import 'localized_test_app.dart';
import 'painted_text_contrast.dart';

void main() {
  for (final (foreground, isReadable) in [(const Color(0xFF17262A), true), (Colors.white, false)]) {
    testWidgets('painted contrast detects readable=$isReadable over a split background', (tester) async {
      await tester.pumpWidget(
        LocalizedTestApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 62,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(flex: 78, child: ColoredBox(color: Color(0xFFD5ECFF))),
                        Expanded(flex: 22, child: ColoredBox(color: Colors.white)),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      children: [
                        const SizedBox(width: 56),
                        Expanded(
                          child: Text(
                            'Home',
                            style: TextStyle(fontFamily: 'WorkSans', fontSize: 16, color: foreground),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final result = await PaintedTextContrastGuideline(find.text('Home')).evaluate(tester);
      expect(result.passed, isReadable, reason: result.reason);
      expect(tester.takeException(), isNull);
    });
  }

  for (final (foreground, isReadable) in [(DesignCourseAppTheme.lightText, true), (const Color(0xFFBBBBBB), false)]) {
    testWidgets('thin glyph contrast detects readable=$isReadable', (tester) async {
      await tester.pumpWidget(
        LocalizedTestApp(
          home: Scaffold(
            backgroundColor: Colors.white,
            body: Text(
              'Choose your',
              style: TextStyle(fontFamily: DesignCourseAppTheme.fontName, fontSize: 8, color: foreground),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final result = await PaintedTextContrastGuideline(find.text('Choose your')).evaluate(tester);
      expect(result.passed, isReadable, reason: result.reason);
    });
  }

  testWidgets('opaque text contrast ignores very thin antialiasing', (tester) async {
    await tester.pumpWidget(
      const LocalizedTestApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Text(
            'Choose your',
            style: TextStyle(fontFamily: 'WorkSans', fontSize: 6, color: DesignCourseAppTheme.lightText),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final result = await PaintedTextContrastGuideline(find.text('Choose your')).evaluate(tester);
    expect(result.passed, isTrue, reason: result.reason);
  });

  testWidgets('painted contrast includes ancestor color filtering', (tester) async {
    await tester.pumpWidget(
      const LocalizedTestApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: ColorFiltered(
            colorFilter: ColorFilter.mode(Color(0xFFBBBBBB), BlendMode.srcIn),
            child: Text(
              'Filtered text',
              style: TextStyle(fontFamily: 'WorkSans', fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final result = await PaintedTextContrastGuideline(find.text('Filtered text')).evaluate(tester);
    expect(result.passed, isFalse, reason: result.reason);
  });

  testWidgets('painted contrast includes ancestor opacity', (tester) async {
    await tester.pumpWidget(
      const LocalizedTestApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Opacity(
            opacity: .15,
            child: Text(
              'Faint text',
              style: TextStyle(fontFamily: 'WorkSans', fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final result = await PaintedTextContrastGuideline(find.text('Faint text')).evaluate(tester);
    expect(result.passed, isFalse, reason: result.reason);
  });
}
