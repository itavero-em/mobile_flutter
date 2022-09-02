import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/services/preference_service.dart';


class SettingsProvider extends ChangeNotifier{

  final SettingsModel settingsModel;

  SettingsProvider({
    required this.settingsModel
  });

  final _preferences = PreferenceService();
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
    if (removeConnection == settingsModel.aktiveVerbindung)
      {
        settingsModel.aktiveVerbindung = SettingsModel.noConnectionModel;
      }
    settingsModel.verbindungen.remove(removeConnection);
    _modelChanged();
  }

  void setAktivVerbindung(ConnectionModel connection){
    settingsModel.aktiveVerbindung = connection;
    _modelChanged();
  }
}