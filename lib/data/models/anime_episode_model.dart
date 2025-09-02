import 'package:tamago/domain/entities/anime_episode.dart';

class AnimeEpisodeModel extends AnimeEpisode {
  const AnimeEpisodeModel({
    required super.malId,
    required super.createdAt,
    required super.providerName,
    required super.episode,
    required super.path,
  });

  factory AnimeEpisodeModel.fromJson(Map<String, dynamic> json) {
    return AnimeEpisodeModel(
      malId: json['mal_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      providerName: json['provider_name'] as String,
      episode: (json['episode'] as num).toDouble(),
      path: json['path'] as String,
    );
  }

  factory AnimeEpisodeModel.fromEntity(AnimeEpisode episode) {
    return AnimeEpisodeModel(
      malId: episode.malId,
      createdAt: episode.createdAt,
      providerName: episode.providerName,
      episode: episode.episode,
      path: episode.path,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'created_at': createdAt.toIso8601String(),
      'provider_name': providerName,
      'episode': episode,
      'path': path,
    };
  }

  AnimeEpisode toEntity() {
    return AnimeEpisode(
      malId: malId,
      createdAt: createdAt,
      providerName: providerName,
      episode: episode,
      path: path,
    );
  }
}
