import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:async';

class HeroBanner extends StatefulWidget {
  final List<Map<String, dynamic>> movies;

  const HeroBanner({
    super.key,
    required this.movies,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  Color? _dominantColor;
  int _currentPage = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _updateDominantColor();
    _startAutoScroll();
  }

  Future<void> _updateDominantColor() async {
    if (widget.movies.isEmpty) return;

    try {
      final currentMovie = widget.movies[_currentPage];
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(currentMovie['image'] as String),
      );
      setState(() {
        _dominantColor = paletteGenerator.dominantColor?.color;
      });
    } catch (e) {
      // If we can't get the dominant color, default to white
      setState(() {
        _dominantColor = Colors.white;
      });
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % widget.movies.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
        _updateDominantColor();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    // Set status bar color based on dominant color
    final isLightColor = _dominantColor != null
        ? (_dominantColor!.computeLuminance() > 0.5)
        : false;

    // Update status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isLightColor ? Brightness.dark : Brightness.light,
      ),
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4, // 40% of screen height
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          _updateDominantColor();
        },
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(movie['image'] as String),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie['title'] as String,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.07, // Responsive font size
                              ),
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      movie['description'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: MediaQuery.of(context).size.width *
                                0.035, // Responsive font size
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Action buttons
                    Row(
                      children: [
                        // Play button
                        ElevatedButton(
                          onPressed: () {
                            // Play action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Play',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // More info button
                        OutlinedButton(
                          onPressed: () {
                            // More info action
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'More Info',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
