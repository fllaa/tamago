import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/api_client.dart';
import 'package:flutter_boilerplate/core/network/network_info.dart';
import 'package:flutter_boilerplate/core/services/anime_service.dart';
import 'package:flutter_boilerplate/core/services/storage_service.dart';
import 'package:flutter_boilerplate/core/services/supabase_service.dart';
import 'package:flutter_boilerplate/data/repositories/auth_repository_impl.dart';
import 'package:flutter_boilerplate/data/repositories/genre_repository_impl.dart';
import 'package:flutter_boilerplate/data/repositories/anime_repository_impl.dart';
import 'package:flutter_boilerplate/domain/repositories/anime_repository.dart';
import 'package:flutter_boilerplate/domain/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/domain/repositories/genre_repository.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_top_animes_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_season_now_animes_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_season_upcoming_animes_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_anime_detail_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/get_highlighted_genres_usecase.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/auth/login_viewmodel.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/auth/sign_in_with_google_viewmodel.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/home/home_bloc.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_boilerplate/core/services/theme_service.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<Connectivity>(Connectivity());

  // Core
  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(getIt<Connectivity>()),
  );

  getIt.registerSingleton<StorageService>(
    SharedPrefsStorageService(getIt<SharedPreferences>()),
  );

  getIt.registerSingleton<ThemeService>(
    ThemeService(getIt<StorageService>() as SharedPrefsStorageService),
  );

  // Supabase Service
  getIt.registerSingleton<SupabaseService>(
    SupabaseService.instance,
  );

  // Anime Service
  getIt.registerSingleton<AnimeService>(
    AnimeService.instance,
  );

  getIt.registerSingleton<ApiClient>(
    ApiClient(
      dio: getIt<Dio>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      apiClient: getIt<ApiClient>(),
      networkInfo: getIt<NetworkInfo>(),
      storageService: getIt<StorageService>(),
    ),
  );

  // Repositories
  getIt.registerSingleton<AnimeRepository>(
    AnimeRepositoryImpl(
      animeService: getIt<AnimeService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerSingleton<GenreRepository>(
    GenreRepositoryImpl(supabaseService: getIt<SupabaseService>()),
  );

  // Use cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetTopAnimesUseCase>(
    GetTopAnimesUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetSeasonNowAnimesUseCase>(
    GetSeasonNowAnimesUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetSeasonUpcomingAnimesUseCase>(
    GetSeasonUpcomingAnimesUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetAnimeDetailUseCase>(
    GetAnimeDetailUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetHighlightedGenresUseCase>(
    GetHighlightedGenresUseCase(repository: getIt<GenreRepository>()),
  );

  getIt.registerSingleton<SignInWithGoogleUseCase>(
    SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(getIt<AuthRepository>()),
  );

  // ViewModels
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(loginUseCase: getIt<LoginUseCase>()),
  );

  getIt.registerFactory<SignInWithGoogleViewModel>(
    () => SignInWithGoogleViewModel(
      signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
    ),
  );

  getIt.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );

  // BLoCs
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getTopAnimesUseCase: getIt<GetTopAnimesUseCase>(),
      getSeasonNowAnimesUseCase: getIt<GetSeasonNowAnimesUseCase>(),
      getSeasonUpcomingAnimesUseCase: getIt<GetSeasonUpcomingAnimesUseCase>(),
      getHighlightedGenresUseCase: getIt<GetHighlightedGenresUseCase>(),
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerSingleton<AnimeDetailBloc>(
    AnimeDetailBloc(
      getAnimeDetailUseCase: getIt<GetAnimeDetailUseCase>(),
    ),
  );
}
