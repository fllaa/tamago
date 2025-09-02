class AnimeProvider {
  final String name;
  final DateTime createdAt;
  final String baseUrl;
  final String qsSearch;
  final String searchSelector;
  final String? additionalQs;
  final String? episodeScript;

  const AnimeProvider({
    required this.name,
    required this.createdAt,
    required this.baseUrl,
    required this.qsSearch,
    required this.searchSelector,
    this.additionalQs,
    this.episodeScript,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimeProvider &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.baseUrl == baseUrl &&
        other.qsSearch == qsSearch &&
        other.searchSelector == searchSelector &&
        other.additionalQs == additionalQs &&
        other.episodeScript == episodeScript;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        createdAt.hashCode ^
        baseUrl.hashCode ^
        qsSearch.hashCode ^
        searchSelector.hashCode ^
        additionalQs.hashCode ^
        episodeScript.hashCode;
  }

  @override
  String toString() {
    return 'AnimeProvider(name: $name, baseUrl: $baseUrl, qsSearch: $qsSearch, searchSelector: $searchSelector, additionalQs: $additionalQs, episodeScript: $episodeScript)';
  }
}