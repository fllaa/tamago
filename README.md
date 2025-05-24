# Flutter Boilerplate

A comprehensive Flutter boilerplate project with clean architecture, designed to kickstart your Flutter application development with best practices and a well-structured codebase.

## Features

- **Clean Architecture**: Organized in layers (presentation, domain, data) for better separation of concerns
- **Multiple Environments**: Development and Production environments with different configurations
- **Dependency Injection**: Using get_it and injectable for efficient dependency management
- **State Management**: Implements BLoC pattern using flutter_bloc
- **Network Layer**: Configured with Dio for API requests with interceptors
- **Local Storage**: Integrated with SharedPreferences and SQLite
- **UI Components**: Reusable widgets and responsive design
- **Error Handling**: Comprehensive error handling strategy
- **Routing**: Organized navigation system

## Project Structure

```
lib/
├── app/                  # Application setup
│   ├── routes/           # Navigation routes
│   └── themes/           # App themes
├── core/                 # Core functionality
│   ├── config/           # App configuration
│   ├── constants/        # App constants
│   ├── errors/           # Error handling
│   ├── network/          # Network related code
│   ├── services/         # Core services
│   └── utils/            # Utility functions
├── data/                 # Data layer
│   ├── models/           # Data models
│   └── repositories/     # Repository implementations
├── di/                   # Dependency injection
├── domain/               # Domain layer
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic
└── presentation/         # UI layer
    ├── pages/            # App screens
    ├── viewmodels/       # BLoC/ViewModels
    └── widgets/          # Reusable widgets
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/fllaa/flutter-boilerplate.git
   ```

2. Navigate to the project directory:
   ```bash
   cd flutter-boilerplate
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the code generation for injectable and JSON serialization:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Running the App

#### Development Environment

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

#### Production Environment

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

## Environment Configuration

The app uses different environment configurations:

- **Development**: Points to development APIs and services
- **Production**: Points to production APIs and services

Environment-specific variables are configured in `lib/core/config/flavor_config.dart` and initialized in the respective main files.

## Architecture

This project follows Clean Architecture principles with three main layers:

1. **Presentation Layer**: UI components, BLoC/ViewModels
2. **Domain Layer**: Business logic, use cases, and repository interfaces
3. **Data Layer**: Data sources, repository implementations, and models

### Dependency Flow

```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain has no external dependencies

## State Management

The project uses the BLoC pattern with flutter_bloc for state management:

- **ViewModels**: Manage UI state and business logic
- **States**: Represent different UI states
- **Events**: Trigger state changes

## Dependency Injection

Dependency injection is implemented using get_it and injectable:

- **Service Locator**: Centralized in `lib/di/injection_container.dart`
- **Factory**: For objects that should be recreated on each access
- **Singleton**: For objects that should be created only once

## Network Layer

The network layer is built with Dio and includes:

- **API Client**: Centralized client for all API requests
- **Interceptors**: For logging, authentication, and error handling
- **Network Info**: To check network connectivity

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All the package authors that made this boilerplate possible
