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
    flavor: Flavor.prod,
    name: 'PROD',
    baseUrl: 'https://api.example.com/v1',
    assetBaseUrl: 'https://assets.example.com',
  );

  // Initialize dependencies
  await di.init();

  runApp(const App());
}
