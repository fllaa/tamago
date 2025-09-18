import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/domain/usecases/anime/search_anime_usecase.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchAnimeUseCase _searchAnimeUseCase;
  Timer? _debounceTimer;
  String _currentQuery = '';

  static const Duration _debounceDuration = Duration(seconds: 1);

  SearchBloc({
    required SearchAnimeUseCase searchAnimeUseCase,
  })  : _searchAnimeUseCase = searchAnimeUseCase,
        super(SearchInitial()) {
    on<SearchAnime>(_onSearchAnime);
    on<ClearSearch>(_onClearSearch);
  }

  void _onSearchAnime(SearchAnime event, Emitter<SearchState> emit) async {
    // Cancel previous timer if exists
    _debounceTimer?.cancel();
    _currentQuery = event.query;

    if (event.query.isEmpty) {
      _currentQuery = '';
      emit(SearchInitial());
      return;
    }

    // Wait for debounce duration
    await Future.delayed(_debounceDuration);

    // Check if emit is still available (in case another event was processed)
    if (!emit.isDone) {
      emit(SearchLoading());

      try {
        final results = await _searchAnimeUseCase.call(event.query, page: 1);
        if (!emit.isDone) {
          emit(SearchLoaded(results: results, query: event.query));
        }
      } catch (e) {
        if (!emit.isDone) {
          emit(SearchError(message: 'Failed to search anime: ${e.toString()}'));
        }
      }
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
