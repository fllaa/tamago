import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_anime_detail_usecase.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

part 'anime_detail_event.dart';
part 'anime_detail_state.dart';

class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  final GetAnimeDetailUseCase _getAnimeDetailUseCase;
  
  // In-memory cache for anime details indexed by malId
  final Map<int, Anime> _animeCache = {};
  final Map<int, bool> _animeCacheSource = {}; // Track if data is from cache

  AnimeDetailBloc({
    required GetAnimeDetailUseCase getAnimeDetailUseCase,
  })  : _getAnimeDetailUseCase = getAnimeDetailUseCase,
        super(AnimeDetailInitial()) {
    on<LoadAnimeDetail>(_onLoadAnimeDetail);
    on<RefreshAnimeDetail>(_onRefreshAnimeDetail);
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
        emit(AnimeDetailLoaded(
          anime: cachedAnime,
          isFromCache: isFromCache,
        ));
        return;
      }
      
      emit(AnimeDetailLoading());
      
      final result = await _getAnimeDetailUseCase(event.malId);
      
      if (result.anime != null) {
        // Store in memory cache
        _animeCache[event.malId] = result.anime!;
        _animeCacheSource[event.malId] = result.isFromCache;
        
        emit(AnimeDetailLoaded(
          anime: result.anime!,
          isFromCache: result.isFromCache,
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
    
    // For refresh, we'll load the data again with forceRefresh flag
    // The repository will handle cache invalidation if needed
    add(LoadAnimeDetail(malId: event.malId, forceRefresh: true));
  }
}