import 'package:flutter/material.dart';

import 'banking_app_theme.dart';

class BankingTransferScreen extends StatefulWidget {
  const BankingTransferScreen({super.key});

  @override
  State<BankingTransferScreen> createState() => _BankingTransferScreenState();
}

class _BankingTransferScreenState extends State<BankingTransferScreen> {
  final _controller = TextEditingController(text: '48');
  var _recipient = 'Mina';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Send money')),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Recent people',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (final person in const <({String name, Color color})>[
                    (name: 'Mina', color: BankingAppTheme.coral),
                    (name: 'Lea', color: BankingAppTheme.acid),
                    (name: 'Sam', color: BankingAppTheme.ice),
                    (name: 'Alex', color: Color(0xFFC9B6FF)),
                  ])
                    _Recipient(
                      name: person.name,
                      color: person.color,
                      selected: _recipient == person.name,
                      onTap: () => setState(() => _recipient = person.name),
                    ),
                ],
              ),
              const SizedBox(height: 46),
              Text(
                'You send',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700),
              ),
              TextField(
                key: const ValueKey<String>('banking-transfer-amount'),
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: BankingAppTheme.displayFontName,
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -2,
                ),
                decoration: const InputDecoration(prefixText: '€', filled: false, border: InputBorder.none),
              ),
              Text(
                'Balance after transfer · €8,894.70',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.bolt_rounded, color: BankingAppTheme.violet),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$_recipient receives it instantly',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Text('Free'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(_recipient),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(58)),
                child: Text('Send to $_recipient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Recipient extends StatelessWidget {
  const _Recipient({required this.name, required this.color, required this.selected, required this.onTap});

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Send to $name',
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 27,
                backgroundColor: color,
                foregroundColor: const Color(0xFF28232D),
                child: Text(name.characters.first, style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 7),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
