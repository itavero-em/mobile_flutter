import 'connection_model.dart';

class SettingsModel
{
  final List<ConnectionModel> verbindungen;

  const SettingsModel({required this.verbindungen});


  Map<String, dynamic> toJSON() {
    return {
      'verbindungen': this.verbindungen,
    };
  }

  factory SettingsModel.fromJSON(Map<String, dynamic> map) {
    return SettingsModel(
      verbindungen: map['verbindungen'] as List<ConnectionModel>,
    );
  }


}