import 'package:flutter/material.dart';

class CacheIndicatorWidget extends StatelessWidget {
  final bool isFromCache;

  const CacheIndicatorWidget({
    super.key,
    required this.isFromCache,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFromCache) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.offline_bolt,
            size: 16,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 4),
          Text(
            'Cached data',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }
}