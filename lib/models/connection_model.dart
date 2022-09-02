import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ConnectionModel {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'url')
  final String url;

//<editor-fold desc="Data Methods">

  const ConnectionModel({required this.name, required this.url});

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
    return ConnectionModel(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  // static String encode(List<ConnectionModel> connections) => json.encode(
  //       connections
  //           .map<Map<String, dynamic>>(
  //               (connection) => ConnectionModel.toJSON(connection))
  //           .toList(),
  //     );
  //
  // static List<ConnectionModel> decode(String ConnectionModels) =>
  //     (json.decode(ConnectionModels) as List<dynamic>)
  //         .map<ConnectionModel>((item) => ConnectionModel.fromJSON(item))
  //         .toList();

//</editor-fold>
}
