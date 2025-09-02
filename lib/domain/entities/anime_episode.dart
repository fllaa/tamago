class AnimeEpisode {
  final int malId;
  final DateTime createdAt;
  final String providerName;
  final double episode;
  final String path;

  const AnimeEpisode({
    required this.malId,
    required this.createdAt,
    required this.providerName,
    required this.episode,
    required this.path,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimeEpisode &&
        other.malId == malId &&
        other.createdAt == createdAt &&
        other.providerName == providerName &&
        other.episode == episode &&
        other.path == path;
  }

  @override
  int get hashCode {
    return malId.hashCode ^
        createdAt.hashCode ^
        providerName.hashCode ^
        episode.hashCode ^
        path.hashCode;
  }

  @override
  String toString() {
    return 'AnimeEpisode(malId: $malId, providerName: $providerName, episode: $episode, path: $path)';
  }
}