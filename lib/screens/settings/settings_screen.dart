import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/settings_model.dart';
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
                _showActionSheet(context);

              },
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scanmodus'),
              value: Text(
                  Provider.of<SettingsProvider>(context).settingsModel.scanViewFinderMode.jsonValue),
            ),
          ],
        ),
      ],
    );
  }
  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showActionSheet(BuildContext context) {
    // final settingsProvider = Provider.of<SettingsProvider>(context);
    String possibleValues = ScanViewFinderMode.values.map((e) => e.jsonValue).join(", ").toString();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Bitte wählen Sie einen Scanmodus aus'),
        message: Text(possibleValues),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.
            isDefaultAction: Provider.of<SettingsProvider>(context).settingsModel.scanViewFinderMode == ScanViewFinderMode.line,
            onPressed: () {
              settingsProvider.setScanViewMode(ScanViewFinderMode.line);
              Navigator.pop(context);
            },
            child: Text(ScanViewFinderMode.line.jsonValue),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Provider.of<SettingsProvider>(context).settingsModel.scanViewFinderMode == ScanViewFinderMode.rectangle,
            onPressed: () {
              settingsProvider.setScanViewMode(ScanViewFinderMode.rectangle);
              Navigator.pop(context);


            },
            child: Text(ScanViewFinderMode.rectangle.jsonValue),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Provider.of<SettingsProvider>(context).settingsModel.scanViewFinderMode == ScanViewFinderMode.aimer,
            onPressed: () {
              settingsProvider.setScanViewMode(ScanViewFinderMode.aimer);
              Navigator.pop(context);

            },
            child: Text(ScanViewFinderMode.aimer.jsonValue),
          ),

        ],
      ),
    );
  }

}
