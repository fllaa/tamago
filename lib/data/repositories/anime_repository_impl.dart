import 'dart:convert';
import 'dart:developer';
import 'package:tamago/core/constants/app_constants.dart';
import 'package:tamago/core/services/anime_service.dart';
import 'package:tamago/core/services/storage_service.dart';
import 'package:tamago/domain/repositories/anime_repository.dart';
import 'package:tamago/domain/entities/anime_detail_result.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

class AnimeRepositoryImpl implements AnimeRepository {
  final AnimeService animeService;
  final StorageService storageService;

  // Cache keys
  static const String _topAnimesCacheKey = 'top_animes_cache';
  static const String _seasonNowCacheKey = 'season_now_cache';
  static const String _seasonUpcomingCacheKey = 'season_upcoming_cache';
  static const String _animeDetailCacheKeyPrefix = 'anime_detail_cache_';
  static const String _animeEpisodesCacheKeyPrefix = 'anime_episodes_cache_';
  static const String _animeRecommendationsCacheKeyPrefix = 'anime_recommendations_cache_';
  static const String _animeReviewsCacheKeyPrefix = 'anime_reviews_cache_';
  static const String _topAnimesTimestampKey = 'top_animes_timestamp';
  static const String _seasonNowTimestampKey = 'season_now_timestamp';
  static const String _seasonUpcomingTimestampKey = 'season_upcoming_timestamp';
  static const String _animeDetailTimestampKeyPrefix =
      'anime_detail_timestamp_';
  static const String _animeEpisodesTimestampKeyPrefix =
      'anime_episodes_timestamp_';
  static const String _animeRecommendationsTimestampKeyPrefix =
      'anime_recommendations_timestamp_';
  static const String _animeReviewsTimestampKeyPrefix =
      'anime_reviews_timestamp_';

  AnimeRepositoryImpl({
    required this.animeService,
    required this.storageService,
  });

