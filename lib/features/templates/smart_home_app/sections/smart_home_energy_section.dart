import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../smart_home_app_theme.dart';
import '../smart_home_formatters.dart';
import '../widgets/energy_chart.dart';

class SmartHomeEnergySection extends StatelessWidget {
  const SmartHomeEnergySection({
    required this.devices,
    required this.monthlyGoal,
    required this.economyModeIsEnabled,
    required this.scrollController,
    required this.onMonthlyGoalChanged,
    required this.onEconomyModeChanged,
    super.key,
  });

  final List<SmartDevice> devices;
  final double monthlyGoal;
  final bool economyModeIsEnabled;
  final ScrollController scrollController;
  final ValueChanged<double> onMonthlyGoalChanged;
  final ValueChanged<bool> onEconomyModeChanged;

  @override
  Widget build(BuildContext context) {
    final currentWatts = devices
        .where((SmartDevice device) => device.isOn)
        .fold<int>(0, (int sum, SmartDevice device) => sum + device.watts);

    return ListView(
      key: const PageStorageKey<String>('smart-home-energy'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Energy', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('Understand the rhythm of your home.', style: TextStyle(color: SmartHomeAppTheme.mutedInk)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: SmartHomeAppTheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(28)),
            boxShadow: SmartHomeAppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Live use', style: TextStyle(color: SmartHomeAppTheme.mutedInk)),
              const SizedBox(height: 6),
              Text(
                '${formatEnergy(context, currentWatts)} W',
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              const EnergyChart(),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Mon', style: TextStyle(color: SmartHomeAppTheme.mutedInk, fontSize: 11)),
                  Text('Wed', style: TextStyle(color: SmartHomeAppTheme.mutedInk, fontSize: 11)),
                  Text('Fri', style: TextStyle(color: SmartHomeAppTheme.mutedInk, fontSize: 11)),
                  Text('Sun', style: TextStyle(color: SmartHomeAppTheme.mutedInk, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Material(
          color: SmartHomeAppTheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(26)),
          clipBehavior: Clip.antiAlias,
          child: SwitchListTile.adaptive(
            secondary: const Icon(Icons.eco_rounded, color: SmartHomeAppTheme.primary),
            title: const Text('Economy mode', style: TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text('Prefer lower-energy sample scenes'),
            value: economyModeIsEnabled,
            onChanged: onEconomyModeChanged,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: SmartHomeAppTheme.sky,
            borderRadius: BorderRadius.all(Radius.circular(26)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Monthly goal', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                '${formatEnergy(context, monthlyGoal.round())} kWh',
                style: const TextStyle(color: SmartHomeAppTheme.blue, fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Slider(min: 120, max: 240, divisions: 12, value: monthlyGoal, onChanged: onMonthlyGoalChanged),
            ],
          ),
        ),
      ],
    );
  }
}
