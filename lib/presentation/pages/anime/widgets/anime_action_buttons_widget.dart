import 'package:flutter/material.dart';

class AnimeActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onPlayPressed;
  final VoidCallback? onDownloadPressed;

  const AnimeActionButtonsWidget({
    super.key,
    this.onPlayPressed,
    this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPlayPressed ?? () {
              // Default play action
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow),
                SizedBox(width: 8),
                Text('Play'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: onDownloadPressed ?? () {
              // Default download action
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download),
                SizedBox(width: 8),
                Text('Download'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}