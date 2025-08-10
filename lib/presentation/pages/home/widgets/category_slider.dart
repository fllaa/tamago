import 'package:flutter/material.dart';

class CategorySlider extends StatelessWidget {
  final List<Map<String, dynamic>> genres;

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
                      0.15, // 15% of screen width
                  height: MediaQuery.of(context).size.width *
                      0.15, // Square container
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    genre['icon'] as IconData,
                    color: Theme.of(context).colorScheme.primary,
                    size: MediaQuery.of(context).size.width *
                        0.08, // 8% of screen width
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  genre['name'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width *
                            0.035, // 3.5% of screen width
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
