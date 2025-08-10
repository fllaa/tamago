import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double? rating;
  final int? year;

  const MovieCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    this.rating,
    this.year,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie detail page
        // For now, we'll just print the ID
        print('Movie tapped: $id');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                      child: AspectRatio(
                        aspectRatio:
                            425 / 600, // Netflix-like aspect ratio for posters
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback image if network image fails
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.movie,
                                size: 40,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (rating != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // Movie title
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie title with ellipsis if too long
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: constraints.maxWidth *
                                  0.09, // Responsive font size
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Year information
                      if (year != null)
                        Text(
                          '$year',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[400],
                                    fontSize: constraints.maxWidth *
                                        0.07, // Responsive font size
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
