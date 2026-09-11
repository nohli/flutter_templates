import 'package:flutter/material.dart';

import '../ai_assistant_app_theme.dart';
import '../models/assistant_message.dart';

class AssistantMessageBubble extends StatelessWidget {
  const AssistantMessageBubble({required this.message, super.key});

  final AssistantMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AssistantMessageRole.user;
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Semantics(
        label: '${isUser ? 'You' : 'Nova'}: ${message.text}',
        child: Container(
          constraints: const BoxConstraints(maxWidth: 330),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isUser ? colors.primaryContainer : colors.surface,
            border: Border.all(color: isUser ? colors.primary : colors.outlineVariant),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ColoredBox(
                  color: isUser ? AiAssistantAppTheme.pink : AiAssistantAppTheme.aqua,
                  child: const SizedBox(width: 5),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          isUser ? 'YOU / INPUT' : 'NOVA / RESPONSE',
                          style: TextStyle(
                            color: isUser ? colors.primary : colors.secondary,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(message.text, style: TextStyle(color: colors.onSurface, height: 1.35)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
