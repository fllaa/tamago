import 'package:flutter/material.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:omni_video_player/omni_video_player.dart';

class AnimeTrailerWidget extends StatelessWidget {
  final Anime anime;

  const AnimeTrailerWidget({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
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
}