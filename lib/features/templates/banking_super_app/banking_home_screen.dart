import 'package:flutter/material.dart';

import '../../../app/app_appearance.dart';
import '../shared/template_appearance.dart';
import '../shared/template_motion.dart';
import 'banking_app_theme.dart';
import 'banking_transfer_screen.dart';
import 'widgets/banking_cards_content.dart';
import 'widgets/banking_home_content.dart';
import '../../../l10n/localizations.dart';

class BankingHomeScreen extends StatelessWidget {
  const BankingHomeScreen({this.appearance = AppAppearance.light, super.key});

  final AppAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return TemplateAppearanceShell(
      appearance: appearance,
      themeBuilder: BankingAppTheme.build,
      builder: (BuildContext context) => const _BankingHome(),
    );
  }
}

class _BankingHome extends StatefulWidget {
  const _BankingHome();

  @override
  State<_BankingHome> createState() => _BankingHomeState();
}

class _BankingHomeState extends State<_BankingHome> {
  var _selectedIndex = 0;
  var _balanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: TemplateEntrance(
          child: TemplateSectionSwitcher(
            selectedIndex: _selectedIndex,
            children: <Widget>[
              BankingHomeContent(
                balanceVisible: _balanceVisible,
                onToggleBalance: () => setState(() => _balanceVisible = !_balanceVisible),
                onSend: _send,
              ),
              const _PaymentsHub(),
              const BankingCardsContent(),
              const _BenefitsHub(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BankingNavigation(
        selectedIndex: _selectedIndex,
        onSelected: (int value) => setState(() => _selectedIndex = value),
      ),
    );
  }

  Future<void> _send() async {
    final recipient = await Navigator.of(
      context,
    ).push<String>(templatePageRoute<String>(context: context, builder: (_) => const BankingTransferScreen()));
    if (!mounted || recipient == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.moneySentToValue(recipient))));
  }
}

class _BankingNavigation extends StatelessWidget {
  const _BankingNavigation({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = <({String label, IconData icon})>[
      (label: context.l10n.home, icon: Icons.home_rounded),
      (label: context.l10n.payments, icon: Icons.swap_horiz_rounded),
      (label: context.l10n.cards, icon: Icons.credit_card_rounded),
      (label: context.l10n.benefits, icon: Icons.auto_awesome_rounded),
    ];
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(26)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: colors.shadow.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: <Widget>[
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: Semantics(
                  label: items[index].label,
                  selected: selectedIndex == index,
                  button: true,
                  child: InkWell(
                    onTap: () => onSelected(index),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 48,
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? colors.primary : Colors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Icon(
                        items[index].icon,
                        color: selectedIndex == index ? colors.onPrimary : colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentsHub extends StatelessWidget {
  const _PaymentsHub();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      children: <Widget>[
        Text(
          context.l10n.payments,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: context.l10n.nameTagOrBank,
          ),
        ),
        const SizedBox(height: 24),
        _HubTile(
          icon: Icons.person_add_alt_rounded,
          title: context.l10n.newRecipient,
          detail: context.l10n.bankCardOrPaymentHandle,
        ),
        _HubTile(
          icon: Icons.public_rounded,
          title: context.l10n.international,
          detail: context.l10n.sendIn70Currencies,
        ),
        _HubTile(
          icon: Icons.calendar_month_rounded,
          title: context.l10n.scheduled,
          detail: context.l10n.manageRecurringTransfers,
        ),
      ],
    );
  }
}

class _BenefitsHub extends StatelessWidget {
  const _BenefitsHub();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      children: <Widget>[
        Text(
          context.l10n.benefits,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        Container(
          height: 230,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: BankingAppTheme.acid,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.weekendEscape,
                style: const TextStyle(
                  color: Color(0xFF263000),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              const Icon(Icons.flight_takeoff_rounded, color: Color(0xFF263000), size: 56),
              const SizedBox(height: 16),
              Text(
                context.l10n.turnEverydaySpendingIntoYourNextTrip,
                style: const TextStyle(color: Color(0xFF263000), fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HubTile extends StatelessWidget {
  const _HubTile({required this.icon, required this.title, required this.detail});

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
