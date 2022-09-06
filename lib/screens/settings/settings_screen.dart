import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../provider/settings_provider.dart';
import '../connections/connection_list_screen.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  get settingsProvider => Provider.of<SettingsProvider>(context,listen: false);



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
              value: Text(Provider.of<SettingsProvider>(context)
                  .settingsModel
                  .aktiveVerbindung
                  .name),
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
          title: const Text('Scanner'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: const Icon(Icons.lightbulb),
              title: const Text('Kameralicht'),
              description: const Text('dynamisch anschalten'),
            ),
            SettingsTile.navigation(
              onPressed: (ctx) {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => SettingsScreenScanMode()),
                // ).then((value) => setState(() {}));
                _showActionSheet(context);

              },
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scanmodus'),
              value: Text(
                  Provider.of<SettingsProvider>(context).settingsModel.aktivScanMode),
            ),
          ],
        ),
      ],
    );
  }
  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showActionSheet(BuildContext context) {
    // final settingsProvider = Provider.of<SettingsProvider>(context);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Bitte wählen Sie einen Scanmodus aus'),
        message: const Text('Linie/Rechteck/Block'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              settingsProvider.setAktivScanMode('linie');
            },
            child: const Text('Linie'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              settingsProvider.setAktivScanMode('rechteck');
            },
            child: Text('Rechteck'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              settingsProvider.setAktivScanMode('block');
            },
            child: const Text('Block'),
          ),

        ],
      ),
    );
  }

}
