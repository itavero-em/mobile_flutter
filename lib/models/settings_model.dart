import 'connection_model.dart';
import 'package:json_annotation/json_annotation.dart';

enum ScanViewFinderMode {
  line,
  rectangle,
  aimer;


String get string {
  switch (this) {
    case ScanViewFinderMode.aimer:
      return 'Fadenkreuz';
    case ScanViewFinderMode.line:
      return 'Linie';
    case ScanViewFinderMode.rectangle:
      return 'Rechteck';
  }
}
}






@JsonSerializable()
class SettingsModel
{
  static const noConnectionModel = ConnectionModel(name: 'Keine Verbindung!!', url: '');




  @JsonKey(name: 'verbindungen')
  final List<ConnectionModel> verbindungen;
  @JsonKey(name: 'aktive_verbindung')
  ConnectionModel aktiveVerbindung;

  @JsonKey(name: 'scan_viewfindermode')
  ScanViewFinderMode scanViewFinderMode = ScanViewFinderMode.line;


  SettingsModel({required this.verbindungen, required this.aktiveVerbindung, required this.scanViewFinderMode});


  Map<String, dynamic> toJson() {
    return {

      'aktive_verbindung': this.aktiveVerbindung,
      'verbindungen': this.verbindungen,
      'scan_viewfindermode': this.scanViewFinderMode,

    };
  }
factory SettingsModel.fromJson(Map<String, dynamic> map) {

  var v = map['verbindungen'] as List<dynamic>;
  var list = v.map((e) =>
  ConnectionModel.fromJson(e)
  ).toList();
  ScanViewFinderMode scanviewfindermode = ScanViewFinderMode.values.elementAt(map['scan_viewfindermode'] ?? 0);

  return SettingsModel(
    verbindungen:  list,
    aktiveVerbindung: ConnectionModel.fromJson(map['aktive_verbindung']),
      scanViewFinderMode: scanviewfindermode
  );
}
  // factory SettingsModel.fromJSON(Map<String, dynamic> map) {
  //   return SettingsModel(
  //     verbindungen: map['verbindungen'] as List<ConnectionModel>,
  //   );
  // }


}