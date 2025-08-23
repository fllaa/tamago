import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/domain/usecases/anime/get_anime_detail_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_anime_episodes_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_anime_recommendations_usecase.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

part 'anime_detail_event.dart';
part 'anime_detail_state.dart';

class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  final GetAnimeDetailUseCase _getAnimeDetailUseCase;
  final GetAnimeEpisodesUseCase _getAnimeEpisodesUseCase;
  final GetAnimeRecommendationsUseCase _getAnimeRecommendationsUseCase;

  // In-memory cache for anime details indexed by malId
  final Map<int, Anime> _animeCache = {};
  final Map<int, bool> _animeCacheSource = {}; // Track if data is from cache
  final Map<int, List<Episode>> _episodesCache = {};
  final Map<int, List<Recommendation>> _recommendationsCache = {};

  AnimeDetailBloc({
    required GetAnimeDetailUseCase getAnimeDetailUseCase,
    required GetAnimeEpisodesUseCase getAnimeEpisodesUseCase,
    required GetAnimeRecommendationsUseCase getAnimeRecommendationsUseCase,
  })  : _getAnimeDetailUseCase = getAnimeDetailUseCase,
        _getAnimeEpisodesUseCase = getAnimeEpisodesUseCase,
        _getAnimeRecommendationsUseCase = getAnimeRecommendationsUseCase,
        super(AnimeDetailInitial()) {
    on<LoadAnimeDetail>(_onLoadAnimeDetail);
    on<RefreshAnimeDetail>(_onRefreshAnimeDetail);
    on<LoadAnimeEpisodes>(_onLoadAnimeEpisodes);
    on<LoadAnimeRecommendations>(_onLoadAnimeRecommendations);
  }

  Future<void> _onLoadAnimeDetail(
    LoadAnimeDetail event,
    Emitter<AnimeDetailState> emit,
  ) async {
    try {
      // Check if we already have this anime in memory cache and it's not a forced refresh
      if (_animeCache.containsKey(event.malId) && !event.forceRefresh) {
        final cachedAnime = _animeCache[event.malId]!;
        final isFromCache = _animeCacheSource[event.malId] ?? false;
        final cachedEpisodes = _episodesCache[event.malId];
        emit(AnimeDetailLoaded(
          anime: cachedAnime,
          isFromCache: isFromCache,
          episodes: cachedEpisodes,
        ));
        return;
      }

      emit(AnimeDetailLoading());

      final result = await _getAnimeDetailUseCase(event.malId);

      if (result.anime != null) {
        // Store in memory cache
        _animeCache[event.malId] = result.anime!;
        _animeCacheSource[event.malId] = result.isFromCache;

        // Check if we already have episodes in cache
        final cachedEpisodes = _episodesCache[event.malId];

        emit(AnimeDetailLoaded(
          anime: result.anime!,
          isFromCache: result.isFromCache,
          episodes: cachedEpisodes,
        ));
      } else {
        emit(const AnimeDetailError(
          message: 'Anime not found',
          hasCachedData: false,
        ));
      }
    } catch (e) {
      emit(AnimeDetailError(
        message: 'Failed to load anime details: ${e.toString()}',
        hasCachedData: false,
      ));
    }
  }

  Future<void> _onRefreshAnimeDetail(
    RefreshAnimeDetail event,
    Emitter<AnimeDetailState> emit,
  ) async {
    // Clear the memory cache for this anime before refreshing
    _animeCache.remove(event.malId);
    _animeCacheSource.remove(event.malId);
    _episodesCache.remove(event.malId);

    // For refresh, we'll load the data again with forceRefresh flag
    // The repository will handle cache invalidation if needed
    add(LoadAnimeDetail(malId: event.malId, forceRefresh: true));
  }

  Future<void> _onLoadAnimeEpisodes(
    LoadAnimeEpisodes event,
    Emitter<AnimeDetailState> emit,
  ) async {
    try {
      // Check if we already have episodes in memory cache
      if (_episodesCache.containsKey(event.malId)) {
        final currentState = state;
        if (currentState is AnimeDetailLoaded) {
          emit(currentState.copyWith(episodes: _episodesCache[event.malId]));
        }
        return;
      }

      // Update state to show episodes are loading if anime detail is already loaded
      final currentState = state;
      if (currentState is AnimeDetailLoaded) {
        emit(currentState.copyWith(episodesLoading: true));
      }

      final episodes = await _getAnimeEpisodesUseCase(event.malId, page: event.page);

      // Store in memory cache
      _episodesCache[event.malId] = episodes;

      // Update state with episodes - check current state again as it might have changed
      final updatedState = state;
      if (updatedState is AnimeDetailLoaded) {
        emit(updatedState.copyWith(
          episodes: episodes,
          episodesLoading: false,
        ));
      }
    } catch (e) {
      final currentState = state;
      if (currentState is AnimeDetailLoaded) {
        emit(currentState.copyWith(
          episodesLoading: false,
          episodesError: 'Failed to load episodes: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onLoadAnimeRecommendations(
    LoadAnimeRecommendations event,
    Emitter<AnimeDetailState> emit,
  ) async {
    try {
      // Check if we already have recommendations in memory cache
      if (_recommendationsCache.containsKey(event.malId)) {
        final currentState = state;
        if (currentState is AnimeDetailLoaded) {
          emit(currentState.copyWith(recommendations: _recommendationsCache[event.malId]));
        }
        return;
      }

      // Update state to show recommendations are loading if anime detail is already loaded
      final currentState = state;
      if (currentState is AnimeDetailLoaded) {
        emit(currentState.copyWith(recommendationsLoading: true));
      }

      final recommendations = await _getAnimeRecommendationsUseCase(event.malId);

      // Store in memory cache
      _recommendationsCache[event.malId] = recommendations;

      // Update state with recommendations - check current state again as it might have changed
      final updatedState = state;
      if (updatedState is AnimeDetailLoaded) {
        emit(updatedState.copyWith(
          recommendations: recommendations,
          recommendationsLoading: false,
        ));
      }
    } catch (e) {
      final currentState = state;
      if (currentState is AnimeDetailLoaded) {
        emit(currentState.copyWith(
          recommendationsLoading: false,
          recommendationsError: 'Failed to load recommendations: ${e.toString()}',
        ));
      }
    }
  }
}
