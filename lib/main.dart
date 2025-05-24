import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'di/injection_container.dart' as di;
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize dependencies
  await di.init();
  
  runApp(const App());
}