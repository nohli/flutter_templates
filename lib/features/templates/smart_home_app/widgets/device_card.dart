import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../smart_home_app_theme.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({required this.device, required this.onChanged, super.key});

  final SmartDevice device;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(device.kind);
    final iconBackground = device.isOn ? SmartHomeAppTheme.mint : SmartHomeAppTheme.background;

    return AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: device.isOn ? SmartHomeAppTheme.surface : const Color(0xFFF8FAF9),
        border: Border.all(color: device.isOn ? SmartHomeAppTheme.mint : Colors.transparent, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: device.isOn ? SmartHomeAppTheme.softShadow : const <BoxShadow>[],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: iconBackground,
                    child: Icon(icon, color: device.isOn ? SmartHomeAppTheme.primary : SmartHomeAppTheme.mutedInk),
                  ),
                  const Spacer(),
                  Semantics(
                    label: '${device.isOn ? 'Turn off' : 'Turn on'} ${device.name}',
                    child: Switch.adaptive(
                      value: device.isOn,
                      onChanged: onChanged,
                      thumbIcon: const WidgetStatePropertyAll<Icon?>(null),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(device.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Text(device.statusLabel, style: const TextStyle(color: SmartHomeAppTheme.mutedInk, fontSize: 12)),
              const SizedBox(height: 8),
              Text(
                device.isOn ? '${device.watts} W now' : 'Off',
                style: TextStyle(
                  color: device.isOn ? SmartHomeAppTheme.primary : SmartHomeAppTheme.mutedInk,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(DeviceKind kind) => switch (kind) {
    DeviceKind.light => Icons.lightbulb_rounded,
    DeviceKind.climate => Icons.thermostat_rounded,
    DeviceKind.appliance => Icons.coffee_maker_rounded,
    DeviceKind.air => Icons.air_rounded,
    DeviceKind.speaker => Icons.speaker_rounded,
  };
}
