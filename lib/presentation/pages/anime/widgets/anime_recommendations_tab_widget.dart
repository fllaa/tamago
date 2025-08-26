import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';
import '../anime_detail_page.dart';

class AnimeRecommendationsTabWidget extends StatelessWidget {
  const AnimeRecommendationsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                    // Navigate to the recommended anime detail page with hero-friendly transition
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AnimeDetailPage(
                          malId: recommendation.entry.malId,
                          imageUrl: recommendation.entry.imageUrl,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Hero(
                            tag: 'anime_poster_${recommendation.entry.malId}',
                            child: Image.network(
                              recommendation.entry.imageUrl ??
                                  'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
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
}