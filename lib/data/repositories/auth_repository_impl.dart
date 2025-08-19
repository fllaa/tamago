import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:tamago/core/constants/api_constants.dart';
import 'package:tamago/core/constants/app_constants.dart';
import 'package:tamago/core/errors/exceptions.dart';
import 'package:tamago/core/errors/failures.dart';
import 'package:tamago/core/network/api_client.dart';
import 'package:tamago/core/network/network_info.dart';
import 'package:tamago/core/services/storage_service.dart';
import 'package:tamago/data/models/auth/login_request.dart';
import 'package:tamago/data/models/auth/login_response.dart';
import 'package:tamago/data/models/auth/user_model.dart';
import 'package:tamago/domain/entities/user.dart' as entity;
import 'package:tamago/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase/supabase.dart' hide User;
import 'package:tamago/core/services/supabase_service.dart';

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
  Future<Either<Failure, entity.User>> login({
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
  Future<Either<Failure, entity.User>> register({
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
  Future<Either<Failure, entity.User?>> getCurrentUser() async {
    try {
      final userJson = await storageService.get(AppConstants.userKey);

      if (userJson == null) {
        return const Right(null);
      }

      // If userJson is a string, parse it to a Map
      final userMap = userJson is String ? json.decode(userJson) : userJson;
      final userModel = UserModel.fromJson(userMap);
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
  Future<Either<Failure, entity.User>> signInWithGoogle() async {
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

      // Sign in with Supabase using Google ID token
      final response =
          await SupabaseService.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken ?? '',
        accessToken: googleAuth.accessToken,
      );

      if (response.user == null) {
        return Left(
            AuthFailure(message: 'Failed to authenticate with Supabase'));
      }

      // Create user model from Supabase user data
      final UserModel user = UserModel(
        id: response.user!.id,
        name: response.user!.userMetadata?['name'] ??
            response.user!.email ??
            'Google User',
        email: response.user!.email ?? '',
        profileImage: response.user!.userMetadata?['picture'],
        createdAt: response.user!.createdAt is DateTime
            ? response.user!.createdAt as DateTime
            : DateTime.now(),
        updatedAt: response.user!.updatedAt is DateTime
            ? response.user!.updatedAt as DateTime
            : DateTime.now(),
      );

      // Save user data
      await storageService.set(AppConstants.userKey, user.toJson());

      // Save Supabase token
      if (response.session?.accessToken != null) {
        await storageService.set(
            AppConstants.tokenKey, response.session!.accessToken);
      }

      return Right(user.toEntity());
    } on AuthApiException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
