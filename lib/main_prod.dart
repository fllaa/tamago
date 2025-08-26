import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'di/injection_container.dart' as di;
import 'app/app.dart';
import 'core/config/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env.prod');

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize flavor configuration
  FlavorConfig(
    flavor: Flavor.prod,
    name: 'PROD',
  );

  // Initialize dependencies
  await di.init();

  runApp(const App());
}
