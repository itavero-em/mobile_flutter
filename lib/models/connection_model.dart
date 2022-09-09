import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'settings_model.dart';

@JsonSerializable()
class ConnectionModel {
  @JsonKey(name: 'name')
  String name = '';
  @JsonKey(name: 'url')
  String url = '';

//<editor-fold desc="Data Methods">

  ConnectionModel({required this.name, required this.url});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConnectionModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          url == other.url);

  @override
  int get hashCode => name.hashCode ^ url.hashCode;

  @override
  String toString() {
    return 'ClassModel{' + ' name: $name,' + ' url: $url,' + '}';
  }

  ConnectionModel copyWith({
    String? name,
    String? url,
  }) {
    return ConnectionModel(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'url': this.url,
    };
  }

  factory ConnectionModel.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty || (map['name'] as String).isEmpty && (map['url'] as String).isEmpty) {
      return SettingsModel.noConnectionModel;
    } else {
      return ConnectionModel(
        name: map['name'] as String,
        url: map['url'] as String,
      );
    }
  }

}
