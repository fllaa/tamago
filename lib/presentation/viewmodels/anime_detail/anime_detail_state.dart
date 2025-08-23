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
  final List<Episode>? episodes;
  final bool episodesLoading;
  final String? episodesError;
  final List<Recommendation>? recommendations;
  final bool recommendationsLoading;
  final String? recommendationsError;
  final List<Review>? reviews;
  final bool reviewsLoading;
  final String? reviewsError;

  const AnimeDetailLoaded({
    required this.anime,
    this.isFromCache = false,
    this.episodes,
    this.episodesLoading = false,
    this.episodesError,
    this.recommendations,
    this.recommendationsLoading = false,
    this.recommendationsError,
    this.reviews,
    this.reviewsLoading = false,
    this.reviewsError,
  });

  @override
  List<Object?> get props => [anime, isFromCache, episodes, episodesLoading, episodesError, recommendations, recommendationsLoading, recommendationsError, reviews, reviewsLoading, reviewsError];

  AnimeDetailLoaded copyWith({
    Anime? anime,
    bool? isFromCache,
    List<Episode>? episodes,
    bool? episodesLoading,
    String? episodesError,
    List<Recommendation>? recommendations,
    bool? recommendationsLoading,
    String? recommendationsError,
    List<Review>? reviews,
    bool? reviewsLoading,
    String? reviewsError,
  }) {
    return AnimeDetailLoaded(
      anime: anime ?? this.anime,
      isFromCache: isFromCache ?? this.isFromCache,
      episodes: episodes ?? this.episodes,
      episodesLoading: episodesLoading ?? this.episodesLoading,
      episodesError: episodesError,
      recommendations: recommendations ?? this.recommendations,
      recommendationsLoading: recommendationsLoading ?? this.recommendationsLoading,
      recommendationsError: recommendationsError,
      reviews: reviews ?? this.reviews,
      reviewsLoading: reviewsLoading ?? this.reviewsLoading,
      reviewsError: reviewsError,
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