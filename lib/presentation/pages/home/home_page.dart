import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/localization/app_localizations.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_season_now_animes_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_season_upcoming_animes_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/anime/get_top_animes_usecase.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/category_slider.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/hero_banner.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/movie_row.dart';
import 'package:flutter_boilerplate/presentation/pages/profile/profile_page.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:flutter_boilerplate/domain/entities/genre.dart' as app_genre;
import 'package:flutter_boilerplate/domain/usecases/get_highlighted_genres_usecase.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    Center(child: Text('Collections')),
    Center(child: Text('Explore')),
    BlocProvider(
      create: (context) => GetIt.I<ProfileViewModel>()..loadUserProfile(),
      child: const ProfilePage(),
    ),
  ];

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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Anime> _seasonNowAnimes = [];
  List<Anime> _seasonUpcomingAnimes = [];
  List<Anime> _topAnimes = [];
  List<app_genre.Genre> _genres = [];
  bool _isSeasonNowAnimesLoading = true;
  bool _isSeasonUpcomingAnimesLoading = true;
  bool _isGenresLoading = true;
  bool _isTopAnimesLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSeasonNowAnimes();
    _fetchSeasonUpcomingAnimes();
    _fetchTopAnimes();
    _fetchGenres();
  }

  Future<void> _fetchSeasonNowAnimes() async {
    try {
      final getSeasonNowAnimesUseCase = GetIt.I<GetSeasonNowAnimesUseCase>();
      final animes = await getSeasonNowAnimesUseCase();
      if (!mounted) return;
      setState(() {
        _seasonNowAnimes = animes;
        _isSeasonNowAnimesLoading = false;
      });
    } catch (e) {
      // Handle error
      if (!mounted) return;
      setState(() {
        _isSeasonNowAnimesLoading = false;
      });
    }
  }

  Future<void> _fetchTopAnimes() async {
    try {
      final getTopAnimesUseCase = GetIt.I<GetTopAnimesUseCase>();
      final animes = await getTopAnimesUseCase();
      if (!mounted) return;
      setState(() {
        _topAnimes = animes;
        _isTopAnimesLoading = false;
      });
    } catch (e) {
      // Handle error
      if (!mounted) return;
      setState(() {
        _isTopAnimesLoading = false;
      });
    }
  }

  Future<void> _fetchSeasonUpcomingAnimes() async {
    try {
      final getSeasonUpcomingAnimesUseCase =
          GetIt.I<GetSeasonUpcomingAnimesUseCase>();
      final animes = await getSeasonUpcomingAnimesUseCase();
      if (!mounted) return;
      setState(() {
        _seasonUpcomingAnimes = animes;
        _isSeasonUpcomingAnimesLoading = false;
      });
    } catch (e) {
      // Handle error
      if (!mounted) return;
      setState(() {
        _isSeasonUpcomingAnimesLoading = false;
      });
    }
  }

  Future<void> _fetchGenres() async {
    try {
      final getHighlightedGenresUseCase =
          GetIt.I<GetHighlightedGenresUseCase>();
      final genres = await getHighlightedGenresUseCase();
      if (!mounted) return;
      setState(() {
        _genres = genres;
        _isGenresLoading = false;
      });
    } catch (e) {
      // Handle error
      if (!mounted) return;
      setState(() {
        _isGenresLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          HeroBanner(
            movies: _isSeasonNowAnimesLoading ? null : _seasonNowAnimes,
          ),

          // Categories/Genres
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
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
          _isGenresLoading
              ? const Center(child: CircularProgressIndicator())
              : CategorySlider(genres: _genres),

          // Top Anime Row
          MovieRow(
            title: 'All-Time Top Anime',
            movies: _isTopAnimesLoading ? null : _topAnimes,
          ),

          SizedBox(height: 16),

          // Upcoming Season Row
          MovieRow(
            title: 'Upcoming Season Anime',
            movies:
                _isSeasonUpcomingAnimesLoading ? null : _seasonUpcomingAnimes,
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}
