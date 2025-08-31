import 'package:tamago/domain/entities/anime_provider.dart';

class AnimeProviderModel extends AnimeProvider {
  const AnimeProviderModel({
    required super.name,
    required super.createdAt,
    required super.baseUrl,
    required super.qsSearch,
    required super.searchSelector,
    super.additionalQs,
  });

  factory AnimeProviderModel.fromJson(Map<String, dynamic> json) {
    return AnimeProviderModel(
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      baseUrl: json['base_url'] as String,
      qsSearch: json['qs_search'] as String,
      searchSelector: json['search_selector'] as String,
      additionalQs: json['additional_qs'] as String?,
    );
  }

  factory AnimeProviderModel.fromEntity(AnimeProvider provider) {
    return AnimeProviderModel(
      name: provider.name,
      createdAt: provider.createdAt,
      baseUrl: provider.baseUrl,
      qsSearch: provider.qsSearch,
      searchSelector: provider.searchSelector,
      additionalQs: provider.additionalQs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'base_url': baseUrl,
      'qs_search': qsSearch,
      'search_selector': searchSelector,
      'additional_qs': additionalQs,
    };
  }

  AnimeProvider toEntity() {
    return AnimeProvider(
      name: name,
      createdAt: createdAt,
      baseUrl: baseUrl,
      qsSearch: qsSearch,
      searchSelector: searchSelector,
      additionalQs: additionalQs,
    );
  }
}