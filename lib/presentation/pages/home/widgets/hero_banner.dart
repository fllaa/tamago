import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:async';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tamago/presentation/pages/anime/anime_detail_page.dart';
import 'package:tamago/app/app.dart';
import 'package:tamago/core/utils/tab_visibility_notifier.dart';

class HeroBanner extends StatefulWidget {
  final List<Anime>? movies;

  const HeroBanner({
    super.key,
    this.movies,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner>
    with WidgetsBindingObserver, RouteAware {
  Color? _dominantColor;
  int _currentPage = 0;
  late PageController _pageController;
  Timer? _timer;
  Timer? _colorUpdateTimer;
  bool _isAutoScrollPaused = false;
  late TabVisibilityNotifier _tabVisibilityNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabVisibilityNotifier = TabVisibilityNotifier();
    _tabVisibilityNotifier.addListener(_onTabVisibilityChanged);

    // Start at a large index to enable infinite scrolling
    final initialPage = (widget.movies?.length ?? 0) * 500;
    _pageController = PageController(initialPage: initialPage);
    _currentPage = initialPage;
    _updateDominantColor();
    _startAutoScroll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      App.routeObserver.subscribe(this, route as PageRoute<dynamic>);
    }
  }

  Future<void> _updateDominantColor() async {
    if (widget.movies == null || widget.movies!.isEmpty) return;

    try {
      final actualIndex = _currentPage % (widget.movies?.length ?? 1);
      final currentMovie = widget.movies![actualIndex];
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(
            currentMovie.imageUrl), // Using null-aware operator as fallback
      );
      if (mounted) {
        setState(() {
          _dominantColor = paletteGenerator.dominantColor?.color;
        });
      }
    } catch (e) {
      // If we can't get the dominant color, default to white
      if (mounted) {
        setState(() {
          _dominantColor = Colors.white;
        });
      }
    }
  }

  void _startAutoScroll() {
    if (_isAutoScrollPaused || !_tabVisibilityNotifier.isHomeTabVisible) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_pageController.hasClients &&
          mounted &&
          !_isAutoScrollPaused &&
          _tabVisibilityNotifier.isHomeTabVisible) {
        setState(() {
          _currentPage = _currentPage + 1;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
        // Update color after auto-scroll completes
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            _updateDominantColor();
          }
        });
      }
    });
  }

  void _pauseAutoScroll() {
    _isAutoScrollPaused = true;
    _timer?.cancel();
    _timer = null;
  }

  void _resumeAutoScroll() {
    _isAutoScrollPaused = false;
    _startAutoScroll();
  }

  void _onTabVisibilityChanged() {
    if (_tabVisibilityNotifier.isHomeTabVisible) {
      _resumeAutoScroll();
    } else {
      _pauseAutoScroll();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _resumeAutoScroll();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _pauseAutoScroll();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    App.routeObserver.unsubscribe(this);
    _tabVisibilityNotifier.removeListener(_onTabVisibilityChanged);
    _timer?.cancel();
    _colorUpdateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didPush() {
    // Called when the current route has been pushed.
    _resumeAutoScroll();
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and the current route shows up.
    _resumeAutoScroll();
  }

  @override
  void didPushNext() {
    // Called when a new route has been pushed, and the current route is no longer visible.
    _pauseAutoScroll();
  }

  @override
  void didPop() {
    // Called when the current route has been popped off.
    _pauseAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies == null) {
      // Show loading indicator when data is being fetched
      return SizedBox(
        height:
            MediaQuery.of(context).size.height * 0.4, // 40% of screen height
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.movies!.isEmpty) {
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
      height: MediaQuery.of(context).size.height * 0.33, // 33% of screen height
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          if (mounted) {
            // Only update state if the page actually changed
            if (_currentPage != index) {
              setState(() {
                _currentPage = index;
              });
              // Reset auto-scroll timer when user manually swipes
              if (!_isAutoScrollPaused && _tabVisibilityNotifier.isHomeTabVisible) {
                _startAutoScroll();
              }
              // Debounce color updates to prevent lag during swiping
              _colorUpdateTimer?.cancel();
              _colorUpdateTimer = Timer(const Duration(milliseconds: 600), () {
                if (mounted) {
                  _updateDominantColor();
                }
              });
            }
          }
        },
        itemCount: (widget.movies?.length ?? 0) * 1000,
        itemBuilder: (context, index) {
          final actualIndex = index % (widget.movies?.length ?? 1);
          final movie = widget.movies![actualIndex];
          return Hero(
            tag: 'anime_poster_${movie.malId}',
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(movie.imageUrl),
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
                        movie.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05, // Responsive font size
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Description
                      Text(
                        movie.synopsis ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.030, // Responsive font size
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
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
                                Icon(Icons.play_arrow, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Play',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.030, // Responsive font size
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
                              // Navigate to anime detail page with hero-friendly transition
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      AnimeDetailPage(
                                    malId: movie.malId,
                                    imageUrl: movie.imageUrl,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                ),
                              );
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
                                    color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'More Info',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.030, // Responsive font size
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
            ),
          );
        },
      ),
    );
  }
}
