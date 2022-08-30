class ConnectionModel{
  final String name;
  final String url;

//<editor-fold desc="Data Methods">

  const ConnectionModel({
    required this.name,
    required this.url
  });

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
    return 'ClassModel{' + ' name: $name,'+ ' url: $url,' + '}';
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

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'url': this.url,
    };
  }

  factory ConnectionModel.fromMap(Map<String, dynamic> map) {
    return ConnectionModel(
      name: map['name'] as String,
        url: map['url'] as String,
    );
  }

//</editor-fold>
}