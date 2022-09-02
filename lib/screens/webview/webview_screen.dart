import 'package:flutter/material.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  String ita_url = 'https://itavwdmz01.itavero.de:8443/web_erp/';
  @override
  Widget build(BuildContext context) {
    return WebView(
        initialUrl: Provider.of<SettingsProvider>(context).settingsModel.aktiveVerbindung.url,
        javascriptMode: JavascriptMode.unrestricted,
      );

  }
}
