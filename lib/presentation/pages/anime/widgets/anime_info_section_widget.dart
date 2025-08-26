import 'package:flutter/material.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'anime_poster_widget.dart';
import 'anime_action_buttons_widget.dart';

class AnimeInfoSectionWidget extends StatelessWidget {
  final Anime anime;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onDownloadPressed;

  const AnimeInfoSectionWidget({
    super.key,
    required this.anime,
    this.onPlayPressed,
    this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster image and info rows section
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster image on the left
            AnimePosterWidget(
              imageUrl: anime.imageUrl,
              malId: anime.malId,
            ),
            // Info rows on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and English title
                  Text(
                    anime.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (anime.titleEnglish != null &&
                      anime.titleEnglish!.isNotEmpty)
                    Text(
                      anime.titleEnglish!,
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
                  _buildInfoRow(context, 'Aired', anime.aired?.toString() ?? 'N/A'),
                  _buildInfoRow(context, 'Season', anime.season?.toString() ?? 'N/A'),
                  _buildInfoRow(context, 'Status', anime.status?.toString() ?? 'N/A'),
                  _buildInfoRow(
                    context,
                    'Studio',
                    anime.studios.isNotEmpty == true
                        ? anime.studios.map((s) => s.name).join(', ')
                        : 'N/A',
                  ),
                  _buildInfoRow(context, 'Score', anime.score?.toString() ?? 'N/A'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Play and download buttons
        AnimeActionButtonsWidget(
          onPlayPressed: onPlayPressed,
          onDownloadPressed: onDownloadPressed,
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
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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
}