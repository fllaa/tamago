part of 'anime_detail_bloc.dart';

abstract class AnimeDetailState extends Equatable {
  const AnimeDetailState();

  @override
  List<Object?> get props => [];
}

class AnimeDetailInitial extends AnimeDetailState {}

class AnimeDetailLoading extends AnimeDetailState {}

class AnimeDetailLoaded extends AnimeDetailState {
  final Anime anime;
  final bool isFromCache;

  const AnimeDetailLoaded({
    required this.anime,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [anime, isFromCache];

  AnimeDetailLoaded copyWith({
    Anime? anime,
    bool? isFromCache,
  }) {
    return AnimeDetailLoaded(
      anime: anime ?? this.anime,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}

class AnimeDetailError extends AnimeDetailState {
  final String message;
  final bool hasCachedData;
  final Anime? cachedAnime;

  const AnimeDetailError({
    required this.message,
    this.hasCachedData = false,
    this.cachedAnime,
  });

  @override
  List<Object?> get props => [message, hasCachedData, cachedAnime];
}