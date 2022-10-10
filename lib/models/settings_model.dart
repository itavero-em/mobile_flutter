import 'connection_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

enum ScanViewFinderMode {
  line("Linie"), // You can also use numbers as you wish
  rectangle("Rechteck"),
  aimer("Fadenkreuz");

  final dynamic jsonValue;
  const ScanViewFinderMode(this.jsonValue);
  static ScanViewFinderMode fromValue(jsonValue) =>
      ScanViewFinderMode.values.singleWhere((i) => jsonValue == i.jsonValue);
}

enum ScanMode {
  single("SingleScan"), // You can also use numbers as you wish
  multi("MultiScan"),
  all("ScanAll");

  final dynamic jsonValue;
  const ScanMode(this.jsonValue);
  static ScanMode fromValue(jsonValue) =>
      ScanMode.values.singleWhere((i) => jsonValue == i.jsonValue);
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

  @JsonKey(name: 'scan_mode')
  ScanMode scanMode = ScanMode.single;

  @JsonKey(name: 'kamera_licht')
  bool cameraLight = false;

  @JsonKey(name: 'push_benachrichtigungen')
  bool pushMessageEnabled = false;

  SettingsModel(
      {required this.verbindungen,
      required this.aktiveVerbindung,
      required this.scanViewFinderMode,
      required this.cameraLight,
      required this.pushMessageEnabled});

  // Deserialisieren
  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
  // Serialisieren
  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}
