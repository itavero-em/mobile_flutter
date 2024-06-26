import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/provider/data_provider.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:itavero_mobile/screens/scanning/barcode_scanner_screen.dart';
import 'package:itavero_mobile/screens/scanning/bluetooth_scanner_screen.dart';
import 'package:provider/provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

class WebViewStacked extends StatefulWidget {
  const WebViewStacked({Key? key}) : super(key: key);

  @override
  State<WebViewStacked> createState() => _WebViewStackedState();

  static void clearCache(BuildContext context) {
    context
        .findAncestorStateOfType<_WebViewStackedState>()
        ?._controller
        .clearCache();
    final cookieManger = WebViewCookieManager();
    cookieManger.clearCookies();
  }
}

class _WebViewStackedState extends State<WebViewStacked>
    implements BarcodeCaptureListener {

  var loadingPercentage = 0;
  var scannerAktiv = false;
  var scanditAktiv = true;
  var loadingFinished = false;
  late WebViewController _controller;

  late BarcodeScannerScreen _barcodeScannerScreen;
  late BluetoothScannerScreen _bluetoothScannerScreen;

  @override
  void initState() {
    super.initState();

    scanditAktiv = Provider.of<SettingsProvider>(context, listen: false)
        .settingsModel
        .scanditAktiv;
    //_controller = WebViewController();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
            print('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
              loadingFinished = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
              loadingFinished = true;
            });

            if (defaultTargetPlatform == TargetPlatform.iOS) {
              print('Javascript für iOS (Flutter) wurde hinzugefügt');
              _controller.runJavaScript('''var Scandit = {
                      getDevicetype:function(){return "FLUTTER_IOS"}
                      ,
                      };''');
            } else if (defaultTargetPlatform == TargetPlatform.android) {
              print('Javascript für Android (Flutter) wurde hinzugefügt');
              _controller.runJavaScript('''var Scandit = {
                      getDevicetype:function(){return "FLUTTER_ANDROID"},
                      };''');
            }

            print('Page finished loading: $url');
          },
        ),
      );

    _controller.addJavaScriptChannel('ScanditController',
        onMessageReceived: (message) {
      if (message.message == 'openScan') {
        setState(() {
          scannerAktiv = true;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.message)));
      }
    });

    _controller.addJavaScriptChannel('Notifications',
        onMessageReceived: (message) {
      //NotificationApi.showNotification(body: 'Body',title: 'Title');
      //https://www.youtube.com/watch?v=bRy5dmts3X8
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notifications:' + message.message)));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.loadRequest(Uri.parse(Provider.of<SettingsProvider>(context)
        .settingsModel
        .aktiveVerbindung
        .url));
  }

  @override
  Widget build(BuildContext context) {

    if (scanditAktiv)
      _barcodeScannerScreen = BarcodeScannerScreen(
        barcodeCaptureListener: this,
        onCallback: _processBarcodes,
      );
    else
      _bluetoothScannerScreen =
          BluetoothScannerScreen(onCallback: _processScannedValue);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: scannerAktiv ? 4 : 1,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    WebViewWidget(controller: _controller),
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
              flex: scannerAktiv ? 1 : 0,
              child: Visibility(
                visible: scannerAktiv,
                child: scanditAktiv
                    ? _barcodeScannerScreen
                    : _bluetoothScannerScreen,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
          visible: scannerAktiv,
          child: FloatingActionButton(
            heroTag: 'cancel_scan_btn',
            onPressed: () {
              if (mounted) {
                setState(() {
                  scannerAktiv = false;
                });
              }
            },
            backgroundColor: Colors.red,
            child: Icon(
              Icons.cancel_presentation,
            ),
          )),
    );
  }

  @override
  void didScan(BarcodeCapture barcodeCapture, BarcodeCaptureSession session) {
    barcodeCapture.isEnabled = false;
    for (final Barcode barcode in session.newlyRecognizedBarcodes) {
      String? data = (barcode.data == null || barcode.data?.isEmpty == true)
          ? barcode.rawData
          : barcode.data;

      if (data != null) {
        Provider.of<DataProvider>(context, listen: false).checkBarcode(data);
      }
    }

    ScanMode mode = Provider.of<SettingsProvider>(context, listen: false)
        .settingsModel
        .scanMode;
    switch (mode) {
      case ScanMode.single:
        _processBarcodes('');
        break;
    }
  }

  void _processBarcodes(var dummy) {
    String value = Provider.of<DataProvider>(context, listen: false).storedBarcodesAsString;
    Provider.of<DataProvider>(context, listen: false).cleareBarcodes();
    _processScannedValue(value);
  }

  void _processScannedValue(var value) {
    // Verarbeite den eingegebenen Wert hier
    print('Verarbeiteter Text: $value');
    setState(() {
      var script =
          '''if(document.getElementById('scanbutton') != null){     document.getElementById('scanbutton').\$server.sendBarcodeToVaadin('$value')}''';
      _controller.runJavaScript(script);
      scannerAktiv = false;
    });
  }

  @override
  void didUpdateSession(
      BarcodeCapture barcodeCapture, BarcodeCaptureSession session) {
    barcodeCapture.isEnabled = scannerAktiv;
  }
// ... to here.
}
