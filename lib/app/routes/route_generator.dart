import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/app/routes/app_routes.dart';
import 'package:tamago/domain/repositories/auth_repository.dart';
import 'package:tamago/presentation/pages/auth/login/login_page.dart';
import 'package:tamago/presentation/pages/home/home_page.dart';
import 'package:tamago/presentation/pages/product/product_detail_page.dart';
import 'package:tamago/presentation/pages/product/product_list_page.dart';
import 'package:tamago/presentation/pages/profile/profile_page.dart';
import 'package:tamago/presentation/pages/anime/anime_detail_page.dart';
import 'package:tamago/presentation/pages/anime/anime_episode_page.dart';
import 'package:tamago/presentation/viewmodels/auth/sign_in_with_google_viewmodel.dart';
import 'package:tamago/presentation/viewmodels/profile/profile_viewmodel.dart';
import 'package:get_it/get_it.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashPage());
      case AppRoutes.login:
        return _buildLoginRoute(
          BlocProvider(
            create: (context) => GetIt.I<SignInWithGoogleViewModel>(),
            child: const LoginPage(),
          ),
        );
      case AppRoutes.home:
        return _buildRoute(const HomePage());
      case AppRoutes.profile:
        return _buildRoute(
          BlocProvider(
            create: (context) => GetIt.I<ProfileViewModel>()..loadUserProfile(),
            child: const ProfilePage(),
          ),
        );
      case AppRoutes.productList:
        return _buildRoute(const ProductListPage());
      case AppRoutes.productDetail:
        return _buildRoute(ProductDetailPage(productId: args as String));
      case AppRoutes.animeDetail:
        final animeArgs = args as Map<String, dynamic>;
        return _buildRoute(AnimeDetailPage(
          malId: animeArgs['malId'],
          imageUrl: animeArgs['imageUrl'],
        ));
      case AppRoutes.animeEpisode:
        final episodeArgs = args as Map<String, dynamic>;
        return _buildRoute(AnimeEpisodePage(
          animeId: episodeArgs['animeId'],
          episodeNumber: episodeArgs['episodeNumber'],
          animeTitle: episodeArgs['animeTitle'],
        ));
      default:
        return _errorRoute();
    }
  }

  static PageRouteBuilder _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _buildLoginRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Check if user is logged in
      final authRepository = GetIt.I<AuthRepository>();
      final isLoggedIn = await authRepository.isLoggedIn();

      // Navigate to home if logged in, otherwise navigate to login
      Navigator.pushReplacementNamed(
          context, isLoggedIn ? AppRoutes.home : AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage('assets/icons/logo.png'),
                  height: 100,
                )),
            const SizedBox(height: 24),
            Text(
              'Tamago',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
