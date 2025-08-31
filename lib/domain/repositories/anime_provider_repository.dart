import 'package:tamago/domain/entities/anime_provider.dart';
import 'package:tamago/domain/entities/anime_provider_url.dart';

abstract class AnimeProviderRepository {
  /// Fetch all available anime providers from Supabase
  Future<List<AnimeProvider>> getAnimeProviders();
  
  /// Save scraped anime URL to Supabase
  Future<void> saveAnimeProviderUrl(AnimeProviderUrl providerUrl);
  
  /// Get existing anime provider URLs for a specific anime
  Future<List<AnimeProviderUrl>> getAnimeProviderUrls(int malId);
  
  /// Check if anime provider URL already exists
  Future<bool> hasAnimeProviderUrl(int malId, String providerName);
}