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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            gradient: isUser
                ? const LinearGradient(colors: <Color>[AiAssistantAppTheme.primary, Color(0xFF6D5CE8)])
                : null,
            color: isUser ? null : colors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isUser ? 20 : 5),
              bottomRight: Radius.circular(isUser ? 5 : 20),
            ),
            border: isUser ? null : Border.all(color: colors.outlineVariant),
          ),
          child: Text(message.text, style: TextStyle(color: isUser ? Colors.white : colors.onSurface, height: 1.35)),
        ),
      ),
    );
  }
}
