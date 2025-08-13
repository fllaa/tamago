import 'package:jikan_api_v4/jikan_api_v4.dart';

abstract class AnimeRepository {
  Future<List<Anime>> getTopAnimes();
  Future<List<Anime>> getSeasonNowAnimes();
  Future<List<Anime>> getSeasonUpcomingAnimes();
}
