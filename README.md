# Flutter Crypto Wallet 

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)

A modern cryptocurrency monitoring application developed in Flutter, integrating real-time data from the CoinGecko API with a focus on performance and user experience.

---

## 📸 Screenshots

> **Note**: Add screenshots here to showcase your app's interface
> - Light Mode / Dark Mode comparison
> - Home screen with coin list
> - Interactive charts
> - Favorites management
> - Search functionality

---

## ✨ Key Features

- **Real-Time Data**: Complete integration with the **CoinGecko** API to list the Top 150 Market Cap.
- **Interactive Charts**: Visualization of historical data and price variations using the **fl_chart** library.
- **Smart Search**: Coin search with **Debouncing** support (prevents excessive API requests).
- **Favorites System**: Local management of favorite coins with persistent storage.
- **Auto-Refresh**: Countdown timer for periodic market data updates.

---

## 🎨 Design and UI/UX

- **Theme Support**: Fully supports **Light Mode** and **Dark Mode**, respecting system settings.
- **Material 3**: Modern interface using Google's latest design standards.
- **Visual Feedback**: Strategic use of SnackBars for navigation errors and BottomSheets for action confirmations (e.g., removing a favorite).
- **Responsive Design**: Optimized for different screen sizes and orientations.

---

## 🏗️ Architecture and Performance

The project was built following solid software architecture principles:

- **MVVM (Model-View-ViewModel)**: Clear separation between business logic and user interface.
- **Command Pattern**: Standardized management of loading, error, and success states.
- **Dependency Injection**: Use of `get_it` for more testable and decoupled code.
- **Performance Optimization**:
  - Granular widget rebuilding to avoid unnecessary re-renders.
  - In-memory caching of API data for instant navigation.
  - Efficient state management with Provider.

---

## 🛠️ Tech Stack

### Core Dependencies
- **[Flutter](https://flutter.dev/)** `^3.9.2` - UI framework
- **[Dart](https://dart.dev/)** `^3.9.2` - Programming language

### State Management & Navigation
- **[Provider](https://pub.dev/packages/provider)** `^6.1.5` - State management
- **[GoRouter](https://pub.dev/packages/go_router)** `^17.0.1` - Declarative routing

### Networking & Data
- **[Dio](https://pub.dev/packages/dio)** `^5.7.0` - HTTP client
- **[flutter_dotenv](https://pub.dev/packages/flutter_dotenv)** `^5.2.1` - Environment variables

### Local Storage
- **[Hive](https://pub.dev/packages/hive)** `^2.2.3` - NoSQL database
- **[hive_flutter](https://pub.dev/packages/hive_flutter)** `^1.1.0` - Hive Flutter integration

### UI & Visualization
- **[fl_chart](https://pub.dev/packages/fl_chart)** `^1.1.1` - Beautiful charts
- **[intl](https://pub.dev/packages/intl)** `^0.20.2` - Internationalization

### Utilities
- **[get_it](https://pub.dev/packages/get_it)** `^9.2.0` - Service locator (DI)
- **[equatable](https://pub.dev/packages/equatable)** `^2.0.7` - Value equality
- **[url_launcher](https://pub.dev/packages/url_launcher)** `^6.3.2` - Launch URLs
- **[html](https://pub.dev/packages/html)** `^0.15.6` - HTML parsing

### Testing
- **[mocktail](https://pub.dev/packages/mocktail)** `^1.0.4` - Mocking library
- **[flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)** - Testing framework

---

## 📁 Project Structure

```
lib/
├── core/                          # Core utilities and shared code
│   ├── di/                        # Dependency injection setup
│   ├── models/                    # Domain models
│   ├── providers/                 # Global providers
│   ├── repositories/              # Data repositories
│   ├── theme/                     # App theming
│   ├── utils/                     # Utility functions
│   └── widgets/                   # Reusable widgets
│
├── features/                      # Feature modules
│   ├── home/                      # Home screen (coin list)
│   ├── details/                   # Coin details screen
│   ├── favorites/                 # Favorites management
│   └── splash/                    # Splash screen
│
└── main.dart                      # App entry point
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.9.2`
- Dart SDK `>=3.9.2`
- Android Studio / VS Code
- A CoinGecko API key (optional for basic usage)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_crypto_wallet.git
   cd flutter_crypto_wallet
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the project root:
   ```env
   # CoinGecko API Configuration
   COINGECKO_API_KEY=your_api_key_here
   COINGECKO_BASE_URL=https://api.coingecko.com/api/v3
   ```
   
   > **Note**: The app works without an API key for basic usage, but you may hit rate limits. Get a free API key at [CoinGecko](https://www.coingecko.com/en/api).

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🧪 Tests

The project includes a comprehensive suite of unit tests covering the main logically isolated layers:

- **Models**: JSON parsing validation (CoinMarket, CoinDetail).
- **Providers**: State logic tests (FavoritesProvider).
- **ViewModels**: Command and data flow tests (Home, Details, Favorites).

### Running Tests

```bash
# Run all tests
flutter test
```

## 📚 Useful Links

- [CoinGecko API Documentation](https://www.coingecko.com/en/api/documentation)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Material Design 3](https://m3.material.io/)
- [Provider Package](https://pub.dev/packages/provider)
- [fl_chart Documentation](https://pub.dev/packages/fl_chart)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Walison Silva**
- GitHub: [@wal-mdev](https://github.com/wal-mdev)
- LinkedIn: [walisondsi](https://linkedin.com/in/walisondsi)

---

## 🙏 Acknowledgments

- [CoinGecko](https://www.coingecko.com/) for providing the cryptocurrency data API
- Flutter community for amazing packages and support

---

<div align="center">
  Made with ❤️ using Flutter
</div>
