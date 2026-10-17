import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
