import 'package:flutter/material.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itavero_mobile/api/notification_api.dart';


class WebViewStacked extends StatefulWidget {
  const WebViewStacked({Key? key}) : super(key: key);

  @override
  State<WebViewStacked> createState() => _WebViewStackedState();
}

class _WebViewStackedState extends State<WebViewStacked> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          debuggingEnabled: true,
          initialUrl: Provider.of<SettingsProvider>(context)
              .settingsModel
              .aktiveVerbindung
              .url,
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
            print('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: _createJavascriptChannels(context),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100,
            color: Colors.red[400],
          ),
      ],
    );
  }

  // Add from here ...
  Set<JavascriptChannel> _createJavascriptChannels(BuildContext context) {
    return {
      JavascriptChannel(
        name: 'Scandit',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      ),
      JavascriptChannel(
        name: 'Notifications',
        onMessageReceived: (message) {

          // NotificationApi.showNotification(body: 'Body',title: 'Title',payload: 'Payload',id: 1);
          //https://www.youtube.com/watch?v=bRy5dmts3X8
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Notifications:'+message.message)));
        },
      ),
    };
  }
// ... to here.
}
