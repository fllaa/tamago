import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tamago/app/routes/app_routes.dart';
import 'package:tamago/app/routes/route_generator.dart';
import 'package:tamago/app/themes/app_theme.dart';
import 'package:tamago/core/localization/app_localizations.dart';
import 'package:tamago/core/services/language_service.dart';
import 'package:tamago/core/services/theme_service.dart';
import 'package:tamago/di/injection_container.dart';
import 'package:tamago/presentation/viewmodels/auth/login_viewmodel.dart';

class App extends StatefulWidget {
  const App({super.key});

  static _AppState of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>()!;
  }

  static Future<void> updateLanguage(
      BuildContext context, String languageCode) async {
    final state = context.findAncestorStateOfType<_AppState>();
    if (state != null) {
      await state.updateLanguage(languageCode);
    }
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeService _themeService;
  late LanguageService _languageService;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _themeService = getIt<ThemeService>();
    _languageService = LanguageService();
    _loadThemeMode();
    _loadLanguage();
  }

  Future<void> _loadThemeMode() async {
    final themeMode = await _themeService.getThemeMode();
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }

  Future<void> _loadLanguage() async {
    final languageCode = await _languageService.getSavedLanguage();
    if (mounted) {
      setState(() {
        _locale = _languageService.getLocaleFromLanguageCode(languageCode);
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

  Future<void> updateLanguage(String languageCode) async {
    await _languageService.saveLanguage(languageCode);
    if (mounted) {
      setState(() {
        _locale = _languageService.getLocaleFromLanguageCode(languageCode);
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
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('id'), // Bahasa Indonesia
        ],
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
