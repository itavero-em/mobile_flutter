import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('itavero mobile'),
      ),
      body: const WebView(
        initialUrl: 'https://itavwdmz01.itavero.de:8443/web_erp/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
