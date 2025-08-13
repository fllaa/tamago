import 'package:flutter_boilerplate/core/services/anime_service.dart';
import 'package:flutter_boilerplate/domain/repositories/anime_repository.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  final AnimeService animeService;

  AnimeRepositoryImpl({required this.animeService});

  @override
  Future<List<Anime>> getTopAnimes() async {
    try {
      final animeList = await animeService.getTopAnime();
      return animeList;
    } catch (e) {
      throw Exception('Failed to fetch top animes: $e');
    }
  }

  @override
  Future<List<Anime>> getSeasonNowAnimes() async {
    try {
      final animeList = await animeService.getSeasonNow();
      return animeList;
    } catch (e) {
      throw Exception('Failed to fetch season now animes: $e');
    }
  }

  @override
  Future<List<Anime>> getSeasonUpcomingAnimes() async {
    try {
      final animeList = await animeService.getSeasonUpcoming();
      return animeList;
    } catch (e) {
      throw Exception('Failed to fetch season upcoming animes: $e');
    }
  }
}
