import 'package:flutter/material.dart';
import 'package:itavero_mobile/provider/connection_provider.dart';
import 'package:itavero_mobile/views/settings/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview/ita_web_view.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectionProvider(),
        )
      ],
      child: const ItaveroMobile(),
    )
);

class ItaveroMobile extends StatelessWidget {
  const ItaveroMobile({Key? key}) : super(key: key);

  static const String _title = 'itavero mobile app';

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
  final List<Widget> _pages = <Widget>[
    const Center(
      child: WebView(
        initialUrl: 'https://itavwdmz01.itavero.de:8443/web_erp/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SettingsView(),
        ],
      ),
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
        title: const Text('itavero mobile'),
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
