import 'package:equatable/equatable.dart';

/// Base failure class for domain layer
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Represents server failures
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Represents network failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Represents cache failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Represents authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Represents validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
  });

  @override
  List<Object> get props => [message, fieldErrors ?? {}];
}

/// Represents timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message});
}

/// Represents not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

/// Represents unauthorized failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}

/// Represents forbidden failures
class ForbiddenFailure extends Failure {
  const ForbiddenFailure({required super.message});
}

/// Represents unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
