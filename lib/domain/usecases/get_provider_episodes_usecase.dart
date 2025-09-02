import 'package:tamago/domain/entities/anime_episode.dart';
import 'package:tamago/domain/repositories/anime_provider_repository.dart';

class GetProviderEpisodesUseCase {
  final AnimeProviderRepository repository;

  GetProviderEpisodesUseCase(this.repository);

  Future<List<AnimeEpisode>> call(int malId, String providerName) async {
    return await repository.getAnimeEpisodes(malId, providerName);
  }
}