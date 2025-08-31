import 'package:tamago/core/services/supabase_service.dart';
import 'package:tamago/data/models/anime_provider_model.dart';
import 'package:tamago/data/models/anime_provider_url_model.dart';
import 'package:tamago/domain/entities/anime_provider.dart';
import 'package:tamago/domain/entities/anime_provider_url.dart';
import 'package:tamago/domain/repositories/anime_provider_repository.dart';

class AnimeProviderRepositoryImpl implements AnimeProviderRepository {
  final SupabaseService supabaseService;

  AnimeProviderRepositoryImpl({required this.supabaseService});

  @override
  Future<List<AnimeProvider>> getAnimeProviders() async {
    try {
      final response = await supabaseService.client
          .from('anime_providers')
          .select()
          .order('name');

      final providers = response.map((json) {
        return AnimeProviderModel.fromJson(json);
      }).toList();

      return providers.cast<AnimeProvider>();
    } catch (e) {
      throw Exception('Failed to fetch anime providers: $e');
    }
  }

  @override
  Future<void> saveAnimeProviderUrl(AnimeProviderUrl providerUrl) async {
    try {
      final model = AnimeProviderUrlModel.fromEntity(providerUrl);

      await supabaseService.client
          .from('anime_provider_urls')
          .upsert(model.toJson());
    } catch (e) {
      throw Exception('Failed to save anime provider URL: $e');
    }
  }

  @override
  Future<List<AnimeProviderUrl>> getAnimeProviderUrls(int malId) async {
    try {
      final response = await supabaseService.client
          .from('anime_provider_urls')
          .select()
          .eq('mal_id', malId)
          .order('created_at');

      final providerUrls = response.map((json) {
        return AnimeProviderUrlModel.fromJson(json);
      }).toList();

      return providerUrls.cast<AnimeProviderUrl>();
    } catch (e) {
      throw Exception('Failed to fetch anime provider URLs: $e');
    }
  }

  @override
  Future<bool> hasAnimeProviderUrl(int malId, String providerName) async {
    try {
      final response = await supabaseService.client
          .from('anime_provider_urls')
          .select('mal_id')
          .eq('mal_id', malId)
          .eq('provider_name', providerName)
          .limit(1);

      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
