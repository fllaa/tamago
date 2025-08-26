import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';

class AnimeEpisodesTabWidget extends StatelessWidget {
  final int malId;
  final AnimeDetailLoaded? state;

  const AnimeEpisodesTabWidget({
    super.key,
    required this.malId,
    this.state,
  });

  @override
  Widget build(BuildContext context) {
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
                      LoadAnimeEpisodes(malId: malId),
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
}