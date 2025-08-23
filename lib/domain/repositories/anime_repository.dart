import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:tamago/domain/entities/anime_detail_result.dart';

abstract class AnimeRepository {
  Future<List<Anime>> getTopAnimes();
  Future<List<Anime>> getSeasonNowAnimes();
  Future<List<Anime>> getSeasonUpcomingAnimes();
  Future<AnimeDetailResult> getAnimeDetail(int malId);
  Future<List<Episode>> getAnimeEpisodes(int malId, {int page = 1});
}
