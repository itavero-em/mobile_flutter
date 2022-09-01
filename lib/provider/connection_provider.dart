import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/services/preference_service.dart';


class ConnectionProvider extends ChangeNotifier{
  final List<ConnectionModel> _items = [
    // DEFAULT-Verbindungen
    ConnectionModel(name: "Test01", url: "http://www.google.de")
  ];

  final _preferences = PreferenceService();
  ConnectionModel aktivConnection = ConnectionModel(name: "Keine Verbindung (Dummy URL)",url:"https://itavwdmz01.itavero.de:8443/web_erp/");
  // Eine nicht veränderbare Liste beim get zurückgeben,
  // damit diese nicht willkürlich verändert wird
  UnmodifiableListView<ConnectionModel> get items => UnmodifiableListView(_items);

  void add(ConnectionModel newConnection){
    _items.add(newConnection);
    _preferences.saveSettings(newConnection, _items);
    notifyListeners();
  }

  void remove(ConnectionModel removeConnection){
    _items.remove(removeConnection);
    notifyListeners();
  }

  void setAktivConnection(ConnectionModel connection){
    aktivConnection = connection;
    var saveSettings = _preferences.saveSettings(aktivConnection, _items);
    saveSettings.whenComplete(() => print('Speichern der Verbindung erfoglreich: $aktivConnection'));
    notifyListeners();
  }
}