import 'package:flutter/material.dart';

import '../models/dating_message.dart';
import '../../../../l10n/localizations.dart';

class DatingMessageBubble extends StatelessWidget {
  const DatingMessageBubble({required this.message, required this.matchName, this.isRecent = false, super.key});

  final DatingMessage message;
  final String matchName;
  final bool isRecent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isUser = message.author == DatingMessageAuthor.user;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final author = isUser ? context.l10n.you : matchName;
    final time = isRecent ? context.l10n.nowUpper : message.time;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Semantics(
          label: context.l10n.chatMessageLabel(author, time, message.text),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 310),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: isUser ? colors.primaryContainer : colors.surface,
              border: Border.all(color: isUser ? colors.primary : colors.secondary),
              borderRadius: isUser
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(6),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(22),
                    ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: (isUser ? colors.primary : colors.secondary).withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    context.l10n.messageHeading(author.toUpperCase(), time),
                    style: TextStyle(
                      color: isUser ? colors.primary : colors.secondary,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(message.text, style: TextStyle(color: colors.onSurface, height: 1.35)),
                ],
              ),
            ),
          ),
        ),
      ),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 10 * (1 - value)), child: child),
        );
      },
    );
  }
}
