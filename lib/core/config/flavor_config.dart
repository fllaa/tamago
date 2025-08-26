import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor {
  dev,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;
  final String assetBaseUrl;
  final String supabaseUrl;
  final String supabasePublishableKey;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor: flavor,
      name: name,
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      assetBaseUrl: dotenv.env['ASSET_BASE_URL'] ?? '',
      supabaseUrl: dotenv.env['SUPABASE_URL'] ?? '',
      supabasePublishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '',
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.baseUrl,
    required this.assetBaseUrl,
    required this.supabaseUrl,
    required this.supabasePublishableKey,
  });

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig has not been initialized');
    }
    return _instance!;
  }

  static bool isDevelopment() => _instance?.flavor == Flavor.dev;
  static bool isProduction() => _instance?.flavor == Flavor.prod;
}
