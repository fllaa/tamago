import 'package:jikan_api_v4/jikan_api_v4.dart';

class AnimeService {
  static AnimeService? _instance;
  static late Jikan _jikan;

  static AnimeService get instance {
    _instance ??= AnimeService._internal();
    return _instance!;
  }

  AnimeService._internal() {
    _jikan = Jikan();
  }

  // Get current season anime
  Future<List<Anime>> getSeasonNow({int page = 1}) async {
    try {
      final response = await _jikan.getSeasonNow(page: page);
      // filter mal_id should be unique, because there has duplicate item on response, e.g: [{mal_id: 1, ...}, {mal_id: 1, ...}] => [{mal_id: 1, ...}]
      final unique = <int, Anime>{};
      for (final anime in response) {
        unique[anime.malId] = anime;
      }
      return unique.values.toList();
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  // Get upcoming season anime
  Future<List<Anime>> getSeasonUpcoming({int page = 1}) async {
    try {
      final response = await _jikan.getSeasonUpcoming(page: page);
      return response.toList();
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  // Get top anime
  Future<List<Anime>> getTopAnime(
      {AnimeType? type, TopFilter? filter, int page = 1}) async {
    try {
      final response =
          await _jikan.getTopAnime(type: type, filter: filter, page: page);
      return response.toList();
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  // Get anime by mal_id
  Future<Anime?> getAnime(int malId) async {
    try {
      final response = await _jikan.getAnime(malId);
      return response;
    } catch (e) {
      // Return null if there's an error
      return null;
    }
  }

  // Get anime episodes by mal_id
  Future<List<Episode>> getAnimeEpisodes(int malId, {int page = 1}) async {
    try {
      final response = await _jikan.getAnimeEpisodes(malId, page: page);
      return response.toList();
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  // Get anime recommendations by mal_id
  Future<List<Recommendation>> getAnimeRecommendations(int malId) async {
    try {
      final response = await _jikan.getAnimeRecommendations(malId);
      return response.toList();
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }
}
