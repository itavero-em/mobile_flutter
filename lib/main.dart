/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:itavero_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:itavero_mobile/screens/scanning/barcode_scanner_screen.dart';
import 'package:itavero_mobile/screens/settings/settings_screen.dart';
import 'package:itavero_mobile/services/preference_service.dart';
import 'package:provider/provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/cupertino.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SettingsProvider(),
      )
    ],
    child: const ItaveroMobile(),
  ));
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
  final PreferenceService _preferenceService = PreferenceService();

  @override
  initState() {
    super.initState();
  //   var dummyModel = SettingsModel(einWert: '22');
  //   _preferenceService.saveSettings(dummyModel).whenComplete(() =>
  //   {
  //
  //   print('dummy')
  //
  // });
  //
  //   var settings = _preferenceService.getSettings();
  //   settings.then((model) =>
  //   {
  //
  //   });
  //
  //
  //   List<ConnectionModel> connections= const[ConnectionModel(name: 'Verbindungen#1', url: 'url1'),
  //   ConnectionModel(name: 'Verbindungen#2', url: 'url2')];
  //
  //   //Map<String,dynamic> aMap = Map();
  //   //aMap.addEntries(MapEntry('verbindungen', connections));
  //   SettingsModel settingsModel = SettingsModel(verbindungen:  []);
  //   var json = settingsModel.toJSON();
  //   print(json);
  //   SettingsModel model2 = SettingsModel.fromJSON(json);

  }


  final List<Widget> _pages = <Widget>[
    const Center(
      child: WebView(
        initialUrl: 'https://www.hsv.de',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SettingsScreen(),
        ],
      ),
    ),
    PlatformApp(
      cupertino: (_, __) =>
          CupertinoAppData(
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
      appBar: AppBar(
          title: const Text('itavero.mobile'),
          // backgroundColor: const Color(0x007bb9),
          backgroundColor: ItaveroMobile._itacolor
      ),


      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
          BottomNavigationBarItem(
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
