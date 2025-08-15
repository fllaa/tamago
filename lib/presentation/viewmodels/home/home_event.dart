part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {
  final bool forceRefresh;

  const LoadHomeData({this.forceRefresh = false});

  @override
  List<Object> get props => [forceRefresh];
}

class RefreshHomeData extends HomeEvent {}