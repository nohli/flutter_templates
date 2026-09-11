import 'package:flutter/material.dart';

import '../finance_app_theme.dart';
import '../widgets/finance_entrance.dart';
import '../widgets/finance_surface.dart';

class FinanceProfileSection extends StatefulWidget {
  const FinanceProfileSection({required this.animation, required this.scrollController, super.key});

  final Animation<double> animation;
  final ScrollController scrollController;

  @override
  State<FinanceProfileSection> createState() => _FinanceProfileSectionState();
}

class _FinanceProfileSectionState extends State<FinanceProfileSection> {
  var _alertsAreEnabled = true;
  var _biometricsAreEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey<String>('finance-profile'),
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: <Widget>[
        FinanceEntrance(animation: widget.animation, index: 0, child: const _ProfileSummary()),
        const SizedBox(height: 24),
        FinanceEntrance(
          animation: widget.animation,
          index: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Preferences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              FinanceSurface(
                child: Column(
                  children: <Widget>[
                    SwitchListTile.adaptive(
                      secondary: const Icon(Icons.notifications_none_rounded, color: FinanceAppTheme.primary),
                      title: const Text('Spending alerts', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Sample budget notifications'),
                      value: _alertsAreEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _alertsAreEnabled = value;
                        });
                      },
                    ),
                    Divider(height: 1, indent: 64, color: Theme.of(context).colorScheme.outlineVariant),
                    SwitchListTile.adaptive(
                      secondary: const Icon(Icons.fingerprint_rounded, color: FinanceAppTheme.primary),
                      title: const Text('Biometric sign-in', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Interface demonstration only'),
                      value: _biometricsAreEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _biometricsAreEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FinanceEntrance(animation: widget.animation, index: 2, child: const _PrivacyNotice()),
      ],
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FinanceSurface(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: colors.primaryContainer,
            child: Text(
              'AR',
              style: TextStyle(color: colors.onPrimaryContainer, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Alex Rivera', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('Demo profile', style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.verified_user_outlined, color: FinanceAppTheme.mint),
        ],
      ),
    );
  }
}

class _PrivacyNotice extends StatelessWidget {
  const _PrivacyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This template uses fictional local data and does not connect to a bank.',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
