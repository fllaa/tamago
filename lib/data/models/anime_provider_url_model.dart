import 'package:tamago/domain/entities/anime_provider_url.dart';

class AnimeProviderUrlModel extends AnimeProviderUrl {
  const AnimeProviderUrlModel({
    required super.malId,
    required super.providerName,
    required super.createdAt,
    required super.path,
  });

  factory AnimeProviderUrlModel.fromJson(Map<String, dynamic> json) {
    return AnimeProviderUrlModel(
      malId: json['mal_id'] as int,
      providerName: json['provider_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      path: json['path'] as String,
    );
  }

  factory AnimeProviderUrlModel.fromEntity(AnimeProviderUrl providerUrl) {
    return AnimeProviderUrlModel(
      malId: providerUrl.malId,
      providerName: providerUrl.providerName,
      createdAt: providerUrl.createdAt,
      path: providerUrl.path,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'provider_name': providerName,
      'created_at': createdAt.toIso8601String(),
      'path': path,
    };
  }

  AnimeProviderUrl toEntity() {
    return AnimeProviderUrl(
      malId: malId,
      providerName: providerName,
      createdAt: createdAt,
      path: path,
    );
  }
}