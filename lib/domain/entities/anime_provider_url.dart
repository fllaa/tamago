class AnimeProviderUrl {
  final int malId;
  final String providerName;
  final DateTime createdAt;
  final String path;

  const AnimeProviderUrl({
    required this.malId,
    required this.providerName,
    required this.createdAt,
    required this.path,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimeProviderUrl &&
        other.malId == malId &&
        other.providerName == providerName &&
        other.createdAt == createdAt &&
        other.path == path;
  }

  @override
  int get hashCode {
    return malId.hashCode ^
        providerName.hashCode ^
        createdAt.hashCode ^
        path.hashCode;
  }

  @override
  String toString() {
    return 'AnimeProviderUrl(malId: $malId, providerName: $providerName, path: $path)';
  }
}