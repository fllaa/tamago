import 'package:flutter/material.dart';
import 'package:omni_video_player/omni_video_player.dart';

class AnimeEpisodePage extends StatefulWidget {
  final int animeId;
  final int episodeNumber;
  final String? animeTitle;

  const AnimeEpisodePage({
    super.key,
    required this.animeId,
    required this.episodeNumber,
    this.animeTitle,
  });

  @override
  State<AnimeEpisodePage> createState() => _AnimeEpisodePageState();
}

class _AnimeEpisodePageState extends State<AnimeEpisodePage> {
  String selectedQuality = '1080p';
  String selectedProvider = 'Provider 1';

  final List<String> qualities = ['480p', '720p', '1080p', '4K'];
  final List<String> providers = ['Provider 1', 'Provider 2', 'Provider 3'];

  // Dummy episode data
  final List<Map<String, dynamic>> episodes = List.generate(
      24,
      (index) => {
            'number': index + 1,
            'title': 'Episode ${index + 1}',
            'duration': '24:30',
            'thumbnail': 'https://via.placeholder.com/160x90',
          });

  // Dummy comments
  final List<Map<String, dynamic>> comments = [
    {
      'user': 'AnimeUser123',
      'avatar': 'https://via.placeholder.com/40x40',
      'comment': 'Great episode! The animation quality was amazing.',
      'time': '2 hours ago',
      'likes': 15,
    },
    {
      'user': 'OtakuFan',
      'avatar': 'https://via.placeholder.com/40x40',
      'comment':
          'I love how the story is developing. Can\'t wait for the next episode!',
      'time': '5 hours ago',
      'likes': 8,
    },
    {
      'user': 'AnimeLover',
      'avatar': 'https://via.placeholder.com/40x40',
      'comment': 'The soundtrack in this episode was perfect.',
      'time': '1 day ago',
      'likes': 23,
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Video Player
          _buildVideoPlayer(),
          // Scrollable Content
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Episode Info
                    _buildTitleSection(),
                    // Episode List (Horizontal)
                    _buildEpisodeList(),
                    // Comments Section
                    _buildCommentsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 250,
      width: double.infinity,
      child: OmniVideoPlayer(
        // Called when the internal video controller is ready.
        callbacks: VideoPlayerCallbacks(
          onControllerCreated: (controller) {
            // Controller is ready for video playback
          },
        ),

        options: VideoPlayerConfiguration(
          videoSourceConfiguration: VideoSourceConfiguration.network(
            videoUrl: Uri.parse(
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            ),
          ),
          playerTheme: OmniVideoPlayerThemeData().copyWith(
            icons: VideoPlayerIconTheme().copyWith(error: Icons.warning),
            overlays: VideoPlayerOverlayTheme().copyWith(
              backgroundColor: Colors.black,
              alpha: 25,
            ),
          ),
          playerUIVisibilityOptions: PlayerUIVisibilityOptions().copyWith(
            showMuteUnMuteButton: true,
            showFullScreenButton: true,
            useSafeAreaForBottomControls: true,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.animeTitle ?? 'Anime Title',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Episode ${widget.episodeNumber} • a week ago',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Control buttons
          Row(
            children: [
              _buildControlButton(
                icon: Icons.high_quality,
                label: selectedQuality,
                onTap: () => _showQualitySelector(),
              ),
              const SizedBox(width: 12),
              _buildControlButton(
                icon: Icons.cloud,
                label: selectedProvider,
                onTap: () => _showProviderSelector(),
              ),
              const SizedBox(width: 12),
              _buildControlButton(
                icon: Icons.share,
                label: 'Share',
                onTap: () => _shareEpisode(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeList() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Episodes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episode = episodes[index];
                final isCurrentEpisode = episode['number'] == widget.episodeNumber;
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      if (!isCurrentEpisode) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimeEpisodePage(
                              animeId: widget.animeId,
                              episodeNumber: episode['number'],
                              animeTitle: widget.animeTitle,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isCurrentEpisode 
                            ? (Theme.of(context).brightness == Brightness.dark 
                                ? Colors.white 
                                : Theme.of(context).primaryColor)
                            : (Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[800] 
                                : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(8),
                        border: isCurrentEpisode 
                            ? Border.all(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white 
                                    : Theme.of(context).primaryColor, 
                                width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${episode['number']}',
                          style: TextStyle(
                            color: isCurrentEpisode 
                                ? (Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.black 
                                    : Colors.white)
                                : (Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white70 
                                    : Colors.black87),
                            fontWeight: isCurrentEpisode ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Comments',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${comments.length}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // Comment input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/32x32'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Comments list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: comments.length,
          itemBuilder: (context, index) {
              final comment = comments[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(comment['avatar']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment['user'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                comment['time'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment['comment'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.thumb_up_outlined,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${comment['likes']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  'Reply',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  void _showQualitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Quality',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...qualities.map((quality) => ListTile(
                  title: Text(quality),
                  trailing: selectedQuality == quality
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedQuality = quality;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showProviderSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Provider',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...providers.map((provider) => ListTile(
                  title: Text(provider),
                  trailing: selectedProvider == provider
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedProvider = provider;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _shareEpisode() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
      ),
    );
  }
}
