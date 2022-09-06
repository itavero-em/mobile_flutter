import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../provider/settings_provider.dart';
import '../connections/connection_list_screen.dart';

class SettingsScreenScanMode extends StatefulWidget {
  const SettingsScreenScanMode({Key? key}) : super(key: key);

  @override
  State<SettingsScreenScanMode> createState() => _SettingsScreenScanModeState();
}

class _SettingsScreenScanModeState extends State<SettingsScreenScanMode> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Scanmodus'),
        ),
        body: Center(
          child: SettingsList(
            shrinkWrap: true,
            platform: DevicePlatform.device,
            sections: [
              SettingsSection(
                tiles: <SettingsTile>[
                  SettingsTile(
                    leading: const Icon(Icons.linear_scale),
                    title: const Text('Linie'),
                    value: Text('Hier wird  test \n oder'),
                    onPressed: (ctx) {
                      settingsProvider.setAktivScanMode('linie');
                      Navigator.pop(context);
                    },
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.fullscreen),
                    title: const Text('Block'),
                    value: Text('Hier wird test \n oder'),
                    onPressed: (ctx) {
                      settingsProvider.setAktivScanMode('block');
                      Navigator.pop(context);
                    },
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.rectangle),
                    title: const Text('Rechteck'),
                    value: Text('Hier wird  test \n oder'),
                    onPressed: (ctx) {
                      settingsProvider.setAktivScanMode('rechteck');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
