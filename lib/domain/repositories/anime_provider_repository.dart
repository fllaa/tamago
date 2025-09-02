import 'package:tamago/domain/entities/anime_provider.dart';
import 'package:tamago/domain/entities/anime_provider_url.dart';
import 'package:tamago/domain/entities/anime_episode.dart';

abstract class AnimeProviderRepository {
  /// Fetch all available anime providers from Supabase
  Future<List<AnimeProvider>> getAnimeProviders();
  
  /// Save scraped anime URL to Supabase
  Future<void> saveAnimeProviderUrl(AnimeProviderUrl providerUrl);
  
  /// Get existing anime provider URLs for a specific anime
  Future<List<AnimeProviderUrl>> getAnimeProviderUrls(int malId);
  
  /// Check if anime provider URL already exists
  Future<bool> hasAnimeProviderUrl(int malId, String providerName);
  
  /// Get anime episodes for a specific anime and provider
  Future<List<AnimeEpisode>> getAnimeEpisodes(int malId, String providerName);
  
  /// Save scraped anime episodes to Supabase
  Future<void> saveAnimeEpisodes(List<AnimeEpisode> episodes);
  
  /// Get count of anime episodes for a specific anime and provider
  Future<int> getAnimeEpisodesCount(int malId, String providerName);
}