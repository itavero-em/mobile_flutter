import 'package:flutter/material.dart';
import 'package:itavero_mobile/screens/settings/setting_scandit_screen.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../main.dart';
import '../../provider/settings_provider.dart';
import '../connections/connection_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../webview/webview_stacked.dart';

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
            title: Text('Allgemein',
                style: TextStyle(
                    color: ItaveroMobile.itacolor,
                    fontWeight: FontWeight.bold)),
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
                    settingsProvider.setPushMessages(value);
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
              SettingsTile.switchTile(
                onToggle: (value) {
                  print(value);

                  setState(() {
                    settingsProvider.setShowIntro(value);
                  });
                },
                initialValue: Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .showIntro,
                leading: Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .showIntro
                    ? Icon(Icons.inbox)
                    : Icon(Icons.inbox),
                title: Text('Intro anzeigen'),
                description: Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .showIntro
                    ? Text('Intro wird beim nächten Start einmal angezeigt.')
                    : Text('Intro wird beim nächsten Start nicht mehr angezeigt.'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Scandit',
                style: TextStyle(
                    color: ItaveroMobile.itacolor,
                    fontWeight: FontWeight.bold)),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
              onToggle: (value) {
                print(value);

                setState(() {
                  settingsProvider.setScanditAktiv(value);
                });
              },
              initialValue: Provider.of<SettingsProvider>(context)
                  .settingsModel
                  .scanditAktiv,
              leading: Provider.of<SettingsProvider>(context)
                  .settingsModel
                  .scanditAktiv
                  ? Icon(Icons.scanner)
                  : Icon(Icons.bluetooth),
              title: Text('Scandit Engine'),
              description: Provider.of<SettingsProvider>(context)
                  .settingsModel
                  .scanditAktiv
                  ? Text('Scandit ist aktiv')
                  : Text('Scandit nicht aktiv, Bluetooth Scanner kann verwendet werden.'),
            ),
              SettingsTile.navigation(
                leading: const Icon(Icons.document_scanner_outlined),
                title: const Text('Konfiguration'),
                description: Text(
                    'Scan-View-Mode:  ${Provider.of<SettingsProvider>(context).settingsModel.scanViewFinderMode.jsonValue}\nScan-Modus: ${Provider.of<SettingsProvider>(context).settingsModel.scanMode.jsonValue}\nKameralicht: ${Provider.of<SettingsProvider>(context).settingsModel.cameraLight ? 'an' : 'aus'}'),
                onPressed: (ctx) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanditSettings()),
                  ).then((value) => setState(() {}));
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('App-Einstellungen',
                style: TextStyle(
                    color: ItaveroMobile.itacolor,
                    fontWeight: FontWeight.bold)),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('Cache bereinigen'),
                description: Text(
                    'Es wird der Zwischenspeicher der Applikation gelöscht. Bitte nur im Fehlerfall anwenden'),
                onPressed: (ctx) {
                  //webView.getW

                  ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text("Cache wurde bereinigt")));
                },
              ),
              SettingsTile.navigation(
                title: Text('Auf Werkseinstellungen zurücksetzen',
                    style: TextStyle(color: Colors.black)),
                description: Text(
                    'Es werden alle Daten zurückgesetzt. Achtung alle manuell gespeicherten Verbindungen werden gelöscht.',
                    style: TextStyle(color: Colors.red)),
                onPressed: (ctx) {
                  showAbfrageDialog(ctx);
                  //webView.getW
                },
              )
            ],
          ),
          SettingsSection(
            title: const Text('App-Informationen',
                style: TextStyle(
                    color: ItaveroMobile.itacolor,
                    fontWeight: FontWeight.bold)),
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

  showAbfrageDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Werkseinstellungen wiederherstellen?'),
            content: Text(
                'Wollen Sie wirklich die Werkseinstellungen wiederherstellen?'),
            actions: [
              CupertinoDialogAction(
                  child: Text("Ja"),
                  onPressed: () {
                    print("Ja");
                    WebViewStacked.clearCache(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Noch111 offen. Werkseinstellungen wurden wieder hergestellt")));
                    Navigator.pop(context);
                  }),
              CupertinoDialogAction(
                child: Text("Nein"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
