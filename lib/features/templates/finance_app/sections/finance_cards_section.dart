import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../finance_formatters.dart';
import '../widgets/finance_entrance.dart';
import '../widgets/finance_surface.dart';

class FinanceCardsSection extends StatefulWidget {
  const FinanceCardsSection({required this.animation, required this.scrollController, super.key});

  final Animation<double> animation;
  final ScrollController scrollController;

  @override
  State<FinanceCardsSection> createState() => _FinanceCardsSectionState();
}

class _FinanceCardsSectionState extends State<FinanceCardsSection> {
  var _cardIsLocked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('finance-cards'),
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: <Widget>[
        FinanceEntrance(
          animation: widget.animation,
          index: 0,
          child: const Text(
            'Manage your sample cards and limits.',
            style: TextStyle(color: FinanceAppTheme.mutedInk, fontSize: 14),
          ),
        ),
        const SizedBox(height: 18),
        FinanceEntrance(
          animation: widget.animation,
          index: 1,
          child: _PaymentCard(isLocked: _cardIsLocked),
        ),
        const SizedBox(height: 20),
        FinanceEntrance(
          animation: widget.animation,
          index: 2,
          child: FilledButton.tonalIcon(
            onPressed: () {
              setState(() {
                _cardIsLocked = !_cardIsLocked;
              });
            },
            icon: AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 180),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                _cardIsLocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                key: ValueKey<bool>(_cardIsLocked),
              ),
            ),
            label: Text(_cardIsLocked ? 'Unlock sample card' : 'Lock sample card'),
          ),
        ),
        const SizedBox(height: 24),
        FinanceEntrance(
          animation: widget.animation,
          index: 3,
          child: _CardSettings(isLocked: _cardIsLocked),
        ),
      ],
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.isLocked});

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Sample debit card ending in 4832, ${isLocked ? 'locked' : 'active'}',
      child: ExcludeSemantics(
        child: AspectRatio(
          aspectRatio: 1.62,
          child: AnimatedContainer(
            duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(28)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isLocked
                    ? const <Color>[Color(0xFF4B5060), Color(0xFF242938)]
                    : const <Color>[Color(0xFF1A2440), Color(0xFF4054D8)],
              ),
              boxShadow: FinanceAppTheme.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'NORTH',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.8),
                      ),
                    ),
                    Icon(isLocked ? Icons.lock_rounded : Icons.contactless_rounded, color: Colors.white),
                  ],
                ),
                const Spacer(),
                const Text(
                  '••••  ••••  ••••  4832',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: _CardDetail(label: 'CARD HOLDER', value: 'ALEX RIVERA'),
                    ),
                    _CardDetail(label: 'EXPIRES', value: '09/29'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardDetail extends StatelessWidget {
  const _CardDetail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(color: Color(0xFFBEC5E8), fontSize: 9, letterSpacing: 0.8)),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _CardSettings extends StatelessWidget {
  const _CardSettings({required this.isLocked});

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return FinanceSurface(
      child: Column(
        children: <Widget>[
          _SettingRow(icon: Icons.shield_outlined, label: 'Card status', value: isLocked ? 'Locked' : 'Active'),
          const Divider(height: 1, indent: 64, color: FinanceAppTheme.divider),
          _SettingRow(
            icon: Icons.speed_rounded,
            label: 'Monthly limit',
            value: formatCurrency(context, 3000, decimalDigits: 0),
          ),
          const Divider(height: 1, indent: 64, color: FinanceAppTheme.divider),
          const _SettingRow(icon: Icons.public_rounded, label: 'Online payments', value: 'Enabled'),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: FinanceAppTheme.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text(value, style: const TextStyle(color: FinanceAppTheme.mutedInk)),
    );
  }
}
