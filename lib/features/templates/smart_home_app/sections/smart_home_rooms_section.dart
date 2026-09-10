import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../smart_home_app_theme.dart';
import '../widgets/device_card.dart';

class SmartHomeRoomsSection extends StatelessWidget {
  const SmartHomeRoomsSection({
    required this.devices,
    required this.selectedRoom,
    required this.scrollController,
    required this.onRoomSelected,
    required this.onDeviceChanged,
    super.key,
  });

  final List<SmartDevice> devices;
  final HomeRoom selectedRoom;
  final ScrollController scrollController;
  final ValueChanged<HomeRoom> onRoomSelected;
  final void Function(SmartDevice device, bool isOn) onDeviceChanged;

  @override
  Widget build(BuildContext context) {
    final roomDevices = devices.where((SmartDevice device) => device.room == selectedRoom).toList(growable: false);

    return ListView(
      key: const PageStorageKey<String>('smart-home-rooms'),
      controller: scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
      children: <Widget>[
        const Text('Rooms', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('Keep every space comfortable and clear.', style: TextStyle(color: SmartHomeAppTheme.mutedInk)),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final room in HomeRoom.values) ...<Widget>[
                ChoiceChip(
                  label: Text(_labelFor(room)),
                  selected: room == selectedRoom,
                  onSelected: (_) => onRoomSelected(room),
                ),
                if (room != HomeRoom.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: SmartHomeAppTheme.sky,
            borderRadius: BorderRadius.all(Radius.circular(26)),
          ),
          child: Row(
            children: <Widget>[
              const CircleAvatar(
                radius: 25,
                backgroundColor: SmartHomeAppTheme.surface,
                child: Icon(Icons.sensors_rounded, color: SmartHomeAppTheme.blue),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_labelFor(selectedRoom), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(
                      '${roomDevices.length} connected ${roomDevices.length == 1 ? 'device' : 'devices'}',
                      style: const TextStyle(color: SmartHomeAppTheme.mutedInk),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final device in roomDevices) ...<Widget>[
          DeviceCard(device: device, onChanged: (bool value) => onDeviceChanged(device, value)),
          if (device != roomDevices.last) const SizedBox(height: 12),
        ],
      ],
    );
  }

  String _labelFor(HomeRoom room) => switch (room) {
    HomeRoom.livingRoom => 'Living room',
    HomeRoom.kitchen => 'Kitchen',
    HomeRoom.bedroom => 'Bedroom',
    HomeRoom.studio => 'Studio',
  };
}
