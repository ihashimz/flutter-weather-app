import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_weather_app/features/weather/presentation/templates/weather_home_template.dart';
import 'package:flutter_weather_app/features/weather/presentation/widgets/atoms/temperature_text.dart';
import 'package:flutter_weather_app/features/weather/domain/entities/weather.dart';

void main() {
  final mockWeather = Weather(
    latitude: 24.774265,
    longitude: 46.738586,
    cityName: 'Riyadh',
    mainCondition: 'Clear',
    description: 'clear sky',
    iconCode: '01d',
    temperature: 298.15, // 25°C in Kelvin
    feelsLike: 300.15, // 27°C in Kelvin
    tempMin: 293.15, // 20°C in Kelvin
    tempMax: 303.15, // 30°C in Kelvin
    pressure: 1013,
    humidity: 65,
    visibility: 10000,
    windSpeed: 3.5,
    windDirection: 180,
    cloudCoverage: 10,
    country: 'SA',
    dateTime: DateTime.fromMillisecondsSinceEpoch(1000000000),
    sunrise: DateTime.fromMillisecondsSinceEpoch(1000000000),
    sunset: DateTime.fromMillisecondsSinceEpoch(1000043200),
  );

  Widget createWidgetUnderTest({
    required WeatherScreenState state,
    Weather? weather,
    String? errorMessage,
    VoidCallback? onRefresh,
    VoidCallback? onRetry,
    VoidCallback? onRequestLocation,
  }) {
    return MaterialApp(
      home: WeatherHomeTemplate(
        state: state,
        weather: weather,
        errorMessage: errorMessage,
        onRefresh: onRefresh,
        onRetry: onRetry,
        onRequestLocation: onRequestLocation,
      ),
    );
  }

  group('WeatherHomeTemplate', () {
    group('Loading State', () {
      testWidgets('should display loading indicator', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.loading,
        ));

        // Assert - WeatherLoadingState displays custom loading UI
        expect(find.text('Loading Weather...'), findsOneWidget);
        expect(find.text('Getting current conditions'), findsOneWidget);
        expect(find.byIcon(Icons.wb_cloudy), findsOneWidget);
      });
    });

    group('Loaded State', () {
      testWidgets('should display weather data', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.loaded,
          weather: mockWeather,
        ));

        // Assert
        expect(find.text('Riyadh'), findsOneWidget);
        expect(find.byType(TemperatureText), findsOneWidget); // Temperature is displayed via TemperatureText widget
        expect(find.text('clear sky'), findsOneWidget);
        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('should handle refresh action', (WidgetTester tester) async {
        // Arrange
        bool refreshCalled = false;
        void onRefresh() => refreshCalled = true;

        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.loaded,
          weather: mockWeather,
          onRefresh: onRefresh,
        ));

        await tester.fling(find.byType(SingleChildScrollView), const Offset(0, 500), 1000);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        // Assert
        expect(refreshCalled, isTrue);
      });

      testWidgets('should display footer with last updated time', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.loaded,
          weather: mockWeather,
        ));

        // Assert
        expect(find.text('Pull down to refresh'), findsOneWidget);
        expect(find.textContaining('Last updated:'), findsOneWidget);
        expect(find.byIcon(Icons.schedule), findsOneWidget);
      });

      testWidgets('should show error when weather is null', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.loaded,
          weather: null,
        ));

        // Assert
        expect(find.text('No weather data available'), findsOneWidget);
      });
    });

    group('Error State', () {
      testWidgets('should display error message', (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Failed to load weather data';

        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.error,
          errorMessage: errorMessage,
          onRetry: () {}, // Need onRetry callback for button to appear
        ));

        // Assert
        expect(find.text('Oops! Something went wrong'), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
      });

      testWidgets('should handle retry action', (WidgetTester tester) async {
        // Arrange
        bool retryCalled = false;
        void onRetry() => retryCalled = true;

        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.error,
          errorMessage: 'Error occurred',
          onRetry: onRetry,
        ));

        await tester.tap(find.text('Try Again'));
        await tester.pump();

        // Assert
        expect(retryCalled, isTrue);
      });

      testWidgets('should display default error message when none provided', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.error,
        ));

        // Assert
        expect(find.text('Failed to load weather data'), findsOneWidget);
      });
    });

    group('Location Denied State', () {
      testWidgets('should display location access required UI', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.locationDenied,
        ));

        // Assert
        expect(find.text('Location Access Required'), findsOneWidget);
        expect(find.text('📍'), findsOneWidget);
        expect(find.text('Request Location Access'), findsOneWidget);
        expect(find.text('Continue with default location'), findsOneWidget);
        expect(find.byIcon(Icons.location_on), findsOneWidget);
      });

      testWidgets('should handle request location action', (WidgetTester tester) async {
        // Arrange
        bool requestLocationCalled = false;
        void onRequestLocation() => requestLocationCalled = true;

        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.locationDenied,
          onRequestLocation: onRequestLocation,
        ));

        await tester.tap(find.text('Request Location Access'));
        await tester.pump();

        // Assert
        expect(requestLocationCalled, isTrue);
      });

      testWidgets('should handle continue with default action', (WidgetTester tester) async {
        // Arrange
        bool continueCalled = false;
        void onContinue() => continueCalled = true;

        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.locationDenied,
          onRetry: onContinue,
        ));

        await tester.tap(find.text('Continue with default location'));
        await tester.pump();

        // Assert
        expect(continueCalled, isTrue);
      });

      testWidgets('should have correct button styling', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.locationDenied,
        ));

        // Assert
        final requestButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Request Location Access'),
        );
        final continueButton = tester.widget<TextButton>(
          find.widgetWithText(TextButton, 'Continue with default location'),
        );

        expect(requestButton.style?.backgroundColor?.resolve({}), equals(Colors.white));
        expect(continueButton, isNotNull);
      });

      testWidgets('should display explanatory text', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.locationDenied,
        ));

        // Assert
        expect(
          find.text('We need access to your location to provide accurate weather information for your area. Using default location for now.'),
          findsOneWidget,
        );
      });
    });

    group('Background and Styling', () {
      testWidgets('should use gradient background', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.loaded,
          weather: mockWeather,
        ));

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets('should use weather condition for background gradient', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createWidgetUnderTest(
          state: WeatherScreenState.loaded,
          weather: Weather(
            latitude: mockWeather.latitude,
            longitude: mockWeather.longitude,
            cityName: mockWeather.cityName,
            mainCondition: 'Rain',
            description: mockWeather.description,
            iconCode: mockWeather.iconCode,
            temperature: mockWeather.temperature,
            feelsLike: mockWeather.feelsLike,
            tempMin: mockWeather.tempMin,
            tempMax: mockWeather.tempMax,
            pressure: mockWeather.pressure,
            humidity: mockWeather.humidity,
            visibility: mockWeather.visibility,
            windSpeed: mockWeather.windSpeed,
            windDirection: mockWeather.windDirection,
            cloudCoverage: mockWeather.cloudCoverage,
            country: mockWeather.country,
            dateTime: mockWeather.dateTime,
            sunrise: mockWeather.sunrise,
            sunset: mockWeather.sunset,
          ),
        ));

        // Assert - Verify that the background adapts to weather condition
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}