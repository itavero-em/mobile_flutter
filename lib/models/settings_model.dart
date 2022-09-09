import 'connection_model.dart';
import 'package:json_annotation/json_annotation.dart';

enum ScanViewFinderMode {
  line("Linie"), // You can also use numbers as you wish
  rectangle("Rechteck"),
  aimer("Fadenkreuz");

  final dynamic jsonValue;
  const ScanViewFinderMode(this.jsonValue);
  static ScanViewFinderMode fromValue(jsonValue) =>
      ScanViewFinderMode.values.singleWhere((i) => jsonValue == i.jsonValue);
}

@JsonSerializable()
class SettingsModel {
  static ConnectionModel noConnectionModel =
      ConnectionModel(name: 'Keine Verbindung!!', url: '');

  @JsonKey(name: 'verbindungen')
  final List<ConnectionModel> verbindungen;
  @JsonKey(name: 'aktive_verbindung')
  ConnectionModel aktiveVerbindung;

  @JsonKey(name: 'scan_viewfindermode')
  ScanViewFinderMode scanViewFinderMode = ScanViewFinderMode.line;

  @JsonKey(name: 'kamera_licht')
  bool cameraLight = false;

  SettingsModel(
      {required this.verbindungen,
      required this.aktiveVerbindung,
      required this.scanViewFinderMode,
      required this.cameraLight});

  Map<String, dynamic> toJson() {
    return {
      'aktive_verbindung': this.aktiveVerbindung,
      'verbindungen': this.verbindungen,
      'scan_viewfindermode': this.scanViewFinderMode.jsonValue,
      'kamera_licht' : this.cameraLight
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> map) {
    var v = map['verbindungen'] as List<dynamic>;
    var list = v.map((e) => ConnectionModel.fromJson(e)).toList();
    var jsonViewFinderMode = map['scan_viewfindermode'];
    ScanViewFinderMode scanviewfindermode = ScanViewFinderMode.rectangle;
    if (jsonViewFinderMode != null)
      {
         scanviewfindermode = ScanViewFinderMode.fromValue( jsonViewFinderMode );

      }
    var camLight = false;
    if (map['kamera_licht'] != null)
      {
        camLight = map['kamera_licht'] as bool;
      }


    return SettingsModel(
        verbindungen: list,
        aktiveVerbindung: ConnectionModel.fromJson(map['aktive_verbindung']),
        scanViewFinderMode: scanviewfindermode,
      cameraLight: camLight
    );
  }
// factory SettingsModel.fromJSON(Map<String, dynamic> map) {
//   return SettingsModel(
//     verbindungen: map['verbindungen'] as List<ConnectionModel>,
//   );
// }

}
