import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferenceService {
  final String APP_SETTINGS = 'app_settings';

  Future saveSettings(SettingsModel settingsModel) async {
    final preferences = await SharedPreferences.getInstance();
    var settingsJson = await settingsModel.toJson();
    var encodedJSON = await jsonEncode(settingsJson);
    await preferences.setString(APP_SETTINGS, encodedJSON);
    print("saved Settings");
  }

  Future<SettingsModel> getSettings() async {
    final preferences = await SharedPreferences.getInstance();
    var jsonString = await preferences.getString(APP_SETTINGS);
    SettingsModel defaultModel = SettingsModel(
        verbindungen: [
          ConnectionModel(name: 'Hassia Echt', url: 'https://itavwdmz01.itavero.de:8443/web_erp'),

        ],
        aktiveVerbindung: SettingsModel.noConnectionModel,
        scanViewFinderMode: ScanViewFinderMode.line,
        cameraLight: false,
        pushMessageEnabled: false);
    if (jsonString == null) {
      return defaultModel;
    } else {
      Map<String, dynamic> jsonMap = await jsonDecode(jsonString);
      SettingsModel model;
      try {
        model = SettingsModel.fromJson(jsonMap);
      } catch (e) {
        model = defaultModel;
        //TODO: Toast -> Snackbar Info
      }
      return model;
    }
  }
}
