import 'package:dartz/dartz.dart';
import 'package:tamago/core/errors/failures.dart';
import 'package:tamago/domain/entities/user.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// Register a new user
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  });

  /// Send password reset email
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });

  /// Reset password with token
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  });

  /// Get the currently authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Logout the current user
  Future<Either<Failure, void>> logout();

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();
}
