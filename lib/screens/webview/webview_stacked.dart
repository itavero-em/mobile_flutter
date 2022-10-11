import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:itavero_mobile/screens/scanning/barcode_scanner_screen.dart';
import 'package:provider/provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

class WebViewStacked extends StatefulWidget {
  const WebViewStacked({Key? key}) : super(key: key);

  @override
  State<WebViewStacked> createState() => _WebViewStackedState();
}

class _WebViewStackedState extends State<WebViewStacked>
    implements BarcodeCaptureListener {
  var loadingPercentage = 0;
  var scannerAktiv = false;
  var loadingFinished = false;
  var webViewController;


  @override
  Widget build(BuildContext context) {
    var barcodeScannerScreen = BarcodeScannerScreen(barcodeCaptureListener: this);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: scannerAktiv ? 2:1,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    WebView(
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
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
                        if (request.url
                            .startsWith('https://www.youtube.com/')) {
                          print('blocking navigation to $request}');
                          return NavigationDecision.prevent;
                        }
                        print('allowing navigation to $request');
                        return NavigationDecision.navigate;
                      },
                      onPageStarted: (String url) {
                        setState(() {
                          loadingPercentage = 0;
                          loadingFinished = false;
                        });
                        print('Page started loading: $url');
                      },
                      onPageFinished: (String url) {
                        setState(() {
                          loadingPercentage = 100;
                          loadingFinished = true;
                        });
                        if (defaultTargetPlatform == TargetPlatform.iOS) {
                          print(
                              'Javascript für iOS (Flutter) wurde hinzugefügt');
                          webViewController.runJavascript('''var Scandit = {
                      getDevicetype:function(){return "FLUTTER_IOS"}
                      ,
                      };''');
                        } else if (defaultTargetPlatform ==
                            TargetPlatform.android) {
                          print(
                              'Javascript für Android (Flutter) wurde hinzugefügt');
                          webViewController.runJavascript('''var Scandit = {
                      getDevicetype:function(){return "FLUTTER_ANDROID"},
                      };''');
                        }

                        print('Page finished loading: $url');
                      },
                      gestureNavigationEnabled: true,
                    ),
                    if (loadingPercentage < 100)
                      LinearProgressIndicator(
                        value: loadingPercentage / 100,
                        color: Colors.red[400],
                      ),
                    if (loadingPercentage < 100)
                      Center(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 1.7,
                              sigmaY: 1.7,
                            ),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: const Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: Text(
                                          "Die Webapps werden geladen ...",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)))),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: scannerAktiv ? 1:0,
              child: Visibility(
                visible: scannerAktiv,
                child: barcodeScannerScreen,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
          visible: scannerAktiv,
          child: FloatingActionButton(
            heroTag: 'scan_btn',
            onPressed: () {
              setState(() {
                setState(() {
                  scannerAktiv = false;
                });
              });
            },
            backgroundColor: Colors.red,
            child: Icon(
              Icons.cancel_presentation,
            ),
          )),
    );
  }

  // Add from here ...
  Set<JavascriptChannel> _createJavascriptChannels(BuildContext context) {
    return {
      JavascriptChannel(
        name: 'ScanditController',
        onMessageReceived: (message) {
          if (message.message == 'openScan') {
            setState(() {
              scannerAktiv = true;
            });
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message.message)));
          }
        },
      ),
      JavascriptChannel(
        name: 'Notifications',
        onMessageReceived: (message) {
          // Dieser Aufruf aus Javascript ist notwendig:
          // -> Notifications.postMessage('Hallo Flutter');
          // -> 'Hallo Flutter' landet dann in der Message

          //NotificationApi.showNotification(body: 'Body',title: 'Title');
          //https://www.youtube.com/watch?v=bRy5dmts3X8
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notifications:' + message.message)));
        },
      ),
    };
  }

  @override
  void didScan(BarcodeCapture barcodeCapture, BarcodeCaptureSession session) {
    var code = session.newlyRecognizedBarcodes.first;
    var data = (code.data == null || code.data?.isEmpty == true)
        ? code.rawData
        : code.data;

    setState(() {
      var script =
          '''if(document.getElementById('scanbutton') != null){     document.getElementById('scanbutton').\$server.sendBarcodeToVaadin('$data')}''';
      webViewController.runJavascript(script);
      scannerAktiv = false;
    });
  }

  @override
  void didUpdateSession(
      BarcodeCapture barcodeCapture, BarcodeCaptureSession session) {
    // TODO: implement didUpdateSession
  }
// ... to here.
}
