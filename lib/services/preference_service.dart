import 'package:itavero_mobile/models/connection_model.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferenceService {

  final String APP_SETTINGS = 'app_settings';

  Future saveSettings(SettingsModel settingsModel) async
  {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(APP_SETTINGS, jsonEncode(settingsModel.toJSON()));
    print("saved Settings");
  }

  Future<SettingsModel> getSettings() async
  {

    final preferences = await SharedPreferences.getInstance();
    var jsonString = preferences.getString(APP_SETTINGS);
    if (jsonString == null)
      {
        return SettingsModel(verbindungen: []);
      }
    Map<String,dynamic> jsonMap =  jsonDecode(jsonString!);
    return SettingsModel.fromJSON(jsonMap);




  }

}