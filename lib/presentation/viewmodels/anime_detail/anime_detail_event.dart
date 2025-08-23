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