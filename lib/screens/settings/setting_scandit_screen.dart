import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../main.dart';
import '../../models/settings_model.dart';

class ScanditSettings extends StatefulWidget {
  const ScanditSettings({Key? key}) : super(key: key);

  @override
  State<ScanditSettings> createState() => _ScanditSettingsState();
}

class _ScanditSettingsState extends State<ScanditSettings> {
  get settingsProvider => Provider.of<SettingsProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            child: const Text(
              'Scandit',
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
                  _showScanMode(context);
                },
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Scanmode'),
                value: Text(Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .scanMode
                    .jsonValue),
              ),
              SettingsTile.navigation(
                onPressed: (ctx) {
                  _showScanViewMode(context);
                },
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('ScanViewmode'),
                value: Text(Provider.of<SettingsProvider>(context)
                    .settingsModel
                    .scanViewFinderMode
                    .jsonValue),
              ),
              _infoTileWithIcon('Scandit-Version','Version 6.14.1',Icons.perm_device_info),
            ],

          ),
        ],
      ),
    );
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

  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showScanViewMode(BuildContext context) {
    // final settingsProvider = Provider.of<SettingsProvider>(context);
    String possibleValues =
    ScanViewFinderMode.values.map((e) => e.jsonValue).join(", ").toString();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Bitte wählen Sie einen Scanviewmodus aus'),
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

  // This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
  void _showScanMode(BuildContext context) {
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
                .scanMode ==
                ScanMode.single,
            onPressed: () {
              settingsProvider.setScanMode(ScanMode.single);
              Navigator.pop(context);
            },
            child: Text(ScanMode.single.jsonValue),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Provider.of<SettingsProvider>(context)
                .settingsModel
                .scanMode ==
                ScanMode.multi,
            onPressed: () {
              settingsProvider.setScanMode(ScanMode.multi);
              Navigator.pop(context);
            },
            child: Text(ScanMode.multi.jsonValue),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: Provider.of<SettingsProvider>(context)
                .settingsModel
                .scanMode ==
                ScanMode.all,
            onPressed: () {
              settingsProvider.setScanMode(ScanMode.all);
              Navigator.pop(context);
            },
            child: Text(ScanMode.all.jsonValue),
          ),
        ],
      ),
    );
  }
}
