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
      showIntro: json['show_intro'] as bool,
      pushMessageEnabled: json['push_benachrichtigungen'] as bool,
      scanditAktiv: json['scandit_aktiv'] as bool? ?? true,
      scanditManualScan: json['manual_scan'] as bool? ?? false,
      scanMode: $enumDecode(_$ScanModeEnumMap, json['scan_mode'] ?? 'single'),
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'verbindungen': instance.verbindungen,
      'aktive_verbindung': instance.aktiveVerbindung,
      'scan_viewfindermode':
          _$ScanViewFinderModeEnumMap[instance.scanViewFinderMode]!,
      'kamera_licht': instance.cameraLight,
      'show_intro': instance.showIntro,
      'push_benachrichtigungen': instance.pushMessageEnabled,
      'scandit_aktiv': instance.scanditAktiv,
      'manual_scan': instance.scanditManualScan,
      'scan_mode': _$ScanModeEnumMap[instance.scanMode]!,
    };

const _$ScanViewFinderModeEnumMap = {
  ScanViewFinderMode.line: 'line',
  ScanViewFinderMode.rectangle: 'rectangle',
  ScanViewFinderMode.aimer: 'aimer',
};

const _$ScanModeEnumMap = {
  ScanMode.single: 'single',
  ScanMode.multi: 'multi',
};
