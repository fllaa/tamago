import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/core/localization/app_localizations.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/category_slider.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/hero_banner.dart';
import 'package:flutter_boilerplate/presentation/pages/home/widgets/movie_row.dart';
import 'package:flutter_boilerplate/presentation/pages/profile/profile_page.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:flutter_boilerplate/core/services/anime_service.dart';
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
        backgroundColor: const Color(0xFF141414), // Netflix dark background
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
  List<Anime> _animeList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnimeData();
  }

  Future<void> _fetchAnimeData() async {
    try {
      final animeService = AnimeService.instance;
      final animeList = await animeService.getSeasonNow();
      setState(() {
        _animeList = animeList;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for movie genres
    final genres = [
      {'name': 'Action', 'icon': Icons.flash_on},
      {'name': 'Comedy', 'icon': Icons.emoji_emotions},
      {'name': 'Drama', 'icon': Icons.theater_comedy},
      {'name': 'Horror', 'icon': Icons.dark_mode},
      {'name': 'Romance', 'icon': Icons.favorite},
      {'name': 'Sci-Fi', 'icon': Icons.auto_fix_high},
    ];

    // Mock data for featured movies
    final featuredMovies = [
      {
        'id': '1',
        'title': 'Stranger Things',
        'image':
            'https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.8,
        'year': 2023,
      },
      {
        'id': '2',
        'title': 'The Crown',
        'image':
            'https://images.pexels.com/photos/437037/pexels-photo-437037.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.6,
        'year': 2022,
      },
      {
        'id': '3',
        'title': 'Money Heist',
        'image':
            'https://images.pexels.com/photos/1229861/pexels-photo-1229861.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.9,
        'year': 2021,
      },
      {
        'id': '4',
        'title': 'Breaking Bad',
        'image':
            'https://images.pexels.com/photos/47261/pexels-photo-47261.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.7,
        'year': 2020,
      },
    ];

    // Mock data for trending movies
    final trendingMovies = [
      {
        'id': '5',
        'title': 'The Witcher',
        'image':
            'https://images.pexels.com/photos/3992656/pexels-photo-3992656.png?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.5,
        'year': 2023,
      },
      {
        'id': '6',
        'title': 'Game of Thrones',
        'image':
            'https://images.pexels.com/photos/2589822/pexels-photo-2589822.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.8,
        'year': 2019,
      },
      {
        'id': '7',
        'title': 'The Mandalorian',
        'image':
            'https://images.pexels.com/photos/3348356/pexels-photo-3348356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.6,
        'year': 2022,
      },
      {
        'id': '8',
        'title': 'Black Mirror',
        'image':
            'https://images.pexels.com/photos/274506/pexels-photo-274506.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.4,
        'year': 2021,
      },
    ];

    // Mock data for new releases
    final newReleases = [
      {
        'id': '9',
        'title': 'House of the Dragon',
        'image':
            'https://images.pexels.com/photos/1303086/pexels-photo-1303086.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.7,
        'year': 2023,
      },
      {
        'id': '10',
        'title': 'The Lord of the Rings',
        'image':
            'https://images.pexels.com/photos/3965545/pexels-photo-3965545.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.9,
        'year': 2022,
      },
      {
        'id': '11',
        'title': 'The Matrix Resurrections',
        'image':
            'https://images.pexels.com/photos/1195145/pexels-photo-1195145.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.3,
        'year': 2021,
      },
      {
        'id': '12',
        'title': 'Eternals',
        'image':
            'https://images.pexels.com/photos/3811041/pexels-photo-3811041.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        'rating': 4.2,
        'year': 2021,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          HeroBanner(
            movies: _isLoading ? null : _animeList,
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
          CategorySlider(genres: genres),

          // Trending Movies Row
          MovieRow(
            title: 'Trending Now',
            movies: trendingMovies,
          ),

          // New Releases Row
          MovieRow(
            title: 'New Releases',
            movies: newReleases,
          ),

          // Featured Movies Row
          MovieRow(
            title: 'Featured',
            movies: featuredMovies,
          ),
        ],
      ),
    );
  }
}
