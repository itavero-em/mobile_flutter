import 'package:flutter/material.dart';


typedef Callback = void Function(String value);

class BluetoothScannerScreen extends StatefulWidget {
  final Callback onCallback;

  const BluetoothScannerScreen({Key? key, required this.onCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _BluetoothScannerScreenState();

  void _processScannedValue(String value) {
    onCallback(value);
  }
}

class _BluetoothScannerScreenState extends State<BluetoothScannerScreen>
    with WidgetsBindingObserver {
  var scannedValue;
  _BluetoothScannerScreenState();

  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = TextField(
      controller: _controller,
      autofocus: true,
      onSubmitted: widget._processScannedValue,
      decoration: InputDecoration(
          labelText: 'Barcode',
          // helperText: 'Name der Verbindung eingeben',
          prefixIcon: Icon(Icons.barcode_reader),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
      ),

    );

    return Center(child: child);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//Wechsel
  }


  @override
  void dispose() {
    super.dispose();
  }

  T? _ambiguate<T>(T? value) => value;
}
