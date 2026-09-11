import 'package:flutter/material.dart';

import '../shared/template_motion.dart';
import 'conversation_screen.dart';
import 'messenger_app_theme.dart';
import 'models/conversation.dart';
import 'models/messenger_section.dart';
import 'sections/messenger_chats_section.dart';
import 'sections/messenger_people_section.dart';
import 'sections/messenger_profile_section.dart';
import 'widgets/messenger_bottom_bar.dart';

class MessengerHomeScreen extends StatefulWidget {
  const MessengerHomeScreen({super.key});

  @override
  State<MessengerHomeScreen> createState() => _MessengerHomeScreenState();
}

class _MessengerHomeScreenState extends State<MessengerHomeScreen> {
  late final _scrollControllers = <MessengerSection, ScrollController>{
    for (final section in MessengerSection.values) section: ScrollController(),
  };
  var _selectedSection = MessengerSection.chats;
  var _query = '';

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = Conversation.samples
        .where((Conversation conversation) {
          return _query.isEmpty ||
              conversation.name.toLowerCase().contains(_query) ||
              conversation.preview.toLowerCase().contains(_query);
        })
        .toList(growable: false);
    final scrollController = _scrollControllers[_selectedSection]!;

    return Theme(
      data: MessengerAppTheme.build(),
      child: PrimaryScrollController(
        controller: scrollController,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MessengerAppTheme.background,
            surfaceTintColor: Colors.transparent,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    tooltip: 'Back to template gallery',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  )
                : null,
            title: const Text('LUMA', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2)),
            actions: <Widget>[
              IconButton(
                tooltip: 'Start a new conversation',
                onPressed: () => _showMessage('New conversations are not connected in this template.'),
                icon: const Icon(Icons.edit_square),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: TemplateEntrance(
            child: TemplateSectionSwitcher(
              selectedIndex: _selectedSection.index,
              children: <Widget>[
                MessengerChatsSection(
                  conversations: conversations,
                  scrollController: _scrollControllers[MessengerSection.chats]!,
                  onQueryChanged: (String query) {
                    setState(() {
                      _query = query.trim().toLowerCase();
                    });
                  },
                  onConversationSelected: _openConversation,
                ),
                MessengerPeopleSection(
                  scrollController: _scrollControllers[MessengerSection.people]!,
                  onConversationSelected: _openConversation,
                ),
                MessengerProfileSection(scrollController: _scrollControllers[MessengerSection.profile]!),
              ],
            ),
          ),
          bottomNavigationBar: MessengerBottomBar(selectedSection: _selectedSection, onSelected: _selectSection),
        ),
      ),
    );
  }

  void _openConversation(Conversation conversation) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (BuildContext context) => ConversationScreen(conversation: conversation)),
    );
  }

  void _selectSection(MessengerSection section) {
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
