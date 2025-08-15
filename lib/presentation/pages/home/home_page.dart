import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/localization/app_localizations.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/home/home_bloc.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/category_slider.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/hero_banner.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/movie_row.dart';
import 'package:flutter_boilerplate/presentation/pages/profile/profile_page.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final HomeBloc _homeBloc;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _homeBloc = GetIt.I<HomeBloc>()..add(LoadHomeData());
    _pages = [
      BlocProvider.value(
        value: _homeBloc,
        child: const HomeContent(),
      ),
      Center(child: Text('Collections')),
      Center(child: Text('Explore')),
      BlocProvider(
        create: (context) => GetIt.I<ProfileViewModel>()..loadUserProfile(),
        child: const ProfilePage(),
      ),
    ];
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.transparent, // Remove default indicator
        destinations: [
          NavigationDestination(
            icon: Icon(LucideIcons.house),
            selectedIcon: Icon(LucideIcons.house200),
            label: AppLocalizations.of(context).translate('home'),
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.libraryBig),
            selectedIcon: Icon(LucideIcons.libraryBig200),
            label: AppLocalizations.of(context).translate('collections'),
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.compass),
            selectedIcon: Icon(LucideIcons.compass200),
            label: AppLocalizations.of(context).translate('explore'),
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.user),
            selectedIcon: Icon(LucideIcons.user200),
            label: AppLocalizations.of(context).translate('profile'),
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial || state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is HomeError && !state.hasCachedData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(RefreshHomeData());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show data from either HomeLoaded or HomeError with cached data
        final seasonNowAnimes = state is HomeLoaded
            ? state.seasonNowAnimes
            : (state as HomeError).cachedSeasonNowAnimes ?? [];
        final seasonUpcomingAnimes = state is HomeLoaded
            ? state.seasonUpcomingAnimes
            : (state as HomeError).cachedSeasonUpcomingAnimes ?? [];
        final topAnimes = state is HomeLoaded
            ? state.topAnimes
            : (state as HomeError).cachedTopAnimes ?? [];
        final genres = state is HomeLoaded
            ? state.genres
            : (state as HomeError).cachedGenres ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            final completer = Completer<void>();
            final bloc = context.read<HomeBloc>();
            
            // Listen for state changes to complete the refresh
            late StreamSubscription subscription;
            subscription = bloc.stream.listen((state) {
              if (state is HomeLoaded || state is HomeError) {
                subscription.cancel();
                completer.complete();
              }
            });
            
            bloc.add(RefreshHomeData());
            return completer.future;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show cache indicator if data is from cache
                if (state is HomeLoaded && state.isFromCache)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 8.0),
                    color: Colors.blue.withValues(alpha: 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cached, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          'Showing cached data',
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                // Show error banner if there's an error but we have cached data
                if (state is HomeError && state.hasCachedData)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.orange.withValues(alpha: 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, size: 16, color: Colors.orange),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Failed to refresh data. Showing cached content.',
                            style:
                                TextStyle(color: Colors.orange, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Hero Banner
                HeroBanner(
                  movies: seasonNowAnimes,
                ),

                // Categories/Genres
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Genres',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width *
                                  0.045, // Responsive font size
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
                CategorySlider(genres: genres),

                // Top Anime Row
                MovieRow(
                  title: 'All-Time Top Anime',
                  movies: topAnimes,
                ),

                const SizedBox(height: 16),

                // Upcoming Season Row
                MovieRow(
                  title: 'Upcoming Season Anime',
                  movies: seasonUpcomingAnimes,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
