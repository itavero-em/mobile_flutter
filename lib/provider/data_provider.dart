import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/services/preference_service.dart';


class DataProvider extends ChangeNotifier{
  int _barcodeCount = 0;

  int get barcodeCount => _barcodeCount;

  Set<String> _storedBarcodes = {};

  Set<String> get storedBarcodes => _storedBarcodes;

  // Der ASCII-Wert 29 entspricht dem Steuerzeichen "Group Separator" (GS)
  String get storedBarcodesAsString  => storedBarcodes.join(String.fromCharCode(29));

  void checkBarcode(String value) {
    if (!_storedBarcodes.contains(value)) {
    _storedBarcodes.add(value);
    _barcodeCount = _storedBarcodes.length;
    notifyListeners();
    }
  }

  void cleareBarcodes() {
    _storedBarcodes.clear();
    _barcodeCount = _storedBarcodes.length;
    notifyListeners();
  }
}