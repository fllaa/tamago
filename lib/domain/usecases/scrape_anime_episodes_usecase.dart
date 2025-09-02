import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tamago/core/services/web_scraping_service.dart';
import 'package:tamago/domain/entities/anime_episode.dart';
import 'package:tamago/domain/entities/anime_provider.dart';
import 'package:tamago/domain/entities/anime_provider_url.dart';
import 'package:tamago/domain/repositories/anime_provider_repository.dart';

class ScrapeAnimeEpisodesUseCase {
  final AnimeProviderRepository repository;
  final WebScrapingService webScrapingService;

  ScrapeAnimeEpisodesUseCase({
    required this.repository,
    required this.webScrapingService,
  });

  Future<List<AnimeEpisode>> call({
    required int malId,
    required AnimeProvider provider,
    required AnimeProviderUrl providerUrl,
    required int jikanEpisodeCount,
    required WebViewController webViewController,
  }) async {
    try {
      // Step 1: Check existing episode count
      final existingCount =
          await repository.getAnimeEpisodesCount(malId, provider.name);

      if (kDebugMode) {
        print(
            'Existing episodes: $existingCount, Jikan episodes: $jikanEpisodeCount');
      }

      // Step 2: Skip if we already have enough episodes
      if (existingCount >= jikanEpisodeCount) {
        if (kDebugMode) {
          print('Skipping episode scraping - already have enough episodes');
        }
        return await repository.getAnimeEpisodes(malId, provider.name);
      }

      // Step 3: Check if provider has episode script
      if (provider.episodeScript == null || provider.episodeScript!.isEmpty) {
        if (kDebugMode) {
          print('No episode script available for provider: ${provider.name}');
        }
        return [];
      }

      // Step 4: Scrape episodes
      final scrapingResult = await webScrapingService.scrapeEpisodeList(
        animeUrl: provider.baseUrl + providerUrl.path,
        episodeScript: provider.episodeScript!,
        webViewController: webViewController,
      );

      if (scrapingResult == null || scrapingResult.isEmpty) {
        if (kDebugMode) {
          print('No episodes scraped');
        }
        return [];
      }

      // Step 5: Parse the raw result
      final rawResult = scrapingResult.first['raw_result'] as String;
      final episodes = _parseEpisodeResult(rawResult, malId, provider.name);

      if (episodes.isEmpty) {
        if (kDebugMode) {
          print('No valid episodes parsed');
        }
        return [];
      }

      // Step 6: Save episodes to database
      await repository.saveAnimeEpisodes(episodes);

      if (kDebugMode) {
        print('Saved ${episodes.length} episodes for ${provider.name}');
      }

      return episodes;
    } catch (e) {
      if (kDebugMode) {
        print('Error in scrape anime episodes use case: $e');
      }
      return [];
    }
  }

  List<AnimeEpisode> _parseEpisodeResult(
      String rawResult, int malId, String providerName) {
    try {
      // Remove quotes if the result is wrapped in quotes
      String cleanResult = rawResult;
      if (cleanResult.startsWith('"') && cleanResult.endsWith('"')) {
        cleanResult = cleanResult.substring(1, cleanResult.length - 1);
      }

      // Unescape JSON string
      cleanResult = cleanResult.replaceAll('\\"', '"');
      cleanResult = cleanResult.replaceAll('\\\\', '\\');

      if (kDebugMode) {
        print('Parsing episode result: $cleanResult');
      }

      // Parse as JSON array
      final List<dynamic> jsonList = jsonDecode(cleanResult);

      final episodes = <AnimeEpisode>[];
      final now = DateTime.now();

      for (final item in jsonList) {
        if (item is Map<String, dynamic>) {
          final path = item['path'] as String?;
          final episodeNumber = item['episode'];

          if (path != null && episodeNumber != null) {
            double episode;
            if (episodeNumber is int) {
              episode = episodeNumber.toDouble();
            } else if (episodeNumber is double) {
              episode = episodeNumber;
            } else if (episodeNumber is String) {
              episode = double.tryParse(episodeNumber) ?? 0.0;
            } else {
              continue; // Skip invalid episode numbers
            }

            episodes.add(AnimeEpisode(
              malId: malId,
              createdAt: now,
              providerName: providerName,
              episode: episode,
              path: path,
            ));
          }
        }
      }

      return episodes;
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing episode result: $e');
        print('Raw result was: $rawResult');
      }
      return [];
    }
  }
}
