/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:itavero_mobile/screens/scanning/barcode_scanner_screen.dart';
import 'package:itavero_mobile/screens/settings/settings_screen.dart';
import 'package:itavero_mobile/screens/webview/webview_stacked.dart';
import 'package:itavero_mobile/services/preference_service.dart';
import 'package:provider/provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  PreferenceService().getSettings().then((value) => {
        runApp(MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SettingsProvider(settingsModel: value),
            )
          ],
          child: const ItaveroMobile(),
        ))
      });
}

class ItaveroMobile extends StatelessWidget {
  const ItaveroMobile({Key? key}) : super(key: key);

  static const String _title = 'itavero mobile app';
  static const Color _itacolor = Color(0xff3397c8);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MobileApp(),
    );
  }
}

class MobileApp extends StatefulWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  int _selectedIndex = 1;

  // final PreferenceService _preferenceService = PreferenceService();

  @override
  initState() {
    super.initState();
  }

  final List<Widget> _pages = <Widget>[
    Center(
      child: WebViewStacked(),
    ),
    Container(
      child: SettingsScreen(),
      alignment: Alignment.topCenter,
    ),
    PlatformApp(
      cupertino: (_, __) => CupertinoAppData(
          theme: CupertinoThemeData(brightness: Brightness.light)),
      home: BarcodeScannerScreen(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: AppBar(
            title: Container(
              child: const Text(
                'itavero.mobile',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.left,
              ),
              alignment: Alignment.topLeft,
            ),
            centerTitle: true,
            backgroundColor: ItaveroMobile._itacolor),
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: _selectedIndex == 1
                ? 'Apps'
                : Provider.of<SettingsProvider>(context, listen: false)
                    .settingsModel
                    .aktiveVerbindung
                    .name,
            activeIcon: Icon(Icons.apps_sharp),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            label: 'Scan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ItaveroMobile._itacolor,
        onTap: _onItemTapped,
      ),
    );
  }
}
