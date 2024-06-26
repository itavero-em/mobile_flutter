/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/provider/data_provider.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:itavero_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:itavero_mobile/screens/settings/settings_screen.dart';
import 'package:itavero_mobile/screens/webview/webview_stacked.dart';
import 'package:itavero_mobile/services/preference_service.dart';
import 'package:provider/provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';


late WebViewStacked webView;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  webView = WebViewStacked();

  PreferenceService().getSettings().then((value) => {
        runApp(MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SettingsProvider(settingsModel: value),
            ),
            ChangeNotifierProvider(
              create: (context) => DataProvider(),
            )
          ],
          child: const ItaveroMobile(),
        ))
      });
}

class ItaveroMobile extends StatelessWidget {
  const ItaveroMobile({Key? key}) : super(key: key);

  static const String _title = 'itavero mobile app';
  static const Color itacolor = Color.fromRGBO(0,131,191,1);//#0083bf

  @override
  Widget build(BuildContext context) {
    bool showIntro = Provider.of<SettingsProvider>(context, listen: false)
        .settingsModel.showIntro;

    if(showIntro)
    return const MaterialApp(
      title: _title,
      home: OnBoardingScreen(),
    );
    else
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
  int _selectedIndex = 0;

  // final PreferenceService _preferenceService = PreferenceService();

  @override
  initState() {
    super.initState();
    if(Provider.of<SettingsProvider>(context, listen: false)
        .settingsModel
        .aktiveVerbindung==SettingsModel.noConnectionModel)
    {
      _selectedIndex =1;
    }
  }

  final List<Widget> _pages = <Widget>[
    Center(
      child: webView,
    ),
    Container(
      child: SettingsScreen(),
      alignment: Alignment.topCenter,
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

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ItaveroMobile.itacolor,
        onTap: _onItemTapped,
      ),
    );
  }
}
