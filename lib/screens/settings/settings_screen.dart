import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../provider/settings_provider.dart';
import '../connections/connection_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  get settingsProvider => Provider.of<SettingsProvider>(context, listen: false);

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  SettingsTile _infoTileWithIcon(
      String title, String subtitle, IconData? icon) {
    return SettingsTile.navigation(
      leading: icon == null ? null : Icon(icon),
      title: Text(title),
      value: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  SettingsTile _infoTileStandard(String title, String subtitle) {
    return _infoTileWithIcon(title, subtitle, null);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      shrinkWrap: false,
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
            SettingsTile.switchTile(
              onToggle: (value) {
                print(value);

                setState(() {
                  settingsProvider.enablePushMessages(value);
                });
              },
              initialValue: Provider.of<SettingsProvider>(context)
                  .settingsModel
                  .pushMessageEnabled,
              leading: Provider.of<SettingsProvider>(context)
                      .settingsModel
                      .pushMessageEnabled
                  ? Icon(Icons.notifications_active)
                  : Icon(Icons.notifications_paused),
              title: Text('Push Benachrichtigungen'),
              description: Provider.of<SettingsProvider>(context)
                      .settingsModel
                      .pushMessageEnabled
                  ? Text('werden an die App übermittelt')
                  : Text('inaktiv'),
            ),
          ],
        ),
        SettingsSection(
          title: const Text('Scanner'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                print(value);

                setState(() {
                  settingsProvider.setCameraLight(value);
                });
              },
              initialValue: Provider.of<SettingsProvider>(context)
                  .settingsModel
                  .cameraLight,
              leading: Icon(Icons.lightbulb),
              title: Text('Kameralicht'),
              description: Provider.of<SettingsProvider>(context)
                      .settingsModel
                      .cameraLight
                  ? Text('beim Scannen eingeschaltet')
                  : Text('inaktiv'),
            ),
            SettingsTile.navigation(
              onPressed: (ctx) {
                _showActionSheet(context);
              },
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scanmodus'),
              value: Text(Provider.of<SettingsProvider>(context)
                  .settingsModel
                  .scanViewFinderMode
                  .jsonValue),
            ),
          ],
        ),
        SettingsSection(
          title: const Text('App-Informationen'),
          tiles: <SettingsTile>[
            _infoTileStandard('App name', _packageInfo.appName),
            _infoTileStandard('Package name', _packageInfo.packageName),
            _infoTileStandard('App version', _packageInfo.version),
            _infoTileStandard('Build number', _packageInfo.buildNumber),
            _infoTileStandard('Build signature', _packageInfo.buildSignature),
          ],
        ),
      ],
    );
  }

  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showActionSheet(BuildContext context) {
    // final settingsProvider = Provider.of<SettingsProvider>(context);
    String possibleValues =
        ScanViewFinderMode.values.map((e) => e.jsonValue).join(", ").toString();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Bitte wählen Sie einen Scanmodus aus'),
        message: Text(possibleValues),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// defualt behavior, turns the action's text to bold text.
            isDefaultAction: Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .scanViewFinderMode ==
                ScanViewFinderMode.line,
            onPressed: () {
              settingsProvider.setScanViewMode(ScanViewFinderMode.line);
              Navigator.pop(context);
            },
            child: Text(ScanViewFinderMode.line.jsonValue),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .scanViewFinderMode ==
                ScanViewFinderMode.rectangle,
            onPressed: () {
              settingsProvider.setScanViewMode(ScanViewFinderMode.rectangle);
              Navigator.pop(context);
            },
            child: Text(ScanViewFinderMode.rectangle.jsonValue),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .scanViewFinderMode ==
                ScanViewFinderMode.aimer,
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
