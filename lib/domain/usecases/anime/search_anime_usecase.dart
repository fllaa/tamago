import 'package:tamago/domain/repositories/anime_repository.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

class SearchAnimeUseCase {
  final AnimeRepository repository;

  SearchAnimeUseCase({required this.repository});

  Future<List<Anime>> call(String query, {int page = 1}) async {
    return await repository.searchAnime(query, page: page);
  }
}
