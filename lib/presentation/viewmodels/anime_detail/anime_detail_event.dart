part of 'anime_detail_bloc.dart';

abstract class AnimeDetailEvent extends Equatable {
  const AnimeDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadAnimeDetail extends AnimeDetailEvent {
  final int malId;
  final bool forceRefresh;

  const LoadAnimeDetail({
    required this.malId,
    this.forceRefresh = false,
  });

  @override
  List<Object> get props => [malId, forceRefresh];
}

class RefreshAnimeDetail extends AnimeDetailEvent {
  final int malId;

  const RefreshAnimeDetail({required this.malId});

  @override
  List<Object> get props => [malId];
}

class LoadAnimeEpisodes extends AnimeDetailEvent {
  final int malId;
  final int page;

  const LoadAnimeEpisodes({
    required this.malId,
    this.page = 1,
  });

  @override
  List<Object> get props => [malId, page];
}

class LoadAnimeRecommendations extends AnimeDetailEvent {
  final int malId;

  const LoadAnimeRecommendations({
    required this.malId,
  });

  @override
  List<Object> get props => [malId];
}

class LoadAnimeReviews extends AnimeDetailEvent {
  final int malId;
  final int page;

  const LoadAnimeReviews({
    required this.malId,
    this.page = 1,
  });

  @override
  List<Object> get props => [malId, page];
}

class ScrapeAnimeProviders extends AnimeDetailEvent {
  final int malId;
  final String animeTitle;
  final dynamic webViewController; // WebViewController

  const ScrapeAnimeProviders({
    required this.malId,
    required this.animeTitle,
    required this.webViewController,
  });

  @override
  List<Object> get props => [malId, animeTitle, webViewController];
}

class LoadAnimeProviderUrls extends AnimeDetailEvent {
  final int malId;

  const LoadAnimeProviderUrls({
    required this.malId,
  });

  @override
  List<Object> get props => [malId];
}