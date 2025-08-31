import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tamago/domain/entities/anime_provider.dart';

class WebScrapingService {
  static WebScrapingService? _instance;
  static WebScrapingService get instance {
    _instance ??= WebScrapingService._internal();
    return _instance!;
  }

  WebScrapingService._internal();

  /// Scrape anime URL from provider website
  Future<String?> scrapeAnimeUrl({
    required AnimeProvider provider,
    required String animeTitle,
    required WebViewController webViewController,
  }) async {
    try {
      // Replace space with '+'
      final title = animeTitle.replaceAll(' ', '+');

      // Construct search URL with optional additional query parameters
      final additionalQs = provider.additionalQs ?? '';
      final searchUrl =
          '${provider.baseUrl}/${provider.qsSearch}=$title$additionalQs';

      if (kDebugMode) {
        print('Scraping URL: $searchUrl');
        print('Search selector: ${provider.searchSelector}');
      }

      // Navigate to search URL
      await webViewController.loadRequest(Uri.parse(searchUrl));

      // Wait for page to load completely
      await _waitForPageLoad(webViewController);

      // Delay to ensure page is fully loaded
      await Future.delayed(const Duration(seconds: 2));

      // Execute JavaScript to find the first search result
      final jsCode = '''
        (function() {
          try {
            const element = document.querySelector('${provider.searchSelector}');
            if (element) {
              const href = element.getAttribute('href');
              return href;
            }
            return null;
          } catch (error) {
            console.error('Error in scraping:', error);
            return null;
          }
        })();
      ''';

      final result =
          await webViewController.runJavaScriptReturningResult(jsCode);

      if (result != null && result.toString() != 'null') {
        String href = result.toString();

        // Remove quotes if present
        if (href.startsWith('"') && href.endsWith('"')) {
          href = href.substring(1, href.length - 1);
        }

        // Convert relative URL to absolute if needed
        if (href.startsWith('/')) {
          href = provider.baseUrl + href;
        }

        if (kDebugMode) {
          print('Found anime URL: $href');
        }

        return href;
      }

      if (kDebugMode) {
        print('No anime URL found for: $animeTitle');
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error scraping anime URL: $e');
      }
      return null;
    }
  }

  /// Wait for page to load completely
  Future<void> _waitForPageLoad(WebViewController controller) async {
    // Wait for initial load
    await Future.delayed(const Duration(seconds: 3));

    // Check if page is still loading
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      try {
        final isLoading = await controller
            .runJavaScriptReturningResult('document.readyState !== "complete"');

        if (isLoading.toString() == 'false') {
          // Page is loaded, wait a bit more for dynamic content
          await Future.delayed(const Duration(milliseconds: 1500));
          break;
        }

        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      } catch (e) {
        // If we can't check loading state, assume it's loaded
        await Future.delayed(const Duration(seconds: 2));
        break;
      }
    }
  }

  /// Extract path from full URL
  String extractPath(String fullUrl, String baseUrl) {
    if (fullUrl.startsWith(baseUrl)) {
      return fullUrl.substring(baseUrl.length);
    }

    // If it's already a path, return as is
    if (fullUrl.startsWith('/')) {
      return fullUrl;
    }

    // Try to extract path from URL
    try {
      final uri = Uri.parse(fullUrl);
      return uri.path;
    } catch (e) {
      return fullUrl;
    }
  }
}
