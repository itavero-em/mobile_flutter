// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      verbindungen: (json['verbindungen'] as List<dynamic>)
          .map((e) => ConnectionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aktiveVerbindung: ConnectionModel.fromJson(
          json['aktive_verbindung'] as Map<String, dynamic>),
      scanViewFinderMode:
          $enumDecode(_$ScanViewFinderModeEnumMap, json['scan_viewfindermode']),
      cameraLight: json['kamera_licht'] as bool,
      pushMessageEnabled: json['push_benachrichtigungen'] as bool,
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'verbindungen': instance.verbindungen,
      'aktive_verbindung': instance.aktiveVerbindung,
      'scan_viewfindermode':
          _$ScanViewFinderModeEnumMap[instance.scanViewFinderMode]!,
      'kamera_licht': instance.cameraLight,
      'push_benachrichtigungen': instance.pushMessageEnabled,
    };

const _$ScanViewFinderModeEnumMap = {
  ScanViewFinderMode.line: 'line',
  ScanViewFinderMode.rectangle: 'rectangle',
  ScanViewFinderMode.aimer: 'aimer',
};
