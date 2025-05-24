enum Flavor {
  dev,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;
  final String assetBaseUrl;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String baseUrl,
    required String assetBaseUrl,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor: flavor,
      name: name,
      baseUrl: baseUrl,
      assetBaseUrl: assetBaseUrl,
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.baseUrl,
    required this.assetBaseUrl,
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
