import 'package:flutter/material.dart';

import '../models/home_scene.dart';
import '../models/smart_device.dart';
import '../smart_home_app_theme.dart';
import '../widgets/device_card.dart';

class SmartHomeOverviewSection extends StatelessWidget {
  const SmartHomeOverviewSection({
    required this.devices,
    required this.selectedScene,
    required this.scrollController,
    required this.onSceneSelected,
    required this.onDeviceChanged,
    super.key,
  });

  final List<SmartDevice> devices;
  final HomeScene selectedScene;
  final ScrollController scrollController;
  final ValueChanged<HomeScene> onSceneSelected;
  final void Function(SmartDevice device, bool isOn) onDeviceChanged;

  @override
  Widget build(BuildContext context) {
    final activeCount = devices.where((SmartDevice device) => device.isOn).length;

    return ListView(
      key: const PageStorageKey<String>('smart-home-overview'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Everything feels just right.', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(
          '$activeCount devices active · All systems normal',
          style: const TextStyle(color: SmartHomeAppTheme.mutedInk),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[SmartHomeAppTheme.deepGreen, SmartHomeAppTheme.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: SmartHomeAppTheme.softShadow,
          ),
          child: const Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Living room', style: TextStyle(color: Color(0xFFD4EAE4))),
                    SizedBox(height: 8),
                    Text(
                      '22 °C',
                      style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 5),
                    Text('Comfortable · 46% humidity', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 34,
                backgroundColor: Color(0x22FFFFFF),
                child: Icon(Icons.wb_sunny_rounded, color: SmartHomeAppTheme.amber, size: 34),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Scenes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final scene in HomeScene.values) ...<Widget>[
                ChoiceChip(
                  avatar: Icon(_iconFor(scene), size: 18),
                  label: Text(_labelFor(scene)),
                  selected: scene == selectedScene,
                  onSelected: (_) => onSceneSelected(scene),
                ),
                if (scene != HomeScene.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Quick controls', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final usesColumns = constraints.maxWidth >= 380 && MediaQuery.textScalerOf(context).scale(1) < 1.6;
            final width = usesColumns ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                for (final device in devices)
                  SizedBox(
                    width: width,
                    child: DeviceCard(device: device, onChanged: (bool value) => onDeviceChanged(device, value)),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _labelFor(HomeScene scene) => switch (scene) {
    HomeScene.arrive => 'Arrive home',
    HomeScene.focus => 'Focus',
    HomeScene.night => 'Night',
  };

  IconData _iconFor(HomeScene scene) => switch (scene) {
    HomeScene.arrive => Icons.home_rounded,
    HomeScene.focus => Icons.center_focus_strong_rounded,
    HomeScene.night => Icons.bedtime_rounded,
  };
}
