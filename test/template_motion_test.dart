import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates/features/templates/shared/template_motion.dart';

void main() {
  testWidgets('template entrance settles immediately when animations are disabled', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: TemplateEntrance(child: Text('Ready')),
        ),
      ),
    );

    expect(find.text('Ready'), findsOneWidget);
    expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
  });

  testWidgets('section transitions retain state and expose only the active section', (WidgetTester tester) async {
    final key = GlobalKey<_MotionHarnessState>();
    await tester.pumpWidget(MaterialApp(home: _MotionHarness(key: key)));

    await tester.tap(find.text('First 0'));
    await tester.pump();
    expect(find.text('First 1'), findsOneWidget);
    expect(find.bySemanticsLabel('First action'), findsOneWidget);
    expect(find.bySemanticsLabel('Second action'), findsNothing);

    key.currentState!.select(1);
    await tester.pump();
    final transition = find.descendant(of: find.byType(TemplateSectionSwitcher), matching: find.byType(FadeTransition));
    expect(tester.widget<FadeTransition>(transition).opacity.value, 0.45);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('First action'), findsNothing);
    expect(find.bySemanticsLabel('Second action'), findsOneWidget);

    key.currentState!.select(0);
    await tester.pumpAndSettle();
    expect(find.text('First 1'), findsOneWidget);
  });

  testWidgets('section transitions settle immediately when animations are disabled', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: TemplateSectionSwitcher(selectedIndex: 0, children: <Widget>[Text('First'), Text('Second')]),
        ),
      ),
    );

    final switcher = find.byType(TemplateSectionSwitcher);
    expect(find.descendant(of: switcher, matching: find.byType(FadeTransition)), findsNothing);
    expect(find.descendant(of: switcher, matching: find.byType(SlideTransition)), findsNothing);
  });
}

class _MotionHarness extends StatefulWidget {
  const _MotionHarness({super.key});

  @override
  State<_MotionHarness> createState() => _MotionHarnessState();
}

class _MotionHarnessState extends State<_MotionHarness> {
  var _selectedIndex = 0;

  void select(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TemplateSectionSwitcher(
      selectedIndex: _selectedIndex,
      children: const <Widget>[
        _CounterCard(label: 'First'),
        _CounterCard(label: 'Second'),
      ],
    );
  }
}

class _CounterCard extends StatefulWidget {
  const _CounterCard({required this.label});

  final String label;

  @override
  State<_CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<_CounterCard> {
  var _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        button: true,
        label: '${widget.label} action',
        child: TextButton(
          onPressed: () {
            setState(() {
              _count++;
            });
          },
          child: Text('${widget.label} $_count'),
        ),
      ),
    );
  }
}
