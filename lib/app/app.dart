import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/app/routes/route_generator.dart';
import 'package:flutter_boilerplate/app/themes/app_theme.dart';
import 'package:flutter_boilerplate/di/injection_container.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/auth/login_viewmodel.dart';

class App extends StatelessWidget {
  const App({super.key});

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
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
