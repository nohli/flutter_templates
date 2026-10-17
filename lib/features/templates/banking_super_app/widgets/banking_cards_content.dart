import 'package:flutter/material.dart';

import '../banking_app_theme.dart';
import '../../../../l10n/localizations.dart';

class BankingCardsContent extends StatefulWidget {
  const BankingCardsContent({super.key});

  @override
  State<BankingCardsContent> createState() => _BankingCardsContentState();
}

class _BankingCardsContentState extends State<BankingCardsContent> {
  var _frozen = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              context.l10n.cards,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            IconButton.filledTonal(
              tooltip: context.l10n.addACard,
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 28),
        AnimatedOpacity(
          opacity: _frozen ? 0.58 : 1,
          duration: const Duration(milliseconds: 180),
          child: Container(
            height: 220,
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: <Color>[Color(0xFF111116), Color(0xFF312A3A)]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(34),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      context.l10n.debit,
                      style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    const Icon(Icons.contactless_rounded, color: Colors.white),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.memory_rounded, color: BankingAppTheme.acid, size: 34),
                const SizedBox(height: 18),
                const Text(
                  '••••  ••••  ••••  8042',
                  style: TextStyle(color: Colors.white, fontSize: 17, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                const Text(
                  'ALEX RIVERA  ·  08/30',
                  style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        SwitchListTile.adaptive(
          value: _frozen,
          onChanged: (bool value) => setState(() => _frozen = value),
          title: Text(context.l10n.freezeCard, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(_frozen ? context.l10n.paymentsArePaused : context.l10n.cardIsReadyToUse),
          secondary: Icon(_frozen ? Icons.ac_unit_rounded : Icons.shield_outlined, color: colors.primary),
          tileColor: colors.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
        ),
        const SizedBox(height: 12),
        _CardSetting(
          icon: Icons.lock_outline_rounded,
          title: context.l10n.pinSecurity,
          detail: context.l10n.viewPinAndPaymentLimits,
        ),
        _CardSetting(
          icon: Icons.language_rounded,
          title: context.l10n.onlinePayments,
          detail: context.l10n.enabledWorldwide,
        ),
        _CardSetting(
          icon: Icons.phone_iphone_rounded,
          title: context.l10n.virtualCard,
          detail: context.l10n.aFreshNumberForOnlinePurchases,
        ),
      ],
    );
  }
}

class _CardSetting extends StatelessWidget {
  const _CardSetting({required this.icon, required this.title, required this.detail});

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
