import 'package:flutter/material.dart';

class SocialComposeScreen extends StatefulWidget {
  const SocialComposeScreen({super.key});

  @override
  State<SocialComposeScreen> createState() => _SocialComposeScreenState();
}

class _SocialComposeScreenState extends State<SocialComposeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        leadingWidth: 86,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (BuildContext context, TextEditingValue value, _) {
                return FilledButton(
                  onPressed: value.text.trim().isEmpty ? null : () => Navigator.of(context).pop(value.text.trim()),
                  child: const Text('Publish'),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
          child: Column(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: const ValueKey<String>('social-composer'),
                  controller: _controller,
                  autofocus: true,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 22, height: 1.35),
                  decoration: const InputDecoration(
                    hintText: 'What is happening?',
                    filled: false,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(tooltip: 'Add media', onPressed: () {}, icon: const Icon(Icons.image_outlined)),
                  IconButton(tooltip: 'Add poll', onPressed: () {}, icon: const Icon(Icons.poll_outlined)),
                  IconButton(tooltip: 'Add location', onPressed: () {}, icon: const Icon(Icons.location_on_outlined)),
                  const Spacer(),
                  const Text('Anyone can reply', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
