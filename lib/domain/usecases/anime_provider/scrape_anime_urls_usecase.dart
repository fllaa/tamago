import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tamago/core/services/web_scraping_service.dart';
import 'package:tamago/domain/entities/anime_provider.dart';
import 'package:tamago/domain/entities/anime_provider_url.dart';
import 'package:tamago/domain/repositories/anime_provider_repository.dart';

class ScrapeAnimeUrlsUseCase {
  final AnimeProviderRepository repository;
  final WebScrapingService webScrapingService;

  ScrapeAnimeUrlsUseCase({
    required this.repository,
    required this.webScrapingService,
  });

  Future<List<AnimeProviderUrl>> call({
    required int malId,
    required String animeTitle,
    required List<AnimeProvider> providers,
    required WebViewController webViewController,
  }) async {
    final List<AnimeProviderUrl> scrapedUrls = [];

    for (final provider in providers) {
      try {
        // Check if URL already exists for this provider
        final exists =
            await repository.hasAnimeProviderUrl(malId, provider.name);
        if (exists) {
          continue; // Skip if already scraped
        }

        // Scrape the anime URL
        final fullUrl = await webScrapingService.scrapeAnimeUrl(
          provider: provider,
          animeTitle: animeTitle,
          webViewController: webViewController,
        );

        if (fullUrl != null) {
          // Extract path from full URL
          final path =
              webScrapingService.extractPath(fullUrl, provider.baseUrl);

          // Create AnimeProviderUrl entity
          final providerUrl = AnimeProviderUrl(
            malId: malId,
            providerName: provider.name,
            createdAt: DateTime.now(),
            path: path,
          );

          // Save to database
          await repository.saveAnimeProviderUrl(providerUrl);
          scrapedUrls.add(providerUrl);
        }
      } catch (e) {
        // Continue with next provider if one fails
        if (kDebugMode) {
          print('Failed to scrape from ${provider.name}: $e');
        }
        continue;
      }
    }

    return scrapedUrls;
  }
}