  @override
  Future<List<Anime>> getTopAnimes() async {
    try {
      // Check cache first
      final cachedData =
          await _getFromCache(_topAnimesCacheKey, _topAnimesTimestampKey);
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch from API if cache is invalid or empty
      final animeList = await animeService.getTopAnime();

      // Save to cache
      await _saveToCache(_topAnimesCacheKey, _topAnimesTimestampKey, animeList);

      return animeList;
    } catch (e) {
      // Try to return cached data even if it's expired in case of network error
      final cachedData = await _getFromCacheIgnoreExpiry(_topAnimesCacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch top animes: $e');
    }
  }

  @override
  Future<List<Anime>> getSeasonNowAnimes() async {
    try {
      // Check cache first
      final cachedData =
          await _getFromCache(_seasonNowCacheKey, _seasonNowTimestampKey);
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch from API if cache is invalid or empty
      final animeList = await animeService.getSeasonNow();

      // Save to cache
      await _saveToCache(_seasonNowCacheKey, _seasonNowTimestampKey, animeList);

      return animeList;
    } catch (e) {
      // Try to return cached data even if it's expired in case of network error
      final cachedData = await _getFromCacheIgnoreExpiry(_seasonNowCacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch season now animes: $e');
    }
  }

  @override
  Future<List<Anime>> getSeasonUpcomingAnimes() async {
    try {
      // Check cache first
      final cachedData = await _getFromCache(
          _seasonUpcomingCacheKey, _seasonUpcomingTimestampKey);
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch from API if cache is invalid or empty
      final animeList = await animeService.getSeasonUpcoming();

      // Save to cache
      await _saveToCache(
          _seasonUpcomingCacheKey, _seasonUpcomingTimestampKey, animeList);

      return animeList;
    } catch (e) {
      // Try to return cached data even if it's expired in case of network error
      final cachedData =
          await _getFromCacheIgnoreExpiry(_seasonUpcomingCacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch season upcoming animes: $e');
    }
  }

  @override
  Future<AnimeDetailResult> getAnimeDetail(int malId) async {
    try {
      final cacheKey = '$_animeDetailCacheKeyPrefix$malId';
      final timestampKey = '$_animeDetailTimestampKeyPrefix$malId';

      // Check cache first
      final cachedData = await _getAnimeDetailFromCache(cacheKey, timestampKey);
      if (cachedData != null) {
        return AnimeDetailResult(anime: cachedData, isFromCache: true);
      }

      // Fetch from API if cache is invalid or empty
      final anime = await animeService.getAnime(malId);

      // Save to cache if anime is found
      if (anime != null) {
        await _saveAnimeDetailToCache(cacheKey, timestampKey, anime);
      }

      return AnimeDetailResult(anime: anime, isFromCache: false);
    } catch (e) {
      // Try to return cached data even if it's expired in case of network error
      final cacheKey = '$_animeDetailCacheKeyPrefix$malId';
      final cachedData = await _getAnimeDetailFromCacheIgnoreExpiry(cacheKey);
      if (cachedData != null) {
        return AnimeDetailResult(anime: cachedData, isFromCache: true);
      }
      throw Exception('Failed to fetch anime detail: $e');
    }
  }

  @override
  Future<List<Episode>> getAnimeEpisodes(int malId, {int page = 1}) async {
    try {
      final cacheKey = '$_animeEpisodesCacheKeyPrefix${malId}_$page';
      final timestampKey = '$_animeEpisodesTimestampKeyPrefix${malId}_$page';

      // Check cache first
      final cachedData = await _getEpisodesFromCache(cacheKey, timestampKey);
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch from API if cache is invalid or empty
      final episodes = await animeService.getAnimeEpisodes(malId, page: page);

      // Save to cache
      await _saveEpisodesToCache(cacheKey, timestampKey, episodes);

      return episodes;
    } catch (e) {
      // Try to return cached data even if it's expired in case of network error
      final cacheKey = '$_animeEpisodesCacheKeyPrefix${malId}_$page';
      final cachedData = await _getEpisodesFromCacheIgnoreExpiry(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch anime episodes: $e');
    }
  }

  @override
  Future<List<Recommendation>> getAnimeRecommendations(int malId) async {
    try {
      final cacheKey = '$_animeRecommendationsCacheKeyPrefix$malId';
      final timestampKey = '$_animeRecommendationsTimestampKeyPrefix$malId';

      // Check cache first
      final cachedData = await _getRecommendationsFromCache(cacheKey, timestampKey);
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch from API if cache is invalid or empty
      final recommendations = await animeService.getAnimeRecommendations(malId);

      // Save to cache
      await _saveRecommendationsToCache(cacheKey, timestampKey, recommendations);

      return recommendations;
    } catch (e) {
      // Try to return cached data even if it's expired in case of network error
      final cacheKey = '$_animeRecommendationsCacheKeyPrefix$malId';
      final cachedData = await _getRecommendationsFromCacheIgnoreExpiry(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch anime recommendations: $e');
    }
  }

  @override
  Future<List<Review>> getAnimeReviews(int malId, {int page = 1}) async {
    try {
      final cacheKey = '$_animeReviewsCacheKeyPrefix${malId}_$page';
      final timestampKey = '$_animeReviewsTimestampKeyPrefix${malId}_$page';

      // Check cache first
      final cachedData = await _getReviewsFromCache(cacheKey, timestampKey);
      if (cachedData != null) {
        return cachedData;
      }

      // Fetch from API if cache is invalid or empty
      final reviews = await animeService.getAnimeReviews(malId, page: page);

      // Save to cache
      await _saveReviewsToCache(cacheKey, timestampKey, reviews);

      return reviews;
    } catch (e) {
      // Try to return cached data even if it's expired in case of network error
      final cacheKey = '$_animeReviewsCacheKeyPrefix${malId}_$page';
      final cachedData = await _getReviewsFromCacheIgnoreExpiry(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('Failed to fetch anime reviews: $e');
    }
  }

  // Helper method to check if cache is valid and return cached data
  Future<List<Anime>?> _getFromCache(
      String cacheKey, String timestampKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);
      final timestampString = await storageService.get(timestampKey);

      if (cachedJson == null || timestampString == null) {
        return null;
      }

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      // Check if cache is still valid (within 24 hours)
      if (now.difference(timestamp) >
          Duration(seconds: AppConstants.defaultCacheValidityDuration)) {
        return null;
      }

      final animeList = (jsonDecode(cachedJson) as List)
          .map((json) => Anime.fromJson(json))
          .toList();

      return animeList;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get cached data ignoring expiry (for fallback)
  Future<List<Anime>?> _getFromCacheIgnoreExpiry(String cacheKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);

      if (cachedJson == null) {
        return null;
      }

      final animeList = (jsonDecode(cachedJson) as List)
          .map((json) => Anime.fromJson(json))
          .toList();

      return animeList;
    } catch (e) {
      return null;
    }
  }

  // Helper method to save data to cache
  Future<void> _saveToCache(
      String cacheKey, String timestampKey, List<Anime> animeList) async {
    try {
      await Future.wait([
        storageService.set(
          cacheKey,
          jsonEncode(animeList.map((anime) => anime.toJson()).toList()),
        ),
        storageService.set(
          timestampKey,
          DateTime.now().toIso8601String(),
        ),
      ]);
    } catch (e) {
      // Silently fail cache save
    }
  }

  // Helper method to check if anime detail cache is valid and return cached data
  Future<Anime?> _getAnimeDetailFromCache(
      String cacheKey, String timestampKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);
      final timestampString = await storageService.get(timestampKey);

      if (cachedJson == null || timestampString == null) {
        return null;
      }

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      // Check if cache is still valid (within 24 hours)
      if (now.difference(timestamp) >
          Duration(seconds: AppConstants.defaultCacheValidityDuration)) {
        return null;
      }

      final anime = Anime.fromJson(jsonDecode(cachedJson));

      return anime;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get anime detail cached data ignoring expiry (for fallback)
  Future<Anime?> _getAnimeDetailFromCacheIgnoreExpiry(String cacheKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);

      if (cachedJson == null) {
        return null;
      }

      final anime = Anime.fromJson(jsonDecode(cachedJson));

      return anime;
    } catch (e) {
      return null;
    }
  }

  // Helper method to save anime detail to cache
  Future<void> _saveAnimeDetailToCache(
      String cacheKey, String timestampKey, Anime anime) async {
    try {
      await Future.wait([
        storageService.set(
          cacheKey,
          jsonEncode(anime.toJson()),
        ),
        storageService.set(
          timestampKey,
          DateTime.now().toIso8601String(),
        ),
      ]);
    } catch (e) {
      // Silently fail cache save
    }
  }

  // Helper method to check if episodes cache is valid and return cached data
  Future<List<Episode>?> _getEpisodesFromCache(
      String cacheKey, String timestampKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);
      final timestampString = await storageService.get(timestampKey);

      if (cachedJson == null || timestampString == null) {
        return null;
      }

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      // Check if cache is still valid (within 24 hours)
      if (now.difference(timestamp) >
          Duration(seconds: AppConstants.defaultCacheValidityDuration)) {
        return null;
      }

      final episodes = (jsonDecode(cachedJson) as List)
          .map((json) => Episode.fromJson(json))
          .toList();

      return episodes;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get episodes cached data ignoring expiry (for fallback)
  Future<List<Episode>?> _getEpisodesFromCacheIgnoreExpiry(
      String cacheKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);

      if (cachedJson == null) {
        return null;
      }

      final episodes = (jsonDecode(cachedJson) as List)
          .map((json) => Episode.fromJson(json))
          .toList();

      return episodes;
    } catch (e) {
      return null;
    }
  }

