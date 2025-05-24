import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/presentation/pages/auth/forgot_password/forgot_password_page.dart';
import 'package:flutter_boilerplate/presentation/pages/auth/login/login_page.dart';
import 'package:flutter_boilerplate/presentation/pages/auth/register/register_page.dart';
import 'package:flutter_boilerplate/presentation/pages/home/home_page.dart';
import 'package:flutter_boilerplate/presentation/pages/product/product_detail_page.dart';
import 'package:flutter_boilerplate/presentation/pages/product/product_list_page.dart';
import 'package:flutter_boilerplate/presentation/pages/profile/profile_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashPage());
      case AppRoutes.login:
        return _buildRoute(const LoginPage());
      case AppRoutes.register:
        return _buildRoute(const RegisterPage());
      case AppRoutes.forgotPassword:
        return _buildRoute(const ForgotPasswordPage());
      case AppRoutes.home:
        return _buildRoute(const HomePage());
      case AppRoutes.profile:
        return _buildRoute(const ProfilePage());
      case AppRoutes.productList:
        return _buildRoute(const ProductListPage());
      case AppRoutes.productDetail:
        return _buildRoute(ProductDetailPage(productId: args as String));
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
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
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
      Navigator.pushReplacementNamed(context, AppRoutes.login);
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
            Icon(
              Icons.apps,
              size: 80,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'Flutter Boilerplate',
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