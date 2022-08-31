import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
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
