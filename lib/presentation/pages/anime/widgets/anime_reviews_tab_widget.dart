import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/presentation/viewmodels/anime_detail/anime_detail_bloc.dart';

class AnimeReviewsTabWidget extends StatefulWidget {
  final int malId;
  final AnimeDetailLoaded? state;

  const AnimeReviewsTabWidget({
    super.key,
    required this.malId,
    this.state,
  });

  @override
  State<AnimeReviewsTabWidget> createState() => _AnimeReviewsTabWidgetState();
}

class _AnimeReviewsTabWidgetState extends State<AnimeReviewsTabWidget> {
  final Set<int> _expandedReviews = <int>{};

  @override
  Widget build(BuildContext context) {
    if (widget.state == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state!.reviewsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state!.reviewsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading reviews',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              widget.state!.reviewsError!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<AnimeDetailBloc>().add(
                      LoadAnimeReviews(malId: widget.malId, page: 1),
                    );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final reviews = widget.state!.reviews ?? [];

    if (reviews.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No reviews available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
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
                    Expanded(
                      child: Text(
                        review.user?.username ?? 'Anonymous',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      review.date,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (review.score != null)
                  Row(
                    children: [
                      ...List.generate(5, (starIndex) {
                        final convertedScore = review.score! /
                            2.0; // Convert 10-point to 5-point scale
                        return Icon(
                          starIndex < convertedScore.floor()
                              ? Icons.star
                              : (starIndex < convertedScore &&
                                      convertedScore % 1 >= 0.5)
                                  ? Icons.star_half
                                  : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${(review.score! / 2.0).toStringAsFixed(1)}/5',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                if (review.review != null && review.review!.isNotEmpty)
                  _buildReviewText(review.review!, index),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewText(String reviewText, int index) {
    const int maxLength = 200; // Maximum characters to show when truncated
    final bool isExpanded = _expandedReviews.contains(index);
    final bool needsTruncation = reviewText.length > maxLength;

    if (!needsTruncation || isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reviewText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (needsTruncation && isExpanded)
            TextButton(
              onPressed: () {
                setState(() {
                  _expandedReviews.remove(index);
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Show less',
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${reviewText.substring(0, maxLength)}...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _expandedReviews.add(index);
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'More',
          ),
        ),
      ],
    );
  }
}