import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:tamago/domain/entities/anime_detail_result.dart';

abstract class AnimeRepository {
  Future<List<Anime>> getTopAnimes();
  Future<List<Anime>> getSeasonNowAnimes();
  Future<List<Anime>> getSeasonUpcomingAnimes();
  Future<List<Anime>> searchAnime(String query, {int page = 1});
  Future<AnimeDetailResult> getAnimeDetail(int malId);
  Future<List<Episode>> getAnimeEpisodes(int malId, {int page = 1});
  Future<List<Recommendation>> getAnimeRecommendations(int malId);
  Future<List<Review>> getAnimeReviews(int malId, {int page = 1});
}
