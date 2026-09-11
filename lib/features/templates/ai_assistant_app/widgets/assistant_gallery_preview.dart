import 'package:flutter/material.dart';

import '../../shared/template_gallery_preview.dart';
import '../ai_assistant_app_theme.dart';

class AssistantGalleryPreview extends StatelessWidget {
  const AssistantGalleryPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const TemplateGalleryPreviewFrame(
      background: AiAssistantAppTheme.background,
      accent: AiAssistantAppTheme.primary,
      surface: AiAssistantAppTheme.surface,
      primary: _AssistantHomePreview(),
      secondary: _AssistantChatPreview(),
    );
  }
}

class _AssistantHomePreview extends StatelessWidget {
  const _AssistantHomePreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'NOVA',
            style: TextStyle(
              color: AiAssistantAppTheme.ink,
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 6),
          _AuroraCard(),
          SizedBox(height: 7),
          _PromptCard(icon: Icons.draw_outlined, label: 'Launch plan', color: AiAssistantAppTheme.pink),
          SizedBox(height: 4),
          _PromptCard(icon: Icons.code_rounded, label: 'Explain code', color: AiAssistantAppTheme.aqua),
          SizedBox(height: 4),
          _PromptCard(icon: Icons.travel_explore_rounded, label: 'Research', color: AiAssistantAppTheme.lavender),
        ],
      ),
    );
  }
}

class _AssistantChatPreview extends StatelessWidget {
  const _AssistantChatPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 7,
                backgroundColor: AiAssistantAppTheme.raisedSurface,
                child: Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.aqua, size: 8),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Nova',
                  style: TextStyle(color: AiAssistantAppTheme.ink, fontSize: 7, fontWeight: FontWeight.w800),
                ),
              ),
              Icon(Icons.more_horiz_rounded, color: AiAssistantAppTheme.mutedInk, size: 8),
            ],
          ),
          SizedBox(height: 7),
          Align(
            alignment: Alignment.centerLeft,
            child: _ChatBubble(width: 65, color: AiAssistantAppTheme.raisedSurface),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: _ChatBubble(width: 57, color: AiAssistantAppTheme.primary),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: _ChatBubble(width: 72, color: AiAssistantAppTheme.raisedSurface),
          ),
          Spacer(),
          _MiniComposer(),
        ],
      ),
    );
  }
}

class _AuroraCard extends StatelessWidget {
  const _AuroraCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: <Color>[Color(0xFF503FBB), Color(0xFF1C6673)]),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.auto_awesome_rounded, color: AiAssistantAppTheme.aqua, size: 10),
          Spacer(),
          Text(
            'Make ideas real.',
            style: TextStyle(color: Colors.white, fontSize: 7.5, height: 1.05, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        color: AiAssistantAppTheme.raisedSurface,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color, size: 9),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AiAssistantAppTheme.ink, fontSize: 4.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 20,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(9))),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PreviewLine(width: 44, height: 2, color: AiAssistantAppTheme.ink),
          SizedBox(height: 3),
          PreviewLine(width: 32, height: 2, color: AiAssistantAppTheme.mutedInk),
        ],
      ),
    );
  }
}

class _MiniComposer extends StatelessWidget {
  const _MiniComposer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.only(left: 6, right: 2),
      decoration: const BoxDecoration(
        color: AiAssistantAppTheme.raisedSurface,
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: Text('Message Nova', style: TextStyle(color: AiAssistantAppTheme.mutedInk, fontSize: 4.5)),
          ),
          CircleAvatar(
            radius: 7,
            backgroundColor: AiAssistantAppTheme.primary,
            child: Icon(Icons.arrow_upward_rounded, size: 8, color: AiAssistantAppTheme.background),
          ),
        ],
      ),
    );
  }
}
