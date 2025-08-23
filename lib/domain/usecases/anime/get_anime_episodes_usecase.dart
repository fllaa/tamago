import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:tamago/domain/repositories/anime_repository.dart';

class GetAnimeEpisodesUseCase {
  final AnimeRepository repository;

  GetAnimeEpisodesUseCase({required this.repository});

  Future<List<Episode>> call(int malId, {int page = 1}) async {
    return await repository.getAnimeEpisodes(malId, page: page);
  }
}