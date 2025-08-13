import 'package:flutter/material.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_boilerplate/core/services/anime_service.dart';
import 'package:omni_video_player/omni_video_player.dart';

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
  Anime? _anime;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAnimeDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAnimeDetails() async {
    try {
      final anime = await AnimeService.instance.getAnime(widget.malId);
      if (mounted) {
        setState(() {
          _anime = anime;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load anime details';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Anime Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _anime == null
                  ? const Center(child: Text('Anime not found'))
                  : CustomScrollView(
                      slivers: [
                        // Trailer video section (without safe area)
                        SliverToBoxAdapter(
                          child: Container(
                            height: 250,
                            color: Colors.black,
                            child: _buildTrailerSection(),
                          ),
                        ),

                        // Anime information section
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and English title
                                Text(
                                  _anime!.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (_anime!.titleEnglish != null &&
                                    _anime!.titleEnglish!.isNotEmpty)
                                  Text(
                                    _anime!.titleEnglish!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.7),
                                        ),
                                  ),
                                const SizedBox(height: 16),

                                // Aired date, season, status, studio, and rating
                                _buildInfoRow('Aired',
                                    _anime!.aired?.toString() ?? 'N/A'),
                                _buildInfoRow('Season',
                                    _anime!.season?.toString() ?? 'N/A'),
                                _buildInfoRow('Status',
                                    _anime!.status?.toString() ?? 'N/A'),
                                _buildInfoRow(
                                    'Studio',
                                    _anime!.studios.isNotEmpty == true
                                        ? _anime!.studios
                                            .map((s) => s.name)
                                            .join(', ')
                                        : 'N/A'),
                                _buildInfoRow('Score',
                                    _anime!.score?.toString() ?? 'N/A'),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                  _anime!.synopsis ?? 'No synopsis available',
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
                                  children: _anime!.genres.isNotEmpty
                                      ? _anime!.genres.map((genre) {
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

  Widget _buildTrailerSection() {
    // Check if trailer URL is available and display a WebView if so
    if (_anime!.trailerUrl != null && _anime!.trailerUrl!.isNotEmpty) {
      return OmniVideoPlayer(
        // Called when the internal video controller is ready.
        callbacks: VideoPlayerCallbacks(
          onControllerCreated: (controller) {
            // We call setState to trigger a rebuild so that
            // the play/pause button below knows the controller is ready.
            if (!mounted) return;
            setState(() {});
          },
        ),

        // Minimal configuration: playing a YouTube video.
        options: VideoPlayerConfiguration(
          videoSourceConfiguration: VideoSourceConfiguration.youtube(
            videoUrl: Uri.parse(
              _anime!.trailerUrl as String,
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

  Widget _buildEpisodesTab() {
    // Dummy data for episodes
    final episodes = List.generate(
      12,
      (index) => {
        'id': index + 1,
        'title': 'Episode ${index + 1}',
        'duration': '24 min',
        'aired': 'Oct ${index + 1}, 2023',
      },
    );

    return ListView.builder(
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index] as Map<String, dynamic>;
        return ListTile(
          title: Text(episode['title'] as String),
          subtitle: Text('${episode['duration']} • ${episode['aired']}'),
          trailing: const Icon(Icons.play_arrow),
          onTap: () {
            // Play episode action
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
