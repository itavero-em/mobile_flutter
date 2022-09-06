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
    return

    RefreshIndicator(child: WebView(
      initialUrl: Provider.of<SettingsProvider>(context).settingsModel.aktiveVerbindung.url,
      javascriptMode: JavascriptMode.unrestricted,
      onProgress: (int progress) {
        print('WebView is loading (progress : $progress%)');
      },
      javascriptChannels: <JavascriptChannel>{
        _toasterJavascriptChannel(context),
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    )




        , onRefresh: refresh
    );


  }

  Future refresh() async
  {
    print('Refresh');
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
