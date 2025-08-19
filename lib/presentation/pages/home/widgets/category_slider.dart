import 'package:flutter/material.dart';
import 'package:tamago/domain/entities/genre.dart' as app_genre;
import 'package:cached_network_image/cached_network_image.dart';

class CategorySlider extends StatelessWidget {
  final List<app_genre.Genre> genres;

  const CategorySlider({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12, // 12% of screen height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.12, // 12% of screen width
                  height: MediaQuery.of(context).size.width *
                      0.12, // Square container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: genre.icon,
                      placeholder: (context, url) => SizedBox(
                          height: 8,
                          width: 8,
                          child: const LinearProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  genre.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.width *
                            0.025, // 2.5% of screen width
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
