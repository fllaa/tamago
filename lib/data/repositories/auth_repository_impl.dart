import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/core/constants/api_constants.dart';
import 'package:flutter_boilerplate/core/constants/app_constants.dart';
import 'package:flutter_boilerplate/core/errors/exceptions.dart';
import 'package:flutter_boilerplate/core/errors/failures.dart';
import 'package:flutter_boilerplate/core/network/api_client.dart';
import 'package:flutter_boilerplate/core/network/network_info.dart';
import 'package:flutter_boilerplate/core/services/storage_service.dart';
import 'package:flutter_boilerplate/data/models/auth/login_request.dart';
import 'package:flutter_boilerplate/data/models/auth/login_response.dart';
import 'package:flutter_boilerplate/data/models/auth/user_model.dart';
import 'package:flutter_boilerplate/domain/entities/user.dart';
import 'package:flutter_boilerplate/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.networkInfo,
    required this.storageService,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ));
      }

      final loginRequest = LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      final response = await apiClient.post(
        ApiConstants.login,
        data: loginRequest.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response);

      // Save auth token
      await storageService.set(AppConstants.tokenKey, loginResponse.token);

      // Save user data
      await storageService.set(
          AppConstants.userKey, loginResponse.user.toJson());

      return Right(loginResponse.user.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.errors,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ));
      }

      final registerRequest = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
      };

      final response = await apiClient.post(
        ApiConstants.register,
        data: registerRequest,
      );

      final loginResponse = LoginResponse.fromJson(response);

      // Save auth token
      await storageService.set(AppConstants.tokenKey, loginResponse.token);

      // Save user data
      await storageService.set(
          AppConstants.userKey, loginResponse.user.toJson());

      return Right(loginResponse.user.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.errors,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ));
      }

      await apiClient.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.errors,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ));
      }

      final resetRequest = {
        'token': token,
        'password': password,
        'password_confirmation': confirmPassword,
      };

      await apiClient.post(
        ApiConstants.resetPassword,
        data: resetRequest,
      );

      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.errors,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userJson = await storageService.get(AppConstants.userKey);

      if (userJson == null) {
        return const Right(null);
      }

      final userModel = UserModel.fromJson(userJson);
      return Right(userModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await storageService.get(AppConstants.tokenKey);
      return token != null && token.toString().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear storage
      await storageService.clear();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ));
      }

      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out any existing user
      await googleSignIn.signOut();

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return Left(AuthFailure(message: 'Google sign-in was canceled'));
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // For now, we'll create a mock user based on Google account info
      // In a real implementation, you would send the Google ID token to your backend
      // to authenticate the user and get user details
      final UserModel user = UserModel(
        id: googleUser.id,
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        profileImage: googleUser.photoUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user data
      await storageService.set(AppConstants.userKey, user.toJson());

      // For a real implementation, you would also save an authentication token
      // For now, we'll just save a mock token
      await storageService.set(AppConstants.tokenKey, 'google_auth_token');

      return Right(user.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
