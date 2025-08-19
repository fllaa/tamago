# Tamago

This project is an anime streaming & manga reader platform.

## Features

-   **Authentication:** Sign in with Google.
-   **Anime:** Browse anime, view details, and see highlighted genres.
-   **User Profile:** View your profile information.
-   **Product Listing:** (WIP)
-   **Clean Architecture:** A well-structured and scalable codebase.
-   **State Management:** Using Flutter Bloc for predictable state management.
-   **Dependency Injection:** Using GetIt and Injectable for managing dependencies.
-   **Localization:** Support for multiple languages.
-   **Theming:** Light and dark mode support.
-   **Flavors:** Separate configurations for development and production environments.

## Project Structure

```
.
├── android
├── assets
│   ├── icons
│   └── lang
├── ios
├── lib
│   ├── app
│   │   ├── routes
│   │   └── themes
│   ├── core
│   │   ├── config
│   │   ├── constants
│   │   ├── errors
│   │   ├── localization
│   │   ├── network
│   │   ├── services
│   │   └── utils
│   ├── data
│   │   ├── models
│   │   └── repositories
│   ├── di
│   ├── domain
│   │   ├── entities
│   │   ├── repositories
│   │   └── usecases
│   └── presentation
│       ├── pages
│       ├── viewmodels
│       └── widgets
├── macos
├── web
└── windows
```

## Getting Started

### Prerequisites

-   Flutter SDK: Make sure you have the Flutter SDK installed. You can find the installation instructions [here](https://flutter.dev/docs/get-started/install).

### Installation

1.  Clone the repository:

    ```bash
    git clone https://github.com/your-username/flutter-boilerplate.git
    ```

2.  Install the dependencies:

    ```bash
    flutter pub get
    ```

### Running the App

This project uses Flutter flavors to manage different environments.

#### Command Line

-   **Development:**

    ```bash
    flutter run --flavor dev -t lib/main_dev.dart
    ```

-   **Production:**

    ```bash
    flutter run --flavor prod -t lib/main_prod.dart
    ```

#### VS Code

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

## Flavors

This project uses Flutter flavors to manage different environments (development and production).

| Flavor | Package Name             | API URL                            |
| ------ | ------------------------ | ---------------------------------- |
| dev    | `dev.com.tachyons.tamago`  | `https://dev-mock-api.flla.my.id/v1` |
| prod   | `com.tachyons.tamago`    | `https://mock-api.flla.my.id/v1`     |

## Dependencies

This project uses the following main dependencies:

-   **State Management:** `flutter_bloc`, `equatable`
-   **Dependency Injection:** `get_it`, `injectable`
-   **Network:** `dio`, `connectivity_plus`
-   **Storage:** `shared_preferences`, `sqflite`
-   **UI:** `google_fonts`, `flutter_svg`, `cached_network_image`, `shimmer`, `lottie`
-   **Utils:** `intl`, `logger`, `url_launcher`, `dartz`
-   **Authentication:** `google_sign_in`
-   **Backend:** `supabase`
-   **API:** `jikan_api_v4`

## API

This project uses the [Jikan API](https://jikan.moe/) for fetching anime data and a mock API for other data.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
