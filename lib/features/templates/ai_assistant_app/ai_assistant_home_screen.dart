import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'ai_assistant_app_theme.dart';
import 'models/assistant_message.dart';
import 'models/assistant_section.dart';
import 'sections/assistant_chat_section.dart';
import 'sections/assistant_discover_section.dart';
import 'sections/assistant_profile_section.dart';
import 'widgets/assistant_navigation_drawer.dart';

class AiAssistantHomeScreen extends StatefulWidget {
  const AiAssistantHomeScreen({this.appearance = AppAppearance.dark, super.key});

  final AppAppearance appearance;

  @override
  State<AiAssistantHomeScreen> createState() => _AiAssistantHomeScreenState();
}

class _AiAssistantHomeScreenState extends State<AiAssistantHomeScreen> {
  late final _scrollControllers = <AssistantSection, ScrollController>{
    for (final section in AssistantSection.values) section: ScrollController(),
  };
  final _composer = TextEditingController();
  final _messages = <AssistantMessage>[AssistantMessage.welcome];

  var _selectedSection = AssistantSection.chat;
  var _conciseReplies = true;
  var _messageSequence = 0;

  @override
  void dispose() {
    _composer.dispose();
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: widget.appearance,
      themeBuilder: AiAssistantAppTheme.build,
      builder: (BuildContext context) {
        final usesLargeText = MediaQuery.textScalerOf(context).scale(1) >= 2;

        return PrimaryScrollController(
          controller: _scrollControllers[_selectedSection]!,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AiAssistantAppTheme.background,
              foregroundColor: AiAssistantAppTheme.ink,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: usesLargeText ? 92 : 72,
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      tooltip: 'Back to template gallery',
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: AiAssistantAppTheme.aqua),
                        shape: const RoundedRectangleBorder(),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : null,
              title: usesLargeText
                  ? const Text(
                      'Nova',
                      style: TextStyle(
                        fontFamily: AiAssistantAppTheme.displayFontName,
                        color: AiAssistantAppTheme.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  : const Row(
                      children: <Widget>[
                        Text(
                          'Nova',
                          style: TextStyle(
                            fontFamily: AiAssistantAppTheme.displayFontName,
                            color: AiAssistantAppTheme.ink,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.7,
                          ),
                        ),
                        SizedBox(width: 9),
                        Text(
                          'SPATIAL OS / 01',
                          style: TextStyle(color: AiAssistantAppTheme.aqua, fontSize: 8, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
              actions: <Widget>[
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      tooltip: 'Open workspace',
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: AiAssistantAppTheme.aqua),
                        shape: const RoundedRectangleBorder(),
                      ),
                      icon: const Icon(Icons.menu_open_rounded),
                    );
                  },
                ),
              ],
            ),
            body: TemplateEntrance(
              child: TemplateSectionSwitcher(
                selectedIndex: _selectedSection.index,
                children: <Widget>[
                  AssistantChatSection(
                    messages: _messages,
                    composer: _composer,
                    scrollController: _scrollControllers[AssistantSection.chat]!,
                    onPromptSelected: _selectPrompt,
                    onSend: _sendMessage,
                  ),
                  AssistantDiscoverSection(
                    scrollController: _scrollControllers[AssistantSection.discover]!,
                    onOpen: _openAssistant,
                  ),
                  AssistantProfileSection(
                    scrollController: _scrollControllers[AssistantSection.profile]!,
                    conciseReplies: _conciseReplies,
                    onConciseRepliesChanged: (bool value) {
                      setState(() {
                        _conciseReplies = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            endDrawer: AssistantNavigationDrawer(
              selectedSection: _selectedSection,
              onSelected: _selectSection,
              onNewChat: _startNewChat,
            ),
          ),
        );
      },
    );
  }

  void _selectSection(AssistantSection section) {
    if (section == _selectedSection) {
      final controller = _scrollControllers[section]!;
      if (controller.hasClients) {
        if (MediaQuery.disableAnimationsOf(context)) {
          controller.jumpTo(0);
        } else {
          controller.animateTo(0, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
        }
      }
      return;
    }

    setState(() {
      _selectedSection = section;
    });
  }

  void _selectPrompt(String prompt) {
    _composer.text = prompt;
    _composer.selection = TextSelection.collapsed(offset: prompt.length);
  }

  void _sendMessage() {
    final prompt = _composer.text.trim();
    if (prompt.isEmpty) {
      _showMessage('Write a message first.');
      return;
    }

    setState(() {
      _messageSequence++;
      _messages
        ..add(AssistantMessage(id: 'user-$_messageSequence', role: AssistantMessageRole.user, text: prompt))
        ..add(
          AssistantMessage(
            id: 'assistant-$_messageSequence',
            role: AssistantMessageRole.assistant,
            text: _conciseReplies
                ? 'Start with the goal, then shape the smallest useful first version.'
                : 'Start by clarifying the goal. Then map the key audience, constraints, and smallest useful first version before adding detail.',
          ),
        );
      _composer.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToLatestMessage());
  }

  void _startNewChat() {
    setState(() {
      _messages
        ..clear()
        ..add(AssistantMessage.welcome);
      _composer.clear();
      _selectedSection = AssistantSection.chat;
    });
  }

  void _openAssistant(String name) {
    _selectPrompt('Help me with $name');
    setState(() {
      _selectedSection = AssistantSection.chat;
    });
  }

  void _scrollToLatestMessage() {
    if (!mounted) return;
    final controller = _scrollControllers[AssistantSection.chat]!;
    if (!controller.hasClients) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      controller.jumpTo(controller.position.maxScrollExtent);
    } else {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
