import 'connection_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SettingsModel
{
  @JsonKey(name: 'verbindungen')
  final List<ConnectionModel> verbindungen;
  const SettingsModel({required this.verbindungen});


  Map<String, dynamic> toJson() {
    return {

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
  );
}
  // factory SettingsModel.fromJSON(Map<String, dynamic> map) {
  //   return SettingsModel(
  //     verbindungen: map['verbindungen'] as List<ConnectionModel>,
  //   );
  // }


}