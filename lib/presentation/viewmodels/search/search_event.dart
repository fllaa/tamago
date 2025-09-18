part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchAnime extends SearchEvent {
  final String query;

  const SearchAnime({required this.query});

  @override
  List<Object> get props => [query];
}

class ClearSearch extends SearchEvent {}
