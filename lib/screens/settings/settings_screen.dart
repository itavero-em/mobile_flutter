import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../provider/settings_provider.dart';
import '../connections/connection_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      shrinkWrap: true,
      platform: DevicePlatform.device,
      sections: [
        SettingsSection(
          title: Text('Einstellungen'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Verbindungen'),
              value: Text(
                  'aktive Verbindung:\n${Provider.of<SettingsProvider>(context).settingsModel.aktiveVerbindung.name}\n'
                      '${Provider.of<SettingsProvider>(context).settingsModel.aktiveVerbindung.url}'),
              onPressed: (ctx) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConnectionListScreen()),
                ).then((value) => setState(() {}));
              },

            ),

          ],
        ),

      ],
    );
  }
}
