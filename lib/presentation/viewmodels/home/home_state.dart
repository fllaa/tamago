part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Anime> seasonNowAnimes;
  final List<Anime> seasonUpcomingAnimes;
  final List<Anime> topAnimes;
  final List<app_genre.Genre> genres;
  final bool isFromCache;

  const HomeLoaded({
    required this.seasonNowAnimes,
    required this.seasonUpcomingAnimes,
    required this.topAnimes,
    required this.genres,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [
        seasonNowAnimes,
        seasonUpcomingAnimes,
        topAnimes,
        genres,
        isFromCache,
      ];

  HomeLoaded copyWith({
    List<Anime>? seasonNowAnimes,
    List<Anime>? seasonUpcomingAnimes,
    List<Anime>? topAnimes,
    List<app_genre.Genre>? genres,
    bool? isFromCache,
  }) {
    return HomeLoaded(
      seasonNowAnimes: seasonNowAnimes ?? this.seasonNowAnimes,
      seasonUpcomingAnimes: seasonUpcomingAnimes ?? this.seasonUpcomingAnimes,
      topAnimes: topAnimes ?? this.topAnimes,
      genres: genres ?? this.genres,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  final List<Anime>? cachedSeasonNowAnimes;
  final List<Anime>? cachedSeasonUpcomingAnimes;
  final List<Anime>? cachedTopAnimes;
  final List<app_genre.Genre>? cachedGenres;

  const HomeError({
    required this.message,
    this.cachedSeasonNowAnimes,
    this.cachedSeasonUpcomingAnimes,
    this.cachedTopAnimes,
    this.cachedGenres,
  });

  @override
  List<Object?> get props => [
        message,
        cachedSeasonNowAnimes,
        cachedSeasonUpcomingAnimes,
        cachedTopAnimes,
        cachedGenres,
      ];

  bool get hasCachedData =>
      cachedSeasonNowAnimes != null ||
      cachedSeasonUpcomingAnimes != null ||
      cachedTopAnimes != null ||
      cachedGenres != null;
}