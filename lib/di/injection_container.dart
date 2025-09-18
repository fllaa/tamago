import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:tamago/core/network/api_client.dart';
import 'package:tamago/core/network/network_info.dart';
// NetworkInfoImpl is in the same file as NetworkInfo
// SharedPrefsStorageService is in the same file as StorageService
import 'package:tamago/core/services/anime_service.dart';
import 'package:tamago/core/services/storage_service.dart';
import 'package:tamago/core/services/supabase_service.dart';
import 'package:tamago/core/services/web_scraping_service.dart';
import 'package:tamago/data/repositories/auth_repository_impl.dart';
import 'package:tamago/data/repositories/genre_repository_impl.dart';
import 'package:tamago/data/repositories/anime_repository_impl.dart';
import 'package:tamago/data/repositories/anime_provider_repository_impl.dart';
import 'package:tamago/domain/repositories/anime_repository.dart';
import 'package:tamago/domain/repositories/auth_repository.dart';
import 'package:tamago/domain/repositories/genre_repository.dart';
import 'package:tamago/domain/repositories/anime_provider_repository.dart';
import 'package:tamago/domain/usecases/anime/get_top_animes_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_season_now_animes_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_season_upcoming_animes_usecase.dart';
import 'package:tamago/domain/usecases/anime/search_anime_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_anime_detail_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_anime_episodes_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_anime_recommendations_usecase.dart';
import 'package:tamago/domain/usecases/anime/get_anime_reviews_usecase.dart';
import 'package:tamago/domain/usecases/anime_provider/get_anime_providers_usecase.dart';
import 'package:tamago/domain/usecases/anime_provider/scrape_anime_urls_usecase.dart';
import 'package:tamago/domain/usecases/anime_provider/get_anime_provider_urls_usecase.dart';
import 'package:tamago/domain/usecases/get_provider_episodes_usecase.dart';
import 'package:tamago/domain/usecases/scrape_anime_episodes_usecase.dart';
import 'package:tamago/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:tamago/domain/usecases/auth/login_usecase.dart';
import 'package:tamago/domain/usecases/auth/logout_usecase.dart';
import 'package:tamago/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:tamago/domain/usecases/get_highlighted_genres_usecase.dart';
import 'package:tamago/presentation/viewmodels/auth/login_viewmodel.dart';
import 'package:tamago/presentation/viewmodels/auth/sign_in_with_google_viewmodel.dart';
import 'package:tamago/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:tamago/presentation/viewmodels/home/home_bloc.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';
import 'package:tamago/presentation/viewmodels/search/search_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamago/core/services/theme_service.dart';

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

  // Web Scraping Service
  getIt.registerSingleton<WebScrapingService>(
    WebScrapingService.instance,
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

  getIt.registerSingleton<AnimeProviderRepository>(
    AnimeProviderRepositoryImpl(supabaseService: getIt<SupabaseService>()),
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

  getIt.registerSingleton<SearchAnimeUseCase>(
    SearchAnimeUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetAnimeDetailUseCase>(
    GetAnimeDetailUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetAnimeEpisodesUseCase>(
    GetAnimeEpisodesUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetAnimeRecommendationsUseCase>(
    GetAnimeRecommendationsUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetAnimeReviewsUseCase>(
    GetAnimeReviewsUseCase(repository: getIt<AnimeRepository>()),
  );

  getIt.registerSingleton<GetHighlightedGenresUseCase>(
    GetHighlightedGenresUseCase(repository: getIt<GenreRepository>()),
  );

  getIt.registerSingleton<GetAnimeProvidersUseCase>(
    GetAnimeProvidersUseCase(repository: getIt<AnimeProviderRepository>()),
  );

  getIt.registerSingleton<ScrapeAnimeUrlsUseCase>(
    ScrapeAnimeUrlsUseCase(
      repository: getIt<AnimeProviderRepository>(),
      webScrapingService: getIt<WebScrapingService>(),
    ),
  );

  getIt.registerSingleton<GetAnimeProviderUrlsUseCase>(
    GetAnimeProviderUrlsUseCase(repository: getIt<AnimeProviderRepository>()),
  );

  getIt.registerSingleton<GetProviderEpisodesUseCase>(
    GetProviderEpisodesUseCase(getIt<AnimeProviderRepository>()),
  );

  getIt.registerSingleton<ScrapeAnimeEpisodesUseCase>(
    ScrapeAnimeEpisodesUseCase(
      repository: getIt<AnimeProviderRepository>(),
      webScrapingService: getIt<WebScrapingService>(),
    ),
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

  getIt.registerFactory<AnimeDetailBloc>(
    () => AnimeDetailBloc(
      getAnimeDetailUseCase: getIt<GetAnimeDetailUseCase>(),
      getAnimeEpisodesUseCase: getIt<GetAnimeEpisodesUseCase>(),
      getAnimeRecommendationsUseCase: getIt<GetAnimeRecommendationsUseCase>(),
      getAnimeReviewsUseCase: getIt<GetAnimeReviewsUseCase>(),
      getAnimeProvidersUseCase: getIt<GetAnimeProvidersUseCase>(),
      scrapeAnimeUrlsUseCase: getIt<ScrapeAnimeUrlsUseCase>(),
      getAnimeProviderUrlsUseCase: getIt<GetAnimeProviderUrlsUseCase>(),
      getProviderEpisodesUseCase: getIt<GetProviderEpisodesUseCase>(),
      scrapeAnimeEpisodesUseCase: getIt<ScrapeAnimeEpisodesUseCase>(),
    ),
  );

  getIt.registerSingleton<SearchBloc>(
    SearchBloc(
      searchAnimeUseCase: getIt<SearchAnimeUseCase>(),
    ),
  );
}