  // Helper method to save episodes to cache
  Future<void> _saveEpisodesToCache(
      String cacheKey, String timestampKey, List<Episode> episodes) async {
    try {
      await Future.wait([
        storageService.set(
          cacheKey,
          jsonEncode(episodes.map((e) => e.toJson()).toList()),
        ),
        storageService.set(
          timestampKey,
          DateTime.now().toIso8601String(),
        ),
      ]);
    } catch (e) {
      // Silently fail cache save
    }
  }

  // Helper method to check if recommendations cache is valid and return cached data
  Future<List<Recommendation>?> _getRecommendationsFromCache(
      String cacheKey, String timestampKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);
      final timestampString = await storageService.get(timestampKey);

      if (cachedJson == null || timestampString == null) {
        return null;
      }

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      // Check if cache is still valid (within 24 hours)
      if (now.difference(timestamp) >
          Duration(seconds: AppConstants.defaultCacheValidityDuration)) {
        return null;
      }

      final recommendations = (jsonDecode(cachedJson) as List)
          .map((json) => Recommendation.fromJson(json))
          .toList();

      return recommendations;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get recommendations cached data ignoring expiry (for fallback)
  Future<List<Recommendation>?> _getRecommendationsFromCacheIgnoreExpiry(
      String cacheKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);

      if (cachedJson == null) {
        return null;
      }

      final recommendations = (jsonDecode(cachedJson) as List)
          .map((json) => Recommendation.fromJson(json))
          .toList();

      return recommendations;
    } catch (e) {
      return null;
    }
  }

  // Helper method to save recommendations to cache
  Future<void> _saveRecommendationsToCache(
      String cacheKey, String timestampKey, List<Recommendation> recommendations) async {
    try {
      await Future.wait([
        storageService.set(
          cacheKey,
          jsonEncode(recommendations.map((r) => r.toJson()).toList()),
        ),
        storageService.set(
          timestampKey,
          DateTime.now().toIso8601String(),
        ),
      ]);
    } catch (e) {
      // Silently fail cache save
    }
  }

  // Helper method to check if reviews cache is valid and return cached data
  Future<List<Review>?> _getReviewsFromCache(
      String cacheKey, String timestampKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);
      final timestampString = await storageService.get(timestampKey);

      if (cachedJson == null || timestampString == null) {
        return null;
      }

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      // Check if cache is still valid (within 24 hours)
      if (now.difference(timestamp) >
          Duration(seconds: AppConstants.defaultCacheValidityDuration)) {
        return null;
      }

      final reviews = (jsonDecode(cachedJson) as List)
          .map((json) => Review.fromJson(json))
          .toList();

      return reviews;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get reviews cached data ignoring expiry (for fallback)
  Future<List<Review>?> _getReviewsFromCacheIgnoreExpiry(
      String cacheKey) async {
    try {
      final cachedJson = await storageService.get(cacheKey);

      if (cachedJson == null) {
        return null;
      }

      final reviews = (jsonDecode(cachedJson) as List)
          .map((json) => Review.fromJson(json))
          .toList();

      return reviews;
    } catch (e) {
      return null;
    }
  }

  // Helper method to save reviews to cache
  Future<void> _saveReviewsToCache(
      String cacheKey, String timestampKey, List<Review> reviews) async {
    try {
      await Future.wait([
        storageService.set(
          cacheKey,
          jsonEncode(reviews.map((r) => r.toJson()).toList()),
        ),
        storageService.set(
          timestampKey,
          DateTime.now().toIso8601String(),
        ),
      ]);
    } catch (e) {
      // Silently fail cache save
    }
  }
}
