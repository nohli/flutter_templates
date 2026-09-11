import 'package:flutter/material.dart';

import '../shared/template_motion.dart';
import 'models/home_scene.dart';
import 'models/smart_device.dart';
import 'models/smart_home_section.dart';
import 'sections/smart_home_energy_section.dart';
import 'sections/smart_home_overview_section.dart';
import 'sections/smart_home_rooms_section.dart';
import 'smart_home_app_theme.dart';
import 'widgets/smart_home_bottom_bar.dart';

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  late final _scrollControllers = <SmartHomeSection, ScrollController>{
    for (final section in SmartHomeSection.values) section: ScrollController(),
  };
  var _devices = SmartDevice.samples.toList();
  var _selectedSection = SmartHomeSection.home;
  var _selectedScene = HomeScene.arrive;
  var _selectedRoom = HomeRoom.livingRoom;
  var _monthlyGoal = 180.0;
  var _economyModeIsEnabled = true;

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = _scrollControllers[_selectedSection]!;

    return Theme(
      data: SmartHomeAppTheme.build(),
      child: PrimaryScrollController(
        controller: scrollController,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: SmartHomeAppTheme.background,
            surfaceTintColor: Colors.transparent,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    tooltip: 'Back to template gallery',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  )
                : null,
            title: const Text('HOMELINE', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.4)),
            actions: <Widget>[
              IconButton(
                tooltip: 'Home notifications',
                onPressed: () => _showMessage('Your sample home is running smoothly.'),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: TemplateEntrance(
            child: TemplateSectionSwitcher(
              selectedIndex: _selectedSection.index,
              children: <Widget>[
                SmartHomeOverviewSection(
                  devices: _devices,
                  selectedScene: _selectedScene,
                  scrollController: _scrollControllers[SmartHomeSection.home]!,
                  onSceneSelected: _applyScene,
                  onDeviceChanged: _setDeviceState,
                ),
                SmartHomeRoomsSection(
                  devices: _devices,
                  selectedRoom: _selectedRoom,
                  scrollController: _scrollControllers[SmartHomeSection.rooms]!,
                  onRoomSelected: (HomeRoom room) {
                    setState(() {
                      _selectedRoom = room;
                    });
                  },
                  onDeviceChanged: _setDeviceState,
                ),
                SmartHomeEnergySection(
                  devices: _devices,
                  monthlyGoal: _monthlyGoal,
                  economyModeIsEnabled: _economyModeIsEnabled,
                  scrollController: _scrollControllers[SmartHomeSection.energy]!,
                  onMonthlyGoalChanged: (double value) {
                    setState(() {
                      _monthlyGoal = value;
                    });
                  },
                  onEconomyModeChanged: (bool value) {
                    setState(() {
                      _economyModeIsEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: SmartHomeBottomBar(selectedSection: _selectedSection, onSelected: _selectSection),
        ),
      ),
    );
  }

  void _setDeviceState(SmartDevice device, bool isOn) {
    setState(() {
      _devices = _devices
          .map((SmartDevice candidate) => candidate.id == device.id ? candidate.copyWith(isOn: isOn) : candidate)
          .toList(growable: false);
    });
  }

  void _applyScene(HomeScene scene) {
    final activeIds = switch (scene) {
      HomeScene.arrive => const <String>{'pendant-lights', 'thermostat', 'studio-speaker'},
      HomeScene.focus => const <String>{'thermostat', 'studio-speaker'},
      HomeScene.night => const <String>{'thermostat', 'air-purifier'},
    };
    setState(() {
      _selectedScene = scene;
      _devices = _devices
          .map((SmartDevice device) => device.copyWith(isOn: activeIds.contains(device.id)))
          .toList(growable: false);
    });
  }

  void _selectSection(SmartHomeSection section) {
    if (section == _selectedSection) {
      final controller = _scrollControllers[section]!;
      if (controller.hasClients) {
        if (MediaQuery.disableAnimationsOf(context)) {
          controller.jumpTo(0);
        } else {
          controller.animateTo(0, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
        }
      }
      return;
    }
    setState(() {
      _selectedSection = section;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
