import 'connection_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SettingsModel
{
  static const noConnectionModel = ConnectionModel(name: 'Keine Verbindung!!', url: '');

  @JsonKey(name: 'verbindungen')
  final List<ConnectionModel> verbindungen;
  @JsonKey(name: 'aktive_verbindung')
  ConnectionModel aktiveVerbindung;


  SettingsModel({required this.verbindungen, required this.aktiveVerbindung});


  Map<String, dynamic> toJson() {
    return {

      'aktive_verbindung': this.aktiveVerbindung,
      'verbindungen': this.verbindungen,

    };
  }
factory SettingsModel.fromJson(Map<String, dynamic> map) {

  var v = map['verbindungen'] as List<dynamic>;
  var list = v.map((e) =>
  ConnectionModel.fromJson(e)
  ).toList();

  return SettingsModel(
    verbindungen:  list,
    aktiveVerbindung: ConnectionModel.fromJson(map['aktive_verbindung'])
  );
}
  // factory SettingsModel.fromJSON(Map<String, dynamic> map) {
  //   return SettingsModel(
  //     verbindungen: map['verbindungen'] as List<ConnectionModel>,
  //   );
  // }


}