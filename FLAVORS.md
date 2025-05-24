# Flutter Flavors

This project uses Flutter flavors to manage different environments (development and production).

## Available Flavors

1. **dev** - Development environment
   - Package name: `dev.com.tachyons.fllautther`
   - API URL: `https://dev-api.example.com/v1`
   - Assets URL: `https://dev-assets.example.com`

2. **prod** - Production environment
   - Package name: `com.tachyons.fllautther`
   - API URL: `https://api.example.com/v1`
   - Assets URL: `https://assets.example.com`

## Running the App with Flavors

### Command Line

To run the app with a specific flavor:

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

### VS Code

Add the following configurations to your `.vscode/launch.json` file:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (dev)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "debug",
      "args": [
        "--flavor",
        "dev",
        "-t",
        "lib/main_dev.dart"
      ]
    },
    {
      "name": "Flutter (prod)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "debug",
      "args": [
        "--flavor",
        "prod",
        "-t",
        "lib/main_prod.dart"
      ]
    }
  ]
}
```

### Android Studio / IntelliJ IDEA

1. Go to `Run > Edit Configurations`
2. Create a new Flutter configuration for each flavor:
   - Name: `dev`
   - Dart entrypoint: `lib/main_dev.dart`
   - Additional run args: `--flavor dev`

   - Name: `prod`
   - Dart entrypoint: `lib/main_prod.dart`
   - Additional run args: `--flavor prod`

## Building the App with Flavors

### Android

```bash
# Development APK
flutter build apk --flavor dev -t lib/main_dev.dart

# Production APK
flutter build apk --flavor prod -t lib/main_prod.dart

# Development App Bundle
flutter build appbundle --flavor dev -t lib/main_dev.dart

# Production App Bundle
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

### iOS

```bash
# Development
flutter build ios --flavor dev -t lib/main_dev.dart

# Production
flutter build ios --flavor prod -t lib/main_prod.dart
```

Note: For iOS, you'll need to set up the appropriate schemes in Xcode.