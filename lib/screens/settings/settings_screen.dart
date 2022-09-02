import 'package:flutter/material.dart';
import 'package:itavero_mobile/screens/settings/settings_screen_scanmode.dart';
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
                  '${Provider.of<SettingsProvider>(context).settingsModel.aktiveVerbindung.name}'),
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
        SettingsSection(
          title: Text('Scandit'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: const Icon(Icons.lightbulb),
              title: const Text('Kameralicht'),
              description: Text('dynamisch anschalten'),
            ),
            SettingsTile.navigation(
              onPressed: (ctx) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsScreenScanMode()),
                ).then((value) => setState(() {}));
              },
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scanmodus'),
              value: Text('${Provider.of<SettingsProvider>(context).settingsModel.aktivScanMode}'),
            ),

          ],
        ),
      ],
    );
  }
}
