import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';
import 'package:tamago/di/injection_container.dart';
import 'widgets/anime_trailer_widget.dart';
import 'widgets/cache_indicator_widget.dart';
import 'widgets/anime_info_section_widget.dart';
import 'widgets/anime_episodes_tab_widget.dart';
import 'widgets/anime_recommendations_tab_widget.dart';
import 'widgets/anime_reviews_tab_widget.dart';
import 'package:tamago/presentation/widgets/anime_scraping_webview.dart';

class AnimeDetailPage extends StatefulWidget {
  final int malId;
  final String? imageUrl;

  const AnimeDetailPage({
    super.key,
    required this.malId,
    this.imageUrl,
  });

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<AnimeDetailBloc>();
        // Load anime data when bloc is created
        bloc.add(LoadAnimeDetail(malId: widget.malId));
        bloc.add(LoadAnimeEpisodes(malId: widget.malId));
        bloc.add(LoadAnimeRecommendations(malId: widget.malId));
        bloc.add(LoadAnimeReviews(malId: widget.malId, page: 1));
        bloc.add(LoadAnimeProviderUrls(malId: widget.malId));
        return bloc;
      },
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
          builder: (context, state) {
            if (state is AnimeDetailLoading) {
              return CustomScrollView(
                slivers: [
                  // Trailer video section placeholder
                  SliverToBoxAdapter(
                    child: Container(
                      height: 250,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                  // Anime information section placeholder
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Poster placeholder with hero tag
                          Container(
                            width: 120,
                            height: 180,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Hero(
                                tag: 'anime_poster_${widget.malId}',
                                child: widget.imageUrl != null
                                    ? Image.network(
                                        widget.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          // Info placeholder
                          const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
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
                  context, state.anime, state.isFromCache, state);
            }
            return const Center(child: Text('Anime not found'));
          },
            ),
            // Floating back button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            // Floating refresh button (only shown when data is from cache)
            BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
              builder: (context, state) {
                if (state is AnimeDetailLoaded && state.isFromCache) {
                  return Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          context.read<AnimeDetailBloc>().add(
                                RefreshAnimeDetail(malId: widget.malId),
                              );
                        },
                        tooltip: 'Refresh (cached data)',
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimeContent(BuildContext context, Anime anime, bool isFromCache,
      AnimeDetailLoaded state) {
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
              child: AnimeTrailerWidget(anime: anime),
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
                  CacheIndicatorWidget(isFromCache: isFromCache),

                  // Anime information section
                  AnimeInfoSectionWidget(
                    anime: anime,
                    onPlayPressed: () {
                      // TODO: Implement play functionality
                    },
                    onDownloadPressed: () {
                      // TODO: Implement download functionality
                    },
                  ),

                  const SizedBox(height: 16),

                  // Provider scraping section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Anime Providers',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<AnimeDetailBloc>().add(
                                ScrapeAnimeProviders(
                                  malId: widget.malId,
                                  animeTitle: anime.title ?? 'Unknown',
                                  webViewController: null, // Will be handled by the WebView
                                ),
                              );
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Scrape Providers'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
                        builder: (context, state) {
                          if (state is AnimeDetailLoaded) {
                            if (state.scrapingInProgress) {
                              return const Card(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Scraping providers...'),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            if (state.providerUrls != null && state.providerUrls!.isNotEmpty) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Found ${state.providerUrls!.length} provider(s)',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      ...state.providerUrls!.map((url) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Text('• ${url.providerName}: ${url.path}'),
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            if (state.providerUrlsError != null) {
                              return Card(
                                color: Colors.red.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Error: ${state.providerUrlsError}',
                                    style: TextStyle(color: Colors.red.shade700),
                                  ),
                                ),
                              );
                            }
                          }
                          
                          return const Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Click "Scrape Providers" to find anime sources'),
                            ),
                          );
                        },
                      ),
                      AnimeScrapingWebView(
                        malId: widget.malId,
                        animeTitle: anime.title ?? 'Unknown',
                        isVisible: false,
                      ),
                    ],
                  ),
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
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      AnimeEpisodesTabWidget(malId: widget.malId, state: state),
                      const AnimeRecommendationsTabWidget(),
                      AnimeReviewsTabWidget(malId: widget.malId, state: state),
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
}
