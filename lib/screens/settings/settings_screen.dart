import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/screens/settings/setting_scandit_screen.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../main.dart';
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
    return SettingsTile(
      leading: icon == null ? null : Icon(icon),
      title: Text(title),
      onPressed: (_) {},
      value: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  SettingsTile _infoTileStandard(String title, String subtitle) {
    return _infoTileWithIcon(title, subtitle, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            child: const Text(
              'Einstellungen',
            ),
            alignment: Alignment.topLeft,
          ),
          centerTitle: true,
          backgroundColor: ItaveroMobile.itacolor),
      body: SettingsList(
        shrinkWrap: false,
        platform: DevicePlatform.device,
        sections: [
          SettingsSection(
            title: Text('Allgemein'),
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
          title: const Text('Scandit'),
          tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.document_scanner_outlined),
                  title: const Text('Konfiguration'),
                  value: Text(Provider.of<SettingsProvider>(context)
                      .settingsModel
                      .scanViewFinderMode.jsonValue
                      ),
                  onPressed: (ctx) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScanditSettings()),
                    ).then((value) => setState(() {}));
                  },
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
      ),
    );
  }
}
