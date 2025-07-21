# Flutter Weather App

A simple weather app built with Flutter using OpenWeatherMap API, BLoC pattern, and device location.

## Features
- Real-time weather data
- Device location support
- Clean UI with weather-based gradients
- Location permission handling

## Setup

1. Clone and install dependencies:
```bash
git clone <repo-url>
cd flutter_weather_app
flutter pub get
```

2. Add your OpenWeatherMap API key to `.env` file:
```bash
OPENWEATHER_API_KEY=your_actual_api_key_here
```

3. Run the app:
```bash
flutter run
```

## Build Commands

```bash
# Development
flutter run

# Generate code (if needed)
flutter packages pub run build_runner build

# Build APK
flutter build apk --debug
flutter build apk --release

# Tests
flutter test

# Code analysis
flutter analyze
```

## Architecture
- Clean Architecture with BLoC pattern
- Domain/Data/Presentation layers
- Location services with permission handling
- Comprehensive test coverage

Default location: Riyadh, Saudi Arabia (24.774265, 46.738586)

## Requirements
- Flutter 3.24.0+
- Android SDK 21+ / iOS 12.0+
- OpenWeatherMap API key (free)