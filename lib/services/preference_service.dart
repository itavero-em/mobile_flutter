import 'package:itavero_mobile/models/connection_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {

  Future saveSettings(ConnectionModel selctedConnectionModel,
      List<ConnectionModel> listOfConnection) async
  {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString("url", selctedConnectionModel.url);
    await preferences.setString("name", selctedConnectionModel.name);

    print("saved Settings");
  }

  Future<ConnectionModel> getSettings() async
  {
    final preferences = await SharedPreferences.getInstance();
     var url = preferences.getString('url') ?? '';
    var name = preferences.getString('name') ?? '';
    return ConnectionModel(url: url, name: name);
  }

}