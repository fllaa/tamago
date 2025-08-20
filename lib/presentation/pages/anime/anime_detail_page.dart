import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:omni_video_player/omni_video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';
import 'package:tamago/di/injection_container.dart';
import 'package:tamago/core/services/supabase_service.dart';

class AnimeDetailPage extends StatefulWidget {
  final int malId;

  const AnimeDetailPage({
    super.key,
    required this.malId,
  });

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _scrapedEpisodes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Add the load event to the singleton bloc
    getIt<AnimeDetailBloc>().add(LoadAnimeDetail(malId: widget.malId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AnimeDetailBloc>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Anime Details'),
          actions: [
            BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
              builder: (context, state) {
                if (state is AnimeDetailLoaded && state.isFromCache) {
                  return IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      context.read<AnimeDetailBloc>().add(
                            RefreshAnimeDetail(malId: widget.malId),
                          );
                    },
                    tooltip: 'Refresh (cached data)',
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
          builder: (context, state) {
            if (state is AnimeDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnimeDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AnimeDetailBloc>().add(
                              LoadAnimeDetail(malId: widget.malId),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is AnimeDetailLoaded) {
              return _buildAnimeContent(
                  context, state.anime, state.isFromCache);
            }
            return const Center(child: Text('Anime not found'));
          },
        ),
      ),
    );
  }

  Widget _buildAnimeContent(
      BuildContext context, Anime anime, bool isFromCache) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnimeDetailBloc>().add(
              RefreshAnimeDetail(malId: widget.malId),
            );
        // Wait for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          // Trailer video section (without safe area)
          SliverToBoxAdapter(
            child: Container(
              height: 250,
              color: Colors.black,
              child: _buildTrailerSection(anime),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              height: 0,
              color: Colors.black,
              child: _buildWebView(anime),
            ),
          ),

          // Anime information section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cache indicator
                  if (isFromCache)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.offline_bolt,
                            size: 16,
                            color: Colors.orange[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cached data',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Title and English title
                  Text(
                    anime.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (anime.titleEnglish != null &&
                      anime.titleEnglish!.isNotEmpty)
                    Text(
                      anime.titleEnglish!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                    ),
                  const SizedBox(height: 16),

                  // Aired date, season, status, studio, and rating
                  _buildInfoRow('Aired', anime.aired?.toString() ?? 'N/A'),
                  _buildInfoRow('Season', anime.season?.toString() ?? 'N/A'),
                  _buildInfoRow('Status', anime.status?.toString() ?? 'N/A'),
                  _buildInfoRow(
                      'Studio',
                      anime.studios.isNotEmpty == true
                          ? anime.studios.map((s) => s.name).join(', ')
                          : 'N/A'),
                  _buildInfoRow('Score', anime.score?.toString() ?? 'N/A'),
                  const SizedBox(height: 24),

                  // Play and download buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Play action
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow),
                              SizedBox(width: 8),
                              Text('Play'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Download action
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download),
                              SizedBox(width: 8),
                              Text('Download'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Synopsis
                  Text(
                    'Synopsis',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    anime.synopsis ?? 'No synopsis available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Genres as labels
                  Text(
                    'Genres',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: anime.genres.isNotEmpty
                        ? anime.genres.map((genre) {
                            return Chip(
                              label: Text(genre.name),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                            );
                          }).toList()
                        : [const Chip(label: Text('N/A'))],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Tabs for episodes and recommendations
          SliverToBoxAdapter(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Episodes'),
                    Tab(text: 'Recommendations'),
                    Tab(text: 'Reviews'),
                  ],
                ),
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Episodes tab with dummy data
                      _buildEpisodesTab(),
                      // Recommendations tab with dummy data
                      _buildRecommendationsTab(),
                      // Reviews tab with dummy data
                      _buildReviewsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailerSection(Anime anime) {
    // Check if trailer URL is available and display a WebView if so
    if (anime.trailerUrl != null && anime.trailerUrl!.isNotEmpty) {
      return OmniVideoPlayer(
        // Called when the internal video controller is ready.
        callbacks: VideoPlayerCallbacks(
          onControllerCreated: (controller) {
            // Controller is ready for video playback
          },
        ),

        // Minimal configuration: playing a YouTube video.
        options: VideoPlayerConfiguration(
          videoSourceConfiguration: VideoSourceConfiguration.youtube(
            videoUrl: Uri.parse(
              anime.trailerUrl as String,
            ),
            preferredQualities: [
              OmniVideoQuality.high720,
              OmniVideoQuality.low144,
            ],
            availableQualities: [
              OmniVideoQuality.high1080,
              OmniVideoQuality.high720,
              OmniVideoQuality.low144,
            ],
          ),
          playerTheme: OmniVideoPlayerThemeData().copyWith(
            icons: VideoPlayerIconTheme().copyWith(error: Icons.warning),
            overlays: VideoPlayerOverlayTheme().copyWith(
              backgroundColor: Colors.white,
              alpha: 25,
            ),
          ),
          playerUIVisibilityOptions: PlayerUIVisibilityOptions().copyWith(
            showMuteUnMuteButton: true,
            showFullScreenButton: true,
            useSafeAreaForBottomControls: true,
          ),
          customPlayerWidgets: CustomPlayerWidgets().copyWith(
            thumbnailFit: BoxFit.fitWidth,
          ),
        ),
      );
    }

    // Fallback to placeholder if no trailer URL is available
    return const Center(
      child: Icon(
        Icons.play_circle_fill,
        size: 80,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildWebView(Anime anime) {
    return FutureBuilder<String?>(
      future: _getUrlFromSupabase(widget.malId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        late WebViewController controller;
        String targetUrl;

        if (snapshot.hasData && snapshot.data != null) {
          // URL exists in Supabase, use it to scrape episodes
          targetUrl = snapshot.data!;
          print('Using existing URL from Supabase: $targetUrl');

          controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) async {
                  print('URL From WebView: $url');
                  // Scrape episodes from the anime page
                  await _scrapeEpisodes(controller);
                },
                onWebResourceError: (WebResourceError error) {},
              ),
            )
            ..loadRequest(Uri.parse(targetUrl));
        } else {
          // URL doesn't exist, proceed with initial scraping
          targetUrl =
              "https://v8.kuramanime.tel/anime?search=${Uri.encodeComponent(anime.title)}&order_by=oldest";
          print('No URL found, searching for anime: $targetUrl');

          controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) async {
                  print('URL From WebView: $url');
                  // Scrape href URLs using CSS selector
                  await _scrapeHrefUrls(controller);
                },
                onWebResourceError: (WebResourceError error) {},
              ),
            )
            ..loadRequest(Uri.parse(targetUrl));
        }

        return WebViewWidget(controller: controller);
      },
    );
  }

  Future<String?> _getUrlFromSupabase(int malId) async {
    try {
      final supabaseService = GetIt.instance<SupabaseService>();
      final response = await supabaseService.client
          .from('anime_provider_urls')
          .select('url')
          .eq('mal_id', malId)
          .eq('provider', 'kuramanime')
          .limit(1);

      print('Checking URL existence for malId: $malId');

      if (response.isNotEmpty) {
        final url = response[0]['url'] as String;
        print('Found URL: $url');
        return url;
      }

      print('No URL found for malId: $malId');
      return null;
    } catch (e) {
      print('Error getting URL from Supabase: $e');
      return null; // If error occurs, proceed with initial scraping
    }
  }

  Future<void> _scrapeEpisodes(WebViewController controller) async {
    try {
      // Delay execution for 1 seconds to ensure page loads
      await Future.delayed(const Duration(seconds: 1));

      // Extract episode URLs from the popover body
      const String scrapeEpisodesCode = '''
        (function() {
          // Select the element by its id
          const episodeLists = document.getElementById("episodeLists");
          // Retrieve the value of data-content
          const dataContent = episodeLists.getAttribute("data-content");
          // Create a temporary container
          const container = document.createElement("div");
          // Parse the HTML string
          container.innerHTML = dataContent;
          // Now you can query the links inside
          const links = container.querySelectorAll("a");
          const episodes = [];
          links.forEach(link => {
            const href = link.href;
            const text = link.textContent.trim();
            if (href && text) {
              episodes.push({
                url: href,
                title: text
              });
            }
          });
          return JSON.stringify(episodes);
        })();
      ''';

      final result =
          await controller.runJavaScriptReturningResult(scrapeEpisodesCode);

      if (result != null) {
        final String jsonString = result.toString();
        if (jsonString.isNotEmpty && jsonString != 'null') {
          await _processScrapedEpisodes(jsonString);
        } else {
          print('No episodes found');
        }
      }
    } catch (e) {
      print('Error scraping episodes: $e');
    }
  }

  Future<void> _processScrapedEpisodes(String jsonString) async {
    try {
      // Remove surrounding quotes if present
      String cleanJson = jsonString;
      if (cleanJson.startsWith('"') && cleanJson.endsWith('"')) {
        cleanJson = cleanJson.substring(1, cleanJson.length - 1);
        // Unescape internal quotes
        cleanJson = cleanJson.replaceAll('\\"', '"');
      }

      final List<dynamic> episodes = json.decode(cleanJson);
      print('Found ${episodes.length} episodes');

      // Store episodes in state variable instead of Supabase
      setState(() {
        _scrapedEpisodes = episodes
            .map((episode) => {
                  'episode_title': episode['title'] ?? 'Unknown Episode',
                  'episode_url': episode['url'] ?? '',
                  'provider': 'kuramanime',
                })
            .toList();
      });

      print('Episodes stored in state: ${_scrapedEpisodes.length}');
    } catch (e) {
      print('Error processing scraped episodes: $e');
    }
  }

  Future<void> _scrapeHrefUrls(WebViewController controller) async {
    try {
      // Delay execution for 1 seconds
      await Future.delayed(const Duration(seconds: 1));

      // JavaScript to extract href URLs using the CSS selector
      const String jsCode = '''
        (function() {
          const element = document.querySelector('#animeList > div:nth-child(1) > a');
          console.log(element);
          const url = element.href;
          return JSON.stringify(url);
        })();
      ''';

      final result = await controller.runJavaScriptReturningResult(jsCode);

      if (result != null) {
        // Parse the JSON result
        final String jsonString = result.toString().replaceAll('"', '');
        if (jsonString.isNotEmpty && jsonString != 'null') {
          // Remove surrounding quotes and parse as JSON
          final String cleanJson = result.toString().replaceAll('\\"', '');
          print('Scraped URLs: $cleanJson');

          // You can process the URLs here
          // For example, store them in a state variable or pass to another method
          await _handleScrapedUrl(cleanJson);
        }
      }
    } catch (e) {
      print('Error scraping URLs: $e');
    }
  }

  Future<void> _handleScrapedUrl(String url) async {
    try {
      // Remove quotes from the URL if present
      final cleanUrl = url.replaceAll('"', '');

      // Prepare data for insertion
      final data = {
        'mal_id': widget.malId,
        'provider': 'kuramanime',
        'url': cleanUrl,
      };

      print('Inserting URL into Supabase: $data');

      // Insert into anime_provider_urls table
      final response = await SupabaseService.instance.client
          .from('anime_provider_urls')
          .insert(data);

      print('Successfully inserted URL into database');
    } catch (e) {
      print('Error inserting URL into database: $e');
    }
  }

  Widget _buildEpisodesTab() {
    if (_scrapedEpisodes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No episodes available',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Episodes will appear here after scraping',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _scrapedEpisodes.length,
      itemBuilder: (context, index) {
        final episode = _scrapedEpisodes[index];
        return ListTile(
          title: Text(episode['episode_title'] ?? 'Episode ${index + 1}'),
          subtitle: Text('Provider: ${episode['provider'] ?? 'Unknown'}'),
          trailing: const Icon(Icons.play_arrow),
          onTap: () {
            // Navigate to episode player with episode URL
            final episodeUrl = episode['episode_url'];
            if (episodeUrl != null && episodeUrl.isNotEmpty) {
              // TODO: Navigate to video player with episodeUrl
              print('Playing episode: $episodeUrl');
            }
          },
        );
      },
    );
  }

  Widget _buildRecommendationsTab() {
    // Dummy data for recommendations
    final recommendations = List.generate(
      5,
      (index) => {
        'id': index + 1,
        'title': 'Recommended Anime ${index + 1}',
        'image': 'https://via.placeholder.com/150',
      },
    );

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = recommendations[index] as Map<String, dynamic>;
        return Container(
          width: 150,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recommendation['title'] as String,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    // Dummy data for reviews
    final reviews = List.generate(
      3,
      (index) => {
        'user': 'User ${index + 1}',
        'rating': 4.5 - index * 0.5,
        'comment': 'This is a great anime! I really enjoyed watching it. '
            'The story is engaging and the characters are well-developed.',
        'date': '2023-10-${10 + index}',
      },
    );

    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index] as Map<String, dynamic>;
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['user'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(review['date'] as String),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < (review['rating'] as num)
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(review['comment'] as String),
              ],
            ),
          ),
        );
      },
    );
  }
}
