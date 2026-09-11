import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:templates/app/app_identity.dart';
import 'package:templates/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens every bundled template', (WidgetTester tester) async {
    app.main();
    await _finishAnimations(tester);

    expect(find.text(AppIdentity.name), findsOneWidget);
    await _openTemplate(tester, cardLabel: 'Hotel Booking', screenText: 'Explore');
    await _openTemplate(tester, cardLabel: 'Fitness App', screenText: 'My Diary');
    await _openTemplate(tester, cardLabel: 'Design Course', screenText: 'Choose your');
  });
}

Future<void> _openTemplate(WidgetTester tester, {required String cardLabel, required String screenText}) async {
  final card = find.bySemanticsLabel(cardLabel);
  await tester.ensureVisible(card);
  await tester.tap(card);
  await _finishAnimations(tester);

  expect(find.text(screenText), findsOneWidget);

  await tester.binding.handlePopRoute();
  await _finishAnimations(tester);
  expect(find.bySemanticsLabel(cardLabel), findsOneWidget);
}

Future<void> _finishAnimations(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 3));
}
