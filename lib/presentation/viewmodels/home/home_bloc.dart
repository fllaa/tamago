import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/core/services/storage_service.dart';
import 'package:tamago/domain/entities/genre.dart' as app_genre;
import 'package:tamago/domain/usecases/anime/get_season_now_animes_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_season_upcoming_animes_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_top_animes_usecase.dart';
import 'package:tamago/domain/usecases/get_highlighted_genres_usecase.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetSeasonNowAnimesUseCase _getSeasonNowAnimesUseCase;
  final GetSeasonUpcomingAnimesUseCase _getSeasonUpcomingAnimesUseCase;
  final GetTopAnimesUseCase _getTopAnimesUseCase;
  final GetHighlightedGenresUseCase _getHighlightedGenresUseCase;
  final StorageService _storageService;

  // Cache keys
  static const String _seasonNowCacheKey = 'season_now_animes_cache';
  static const String _seasonUpcomingCacheKey = 'season_upcoming_animes_cache';
  static const String _topAnimesCacheKey = 'top_animes_cache';
  static const String _genresCacheKey = 'genres_cache';
  static const String _cacheTimestampKey = 'home_data_cache_timestamp';

  // Cache duration (30 minutes)
  static const Duration _cacheDuration = Duration(minutes: 30);

  HomeBloc({
    required GetSeasonNowAnimesUseCase getSeasonNowAnimesUseCase,
    required GetSeasonUpcomingAnimesUseCase getSeasonUpcomingAnimesUseCase,
    required GetTopAnimesUseCase getTopAnimesUseCase,
    required GetHighlightedGenresUseCase getHighlightedGenresUseCase,
    required StorageService storageService,
  })  : _getSeasonNowAnimesUseCase = getSeasonNowAnimesUseCase,
        _getSeasonUpcomingAnimesUseCase = getSeasonUpcomingAnimesUseCase,
        _getTopAnimesUseCase = getTopAnimesUseCase,
        _getHighlightedGenresUseCase = getHighlightedGenresUseCase,
        _storageService = storageService,
        super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Check if we should use cache
      if (!event.forceRefresh && await _isCacheValid()) {
        final cachedData = await _loadFromCache();
        if (cachedData != null) {
          emit(cachedData);
          return;
        }
      }

      emit(HomeLoading());

      // Load fresh data
      final results = await Future.wait([
        _getSeasonNowAnimesUseCase(),
        _getSeasonUpcomingAnimesUseCase(),
        _getTopAnimesUseCase(),
        _getHighlightedGenresUseCase(),
      ]);

      final seasonNowAnimes = results[0] as List<Anime>;
      final seasonUpcomingAnimes = results[1] as List<Anime>;
      final topAnimes = results[2] as List<Anime>;
      final genres = results[3] as List<app_genre.Genre>;

      final homeLoaded = HomeLoaded(
        seasonNowAnimes: seasonNowAnimes,
        seasonUpcomingAnimes: seasonUpcomingAnimes,
        topAnimes: topAnimes,
        genres: genres,
        isFromCache: false,
      );

      // Cache the data
      await _saveToCache(homeLoaded);

      emit(homeLoaded);
    } catch (e) {
      // Try to load cached data on error
      final cachedData = await _loadFromCache();
      if (cachedData != null) {
        emit(HomeError(
          message: 'Failed to load fresh data, showing cached data',
          cachedSeasonNowAnimes: cachedData.seasonNowAnimes,
          cachedSeasonUpcomingAnimes: cachedData.seasonUpcomingAnimes,
          cachedTopAnimes: cachedData.topAnimes,
          cachedGenres: cachedData.genres,
        ));
      } else {
        emit(HomeError(message: 'Failed to load home data: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    await _onLoadHomeData(const LoadHomeData(forceRefresh: true), emit);
  }

  Future<bool> _isCacheValid() async {
    try {
      final timestampString = await _storageService.get(_cacheTimestampKey);
      if (timestampString == null) return false;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      return now.difference(timestamp) < _cacheDuration;
    } catch (e) {
      return false;
    }
  }

  Future<HomeLoaded?> _loadFromCache() async {
    try {
      final seasonNowJson = await _storageService.get(_seasonNowCacheKey);
      final seasonUpcomingJson =
          await _storageService.get(_seasonUpcomingCacheKey);
      final topAnimesJson = await _storageService.get(_topAnimesCacheKey);
      final genresJson = await _storageService.get(_genresCacheKey);

      if (seasonNowJson == null ||
          seasonUpcomingJson == null ||
          topAnimesJson == null ||
          genresJson == null) {
        return null;
      }

      final seasonNowList = (jsonDecode(seasonNowJson) as List)
          .map((json) => Anime.fromJson(json))
          .toList();
      final seasonUpcomingList = (jsonDecode(seasonUpcomingJson) as List)
          .map((json) => Anime.fromJson(json))
          .toList();
      final topAnimesList = (jsonDecode(topAnimesJson) as List)
          .map((json) => Anime.fromJson(json))
          .toList();
      final genresList = (jsonDecode(genresJson) as List)
          .map((json) => app_genre.Genre.fromJson(json))
          .toList();

      return HomeLoaded(
        seasonNowAnimes: seasonNowList,
        seasonUpcomingAnimes: seasonUpcomingList,
        topAnimes: topAnimesList,
        genres: genresList,
        isFromCache: true,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToCache(HomeLoaded data) async {
    try {
      await Future.wait([
        _storageService.set(
          _seasonNowCacheKey,
          jsonEncode(
              data.seasonNowAnimes.map((anime) => anime.toJson()).toList()),
        ),
        _storageService.set(
          _seasonUpcomingCacheKey,
          jsonEncode(data.seasonUpcomingAnimes
              .map((anime) => anime.toJson())
              .toList()),
        ),
        _storageService.set(
          _topAnimesCacheKey,
          jsonEncode(data.topAnimes.map((anime) => anime.toJson()).toList()),
        ),
        _storageService.set(
          _genresCacheKey,
          jsonEncode(data.genres.map((genre) => genre.toJson()).toList()),
        ),
        _storageService.set(
          _cacheTimestampKey,
          DateTime.now().toIso8601String(),
        ),
      ]);
    } catch (e) {
      // Silently fail cache save
    }
  }

  Future<void> clearCache() async {
    try {
      await Future.wait([
        _storageService.remove(_seasonNowCacheKey),
        _storageService.remove(_seasonUpcomingCacheKey),
        _storageService.remove(_topAnimesCacheKey),
        _storageService.remove(_genresCacheKey),
        _storageService.remove(_cacheTimestampKey),
      ]);
    } catch (e) {
      // Silently fail cache clear
    }
  }
}
