import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:tamago/core/localization/app_localizations.dart';
import 'package:tamago/presentation/pages/anime/anime_detail_page.dart';
import 'package:tamago/presentation/viewmodels/search/search_bloc.dart';
import 'package:get_it/get_it.dart';

class AnimeListItem extends StatelessWidget {
  final Anime anime;

  const AnimeListItem({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AnimeDetailPage(
              malId: anime.malId,
              imageUrl: anime.imageUrl,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image with Hero animation
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: 'anime_poster_${anime.malId}',
                child: Image.network(
                  anime.imageUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.movie,
                        size: 30,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 18.0),
            // Anime Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    anime.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  // Year and Status
                  Row(
                    children: [
                      if (anime.year != null) ...[
                        Text(
                          '${anime.year}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(width: 8.0),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: anime.airing
                              ? Colors.green.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          anime.airing ? 'Airing' : 'Finished',
                          style: TextStyle(
                            color: anime.airing ? Colors.green : Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  // Score
                  if (anime.score != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          anime.score!.toStringAsFixed(1),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6.0),
                  // Synopsis (truncated)
                  if (anime.synopsis != null && anime.synopsis!.isNotEmpty)
                    Text(
                      anime.synopsis!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                            height: 1.3,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late TextEditingController _searchController;
  Timer? _debounceTimer;
  late SearchBloc _searchBloc;
  String _currentQuery = '';

  static const Duration _debounceDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _searchBloc = GetIt.I<SearchBloc>();

    // Restore search query from bloc state
    final currentState = _searchBloc.state;
    if (currentState is SearchLoaded) {
      _currentQuery = currentState.query;
    }

    // Initialize search controller with restored query
    _searchController = TextEditingController(text: _currentQuery);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    // Don't close the bloc since it's a singleton
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    _currentQuery = query;

    // Cancel previous timer
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      _searchBloc.add(ClearSearch());
      return;
    }

    // Start new timer for debounced search
    _debounceTimer = Timer(_debounceDuration, () {
      _searchBloc.add(SearchAnime(query: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('explore')),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for anime...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
              ),
            ),
            // Result List
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return Center(
                      child: Text(
                        'Start typing to search for anime...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  } else if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchLoaded) {
                    if (state.results.isEmpty) {
                      return Center(
                        child: Text(
                          'No results found. Try a different search term.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        final anime = state.results[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 0,
                          ),
                          child: AnimeListItem(anime: anime),
                        );
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final query = _searchController.text.trim();
                              if (query.isNotEmpty) {
                                _searchBloc.add(SearchAnime(query: query));
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
