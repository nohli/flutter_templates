enum HomeRoom { livingRoom, kitchen, bedroom, studio }

enum DeviceKind { light, climate, appliance, air, speaker }

class SmartDevice {
  const SmartDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.kind,
    required this.statusLabel,
    required this.watts,
    required this.isOn,
  });

  final String id;
  final String name;
  final HomeRoom room;
  final DeviceKind kind;
  final String statusLabel;
  final int watts;
  final bool isOn;

  SmartDevice copyWith({bool? isOn}) {
    return SmartDevice(
      id: id,
      name: name,
      room: room,
      kind: kind,
      statusLabel: statusLabel,
      watts: watts,
      isOn: isOn ?? this.isOn,
    );
  }

  static const samples = <SmartDevice>[
    SmartDevice(
      id: 'pendant-lights',
      name: 'Pendant lights',
      room: HomeRoom.livingRoom,
      kind: DeviceKind.light,
      statusLabel: 'Warm · 68%',
      watts: 22,
      isOn: true,
    ),
    SmartDevice(
      id: 'thermostat',
      name: 'Climate',
      room: HomeRoom.livingRoom,
      kind: DeviceKind.climate,
      statusLabel: '22 °C · Auto',
      watts: 680,
      isOn: true,
    ),
    SmartDevice(
      id: 'coffee-station',
      name: 'Coffee station',
      room: HomeRoom.kitchen,
      kind: DeviceKind.appliance,
      statusLabel: 'Ready at 07:15',
      watts: 840,
      isOn: false,
    ),
    SmartDevice(
      id: 'air-purifier',
      name: 'Air purifier',
      room: HomeRoom.bedroom,
      kind: DeviceKind.air,
      statusLabel: 'Air quality · Good',
      watts: 38,
      isOn: false,
    ),
    SmartDevice(
      id: 'studio-speaker',
      name: 'Studio sound',
      room: HomeRoom.studio,
      kind: DeviceKind.speaker,
      statusLabel: 'Focus mix · 32%',
      watts: 16,
      isOn: true,
    ),
  ];
}
