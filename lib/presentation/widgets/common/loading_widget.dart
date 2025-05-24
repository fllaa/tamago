import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;
  
  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size + 12,
            width: size + 12,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}