part of 'login_viewmodel.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginValidationError extends LoginState {
  final String message;
  final Map<String, List<String>>? fieldErrors;

  LoginValidationError({
    required this.message,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, fieldErrors];
}
