import 'package:flutter/material.dart';

class LanguageLessonScreen extends StatefulWidget {
  const LanguageLessonScreen({super.key});

  @override
  State<LanguageLessonScreen> createState() => _LanguageLessonScreenState();
}

class _LanguageLessonScreenState extends State<LanguageLessonScreen> {
  String? _answer;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final correct = _answer == 'Un café, s’il vous plaît.';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close lesson',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(99)),
          child: LinearProgressIndicator(value: _answer == null ? 0.34 : 0.46, minHeight: 10),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: <Widget>[
                Icon(Icons.favorite_rounded, color: Color(0xFFFF6B62)),
                SizedBox(width: 5),
                Text('5'),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Choose the best reply',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(28)),
                ),
                child: const Row(
                  children: <Widget>[
                    CircleAvatar(radius: 25, child: Text('☕', style: TextStyle(fontSize: 25))),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Bonjour! What would you like?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              for (final answer in const <String>[
                'Un café, s’il vous plaît.',
                'Où est la gare?',
                'Bonne nuit!',
              ]) ...<Widget>[
                _AnswerTile(
                  answer: answer,
                  selected: _answer == answer,
                  correct: _answer != null && answer == 'Un café, s’il vous plaît.',
                  onTap: () => setState(() => _answer = answer),
                ),
                const SizedBox(height: 12),
              ],
              const Spacer(),
              if (_answer != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    correct
                        ? 'Perfect — that’s a polite way to order.'
                        : 'Almost. Pick the reply that orders a coffee.',
                    style: TextStyle(color: correct ? colors.primary : colors.error, fontWeight: FontWeight.w700),
                  ),
                ),
              FilledButton(
                onPressed: correct ? () => Navigator.of(context).pop() : null,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                child: Text(correct ? 'Continue' : 'Check'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({required this.answer, required this.selected, required this.correct, required this.onTap});

  final String answer;
  final bool selected;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderColor = correct ? colors.primary : (selected ? colors.secondary : colors.outlineVariant);
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          decoration: BoxDecoration(
            color: selected ? borderColor.withValues(alpha: 0.12) : colors.surface,
            border: Border.all(color: borderColor, width: selected || correct ? 2 : 1),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          child: Text(answer, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
