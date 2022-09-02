import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/services/preference_service.dart';


class SettingsProvider extends ChangeNotifier{

  final SettingsModel settingsModel = SettingsModel(verbindungen:  []);

  final _preferences = PreferenceService();
  ConnectionModel aktivConnection = ConnectionModel(name: "Keine Verbindung (Dummy URL)",url:"https://itavwdmz01.itavero.de:8443/web_erp/");
  // Eine nicht veränderbare Liste beim get zurückgeben,
  // damit diese nicht willkürlich verändert wird
  UnmodifiableListView<ConnectionModel> get verbindungen => UnmodifiableListView(settingsModel.verbindungen);

  _modelChanged()
  {
    _preferences.saveSettings(settingsModel);
    notifyListeners();
  }


  void addVerbindung(ConnectionModel newConnection){
    settingsModel.verbindungen.add(newConnection);
    _modelChanged();
  }

  void removeVerbindung(ConnectionModel removeConnection){
    settingsModel.verbindungen.remove(removeConnection);
    _modelChanged();
  }

  void setAktivVerbindung(ConnectionModel connection){
    aktivConnection = connection;
    //var saveSettings = _preferences.saveSettings(aktivConnection, _items);
    //saveSettings.whenComplete(() => print('Speichern der Verbindung erfoglreich: $aktivConnection'));
    _modelChanged();
  }
}