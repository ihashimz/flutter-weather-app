import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_weather_app/features/weather/presentation/widgets/organisms/weather_loading_state.dart';
import 'package:flutter_weather_app/features/weather/presentation/widgets/organisms/weather_error_state.dart';
import 'package:flutter_weather_app/features/weather/presentation/widgets/organisms/weather_header_section.dart';
import 'package:flutter_weather_app/features/weather/presentation/widgets/organisms/weather_details_section.dart';
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

  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('WeatherLoadingState', () {
    testWidgets('should display loading content', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const WeatherLoadingState(),
      ));

      expect(find.byIcon(Icons.wb_cloudy), findsOneWidget);
      expect(find.text('Loading Weather...'), findsOneWidget);
      expect(find.text('Getting current conditions'), findsOneWidget);
    });
  });

  group('WeatherErrorState', () {
    testWidgets('should display error message with retry', (WidgetTester tester) async {
      const errorMessage = 'Failed to load weather data';

      await tester.pumpWidget(createWidgetUnderTest(
        WeatherErrorState(
          message: errorMessage,
          onRetry: () {},
        ),
      ));

      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is tapped', (WidgetTester tester) async {
      bool retryCalled = false;
      void onRetry() => retryCalled = true;

      await tester.pumpWidget(createWidgetUnderTest(
        WeatherErrorState(
          message: 'Error occurred',
          onRetry: onRetry,
        ),
      ));

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('should handle null onRetry callback', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const WeatherErrorState(
          message: 'Error without retry',
          onRetry: null,
        ),
      ));

      expect(find.text('Error without retry'), findsOneWidget);
      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      // Button should NOT be present when onRetry is null
      expect(find.text('Try Again'), findsNothing);
    });
  });

  group('WeatherHeaderSection', () {
    testWidgets('should display weather data', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        WeatherHeaderSection(
          weather: mockWeather,
          onRefresh: () {},
        ),
      ));

      expect(find.text('Riyadh'), findsOneWidget);
      expect(find.byType(TemperatureText), findsOneWidget);
      expect(find.text('clear sky'), findsOneWidget);
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget); // Clear sky icon
    });

    testWidgets('should display feels like temperature', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        WeatherHeaderSection(
          weather: mockWeather,
          onRefresh: () {},
        ),
      ));

      // Feels like temp shows (300.15K - 273.15 = 27°C)
      expect(find.textContaining('Feels like 27'), findsOneWidget);
    });

    testWidgets('should display country information', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        WeatherHeaderSection(
          weather: mockWeather,
          onRefresh: () {},
        ),
      ));

      expect(find.textContaining('SA'), findsOneWidget);
    });
  });

  group('WeatherDetailsSection', () {
    testWidgets('should display weather metrics', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        WeatherDetailsSection(
          weather: mockWeather,
        ),
      ));

      expect(find.text('65%'), findsOneWidget); // Humidity
      expect(find.text('3.5 m/s'), findsOneWidget); // Wind speed
      expect(find.text('1013 hPa'), findsOneWidget); // Pressure
    });

    testWidgets('should display details title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        WeatherDetailsSection(
          weather: mockWeather,
        ),
      ));

      expect(find.text('Weather Details'), findsOneWidget);
    });
  });
}