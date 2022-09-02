import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferenceService {

  final String APP_SETTINGS = 'app_settings';

  Future saveSettings(SettingsModel settingsModel) async
  {
    final preferences = await SharedPreferences.getInstance();
    var settingsJson = await settingsModel.toJson();
    var encodedJSON = await jsonEncode(settingsJson);
    await preferences.setString(APP_SETTINGS, encodedJSON);
    print("saved Settings");
  }

  Future<SettingsModel> getSettings() async
  {

    final preferences = await SharedPreferences.getInstance();
    var jsonString = await preferences.getString(APP_SETTINGS);
    if (jsonString == null)
      {
        return SettingsModel(verbindungen: [],aktiveVerbindung: SettingsModel.noConnectionModel);
      } else {
      Map<String, dynamic> jsonMap = await jsonDecode(jsonString);
      return SettingsModel.fromJson(jsonMap);
    }
  }

}