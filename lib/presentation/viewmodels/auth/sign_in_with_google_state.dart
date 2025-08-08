part of 'sign_in_with_google_viewmodel.dart';

class SignInWithGoogleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInWithGoogleInitial extends SignInWithGoogleState {}

class SignInWithGoogleLoading extends SignInWithGoogleState {}

class SignInWithGoogleSuccess extends SignInWithGoogleState {
  final User user;

  SignInWithGoogleSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInWithGoogleError extends SignInWithGoogleState {
  final String message;

  SignInWithGoogleError(this.message);

  @override
  List<Object?> get props => [message];
}
