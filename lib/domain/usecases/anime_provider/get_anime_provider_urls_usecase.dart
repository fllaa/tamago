import 'package:tamago/domain/entities/anime_provider_url.dart';
import 'package:tamago/domain/repositories/anime_provider_repository.dart';

class GetAnimeProviderUrlsUseCase {
  final AnimeProviderRepository repository;

  GetAnimeProviderUrlsUseCase({required this.repository});

  Future<List<AnimeProviderUrl>> call(int malId) async {
    return await repository.getAnimeProviderUrls(malId);
  }
}