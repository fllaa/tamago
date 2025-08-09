import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/app/routes/route_generator.dart';
import 'package:flutter_boilerplate/app/themes/app_theme.dart';
import 'package:flutter_boilerplate/core/services/theme_service.dart';
import 'package:flutter_boilerplate/di/injection_container.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/auth/login_viewmodel.dart';

class App extends StatefulWidget {
  const App({super.key});

  static _AppState of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>()!;
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeService _themeService;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _themeService = getIt<ThemeService>();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await _themeService.getThemeMode();
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _themeService.setThemeMode(themeMode);
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginViewModel>()),
        // Add other global BlocProviders here
      ],
      child: MaterialApp(
        title: 'Tamago',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
