import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'di/injection_container.dart' as di;
import 'app/app.dart';
import 'core/config/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize flavor configuration
  FlavorConfig(
    flavor: Flavor.dev,
    name: 'DEV',
    baseUrl: 'https://dev-mock-api.flla.my.id/v1',
    assetBaseUrl: 'https://dev-assets.example.com',
    supabaseUrl: 'https://qvpmjunybznphyhyrkvl.supabase.co',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF2cG1qdW55YnpucGh5aHlya3ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4MTUyMjUsImV4cCI6MjA2NTM5MTIyNX0.8Gpih6X-C6xNGADGI3p0C2onRnC8NyPPJKBax3IJ608',
  );

  // Initialize dependencies
  await di.init();

  runApp(const App());
}
