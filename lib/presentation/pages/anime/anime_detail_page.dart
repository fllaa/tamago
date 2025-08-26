import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:omni_video_player/omni_video_player.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';
import 'package:tamago/di/injection_container.dart';

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
  final Set<int> _expandedReviews = <int>{};

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
        return bloc;
      },
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
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Episodes tab with real data
                      BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
                        builder: (context, state) {
                          if (state is AnimeDetailLoaded) {
                            return _buildEpisodesTab(state);
                          }
                          return _buildEpisodesTab(null);
                        },
                      ),
                      // Recommendations tab with dummy data
                      _buildRecommendationsTab(),
                      // Reviews tab with real data
                      BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
                        builder: (context, state) {
                          if (state is AnimeDetailLoaded) {
                            return _buildReviewsTab(state);
                          }
                          return _buildReviewsTab(null);
                        },
                      ),
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

  Widget _buildEpisodesTab(AnimeDetailLoaded? state) {
    // Handle loading state
    if (state?.episodesLoading == true) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading episodes...'),
          ],
        ),
      );
    }

    // Handle error state
    if (state?.episodesError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              state!.episodesError!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<AnimeDetailBloc>().add(
                      LoadAnimeEpisodes(malId: widget.malId),
                    );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Handle episodes data
    final episodes = state?.episodes;
    if (episodes == null || episodes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tv_off,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No episodes available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              episode.malId.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            episode.title ?? 'Episode ${episode.malId}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (episode.aired != null)
                Text(
                  'Aired: ${_formatAiredDate(episode.aired!)}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              if (episode.score != null)
                Text(
                  'Score: ${episode.score}',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
            ],
          ),
          trailing: const Icon(Icons.play_arrow),
          onTap: () {
            // Play episode action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Playing ${episode.title ?? "Episode ${episode.malId}"}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  String _formatAiredDate(String airedDate) {
    try {
      final dateTime = DateTime.parse(airedDate);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return airedDate; // Return original if parsing fails
    }
  }

  Widget _buildRecommendationsTab() {
    return BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
      builder: (context, state) {
        if (state is AnimeDetailLoaded) {
          if (state.recommendationsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.recommendationsError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load recommendations',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.recommendationsError!,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state.recommendations == null || state.recommendations!.isEmpty) {
            return const Center(
              child: Text('No recommendations available'),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.recommendations!.length,
            itemBuilder: (context, index) {
              final recommendation = state.recommendations![index];
              return Container(
                width: 150,
                margin: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the recommended anime detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimeDetailPage(
                          malId: recommendation.entry.malId,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              recommendation.entry.imageUrl ??
                                  'https://via.placeholder.com/150',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recommendation.entry.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${recommendation.votes} votes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildReviewsTab(AnimeDetailLoaded? state) {
    if (state == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.reviewsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.reviewsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading reviews',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.reviewsError!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<AnimeDetailBloc>().add(
                      LoadAnimeReviews(malId: widget.malId, page: 1),
                    );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final reviews = state.reviews ?? [];

    if (reviews.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No reviews available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
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
                    Expanded(
                      child: Text(
                        review.user?.username ?? 'Anonymous',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      review.date,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (review.score != null)
                  Row(
                    children: [
                      ...List.generate(5, (starIndex) {
                        final convertedScore = review.score! /
                            2.0; // Convert 10-point to 5-point scale
                        return Icon(
                          starIndex < convertedScore.floor()
                              ? Icons.star
                              : (starIndex < convertedScore &&
                                      convertedScore % 1 >= 0.5)
                                  ? Icons.star_half
                                  : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${(review.score! / 2.0).toStringAsFixed(1)}/5',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                if (review.review != null && review.review!.isNotEmpty)
                  _buildReviewText(review.review!, index),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewText(String reviewText, int index) {
    const int maxLength = 200; // Maximum characters to show when truncated
    final bool isExpanded = _expandedReviews.contains(index);
    final bool needsTruncation = reviewText.length > maxLength;

    if (!needsTruncation || isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reviewText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (needsTruncation && isExpanded)
            TextButton(
              onPressed: () {
                setState(() {
                  _expandedReviews.remove(index);
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Show less',
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${reviewText.substring(0, maxLength)}...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _expandedReviews.add(index);
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'More',
          ),
        ),
      ],
    );
  }
}
