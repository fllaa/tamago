import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/movie_card.dart';

class MovieRow extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> movies;
  final VoidCallback? onViewAll;
  final bool showViewAll;

  const MovieRow({
    super.key,
    required this.title,
    required this.movies,
    this.onViewAll,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width *
                          0.045, // Responsive font size
                    ),
              ),
              if (showViewAll && onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View All'),
                ),
            ],
          ),
        ),
        SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.29, // 29% of screen height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.35, // 35% of screen width
                  child: MovieCard(
                    id: movie['id'] as String,
                    title: movie['title'] as String,
                    imageUrl: movie['image'] as String,
                    rating: movie['rating'] as double?,
                    year: movie['year'] as int?,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
