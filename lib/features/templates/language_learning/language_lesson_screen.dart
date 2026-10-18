import 'package:flutter/material.dart';
import '../../../l10n/localizations.dart';

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
    final correct = _answer == context.l10n.unCafSilVousPlaT;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: context.l10n.closeLesson,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(99)),
          child: LinearProgressIndicator(value: _answer == null ? 0.34 : 0.46, minHeight: 10),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: Row(
              children: <Widget>[
                const Icon(Icons.favorite_rounded, color: Color(0xFFFF6B62)),
                const SizedBox(width: 5),
                Text(context.l10n.number(5)),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        context.l10n.chooseTheBestReply,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 26),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: const BorderRadius.all(Radius.circular(28)),
                        ),
                        child: Row(
                          children: <Widget>[
                            const CircleAvatar(radius: 25, child: Text('☕', style: TextStyle(fontSize: 25))),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                context.l10n.bonjourWhatWouldYouLike,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      for (final answer in <String>[
                        context.l10n.unCafSilVousPlaT,
                        context.l10n.oEstLaGare,
                        context.l10n.bonneNuit,
                      ]) ...<Widget>[
                        _AnswerTile(
                          answer: answer,
                          selected: _answer == answer,
                          correct: _answer != null && answer == context.l10n.unCafSilVousPlaT,
                          onTap: () => setState(() => _answer = answer),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
              if (_answer != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    correct
                        ? context.l10n.perfectThatsAPoliteWayToOrder
                        : context.l10n.almostPickTheReplyThatOrdersACoffee,
                    style: TextStyle(color: correct ? colors.primary : colors.error, fontWeight: FontWeight.w700),
                  ),
                ),
              FilledButton(
                onPressed: correct ? () => Navigator.of(context).pop() : null,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                child: Text(correct ? context.l10n.continueAction : context.l10n.check),
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
