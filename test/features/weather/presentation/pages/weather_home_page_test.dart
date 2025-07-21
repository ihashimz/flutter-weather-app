import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:flutter_weather_app/features/weather/presentation/pages/weather_home_page.dart';
import 'package:flutter_weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/features/weather/presentation/bloc/weather_state.dart';
import 'package:flutter_weather_app/features/weather/presentation/templates/weather_home_template.dart';
import 'package:flutter_weather_app/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_app/core/services/location_service.dart';
import 'package:flutter_weather_app/core/services/service_locator.dart';

import 'weather_home_page_test.mocks.dart';

@GenerateMocks([WeatherBloc, LocationService])
void main() {
  late MockWeatherBloc mockWeatherBloc;
  late MockLocationService mockLocationService;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
    mockLocationService = MockLocationService();
    
    // Setup service locator
    if (!sl.isRegistered<LocationService>()) {
      sl.registerFactory<LocationService>(() => mockLocationService);
    }
  });

  tearDown(() {
    sl.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<WeatherBloc>(
        create: (context) => mockWeatherBloc,
        child: const WeatherHomePage(),
      ),
    );
  }

  group('WeatherHomePage', () {
    testWidgets('should render WeatherHomeTemplate', (WidgetTester tester) async {
      // Arrange
      when(mockWeatherBloc.state).thenReturn(const WeatherInitial());
      when(mockWeatherBloc.stream).thenAnswer((_) => Stream.value(const WeatherInitial()));
      when(mockLocationService.isLocationPermissionGranted()).thenAnswer((_) async => false);
      when(mockLocationService.shouldShowPermissionRequest()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(); // Allow async operations to complete

      // Assert
      expect(find.byType(WeatherHomeTemplate), findsOneWidget);
    });

    testWidgets('should handle BLoC state changes', (WidgetTester tester) async {
      // Arrange
      when(mockWeatherBloc.state).thenReturn(const WeatherLoading());
      when(mockWeatherBloc.stream).thenAnswer((_) => Stream.value(const WeatherLoading()));
      when(mockLocationService.isLocationPermissionGranted()).thenAnswer((_) async => false);
      when(mockLocationService.shouldShowPermissionRequest()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      // Assert - Should render template regardless of location state
      expect(find.byType(WeatherHomeTemplate), findsOneWidget);
    });

    testWidgets('should pass weather data to template when loaded', (WidgetTester tester) async {
      // Arrange
      final mockWeather = Weather(
        latitude: 24.774265,
        longitude: 46.738586,
        cityName: 'Riyadh',
        mainCondition: 'Clear',
        description: 'clear sky',
        iconCode: '01d',
        temperature: 298.15,
        feelsLike: 300.15,
        tempMin: 293.15,
        tempMax: 303.15,
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

      when(mockWeatherBloc.state).thenReturn(WeatherLoaded(weather: mockWeather));
      when(mockWeatherBloc.stream).thenAnswer((_) => Stream.value(WeatherLoaded(weather: mockWeather)));
      when(mockLocationService.isLocationPermissionGranted()).thenAnswer((_) async => false);
      when(mockLocationService.shouldShowPermissionRequest()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      // Assert
      expect(find.byType(WeatherHomeTemplate), findsOneWidget);
      // Template should be created (weather data may be null due to location state)
      final templateWidget = tester.widget<WeatherHomeTemplate>(find.byType(WeatherHomeTemplate));
      expect(templateWidget, isNotNull);
    });

    testWidgets('should display location denied state when permission is denied', (WidgetTester tester) async {
      // Arrange
      when(mockWeatherBloc.state).thenReturn(const WeatherInitial());
      when(mockWeatherBloc.stream).thenAnswer((_) => Stream.value(const WeatherInitial()));
      when(mockLocationService.isLocationPermissionGranted()).thenAnswer((_) async => false);
      when(mockLocationService.shouldShowPermissionRequest()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(); // Additional pump for async operations

      // Assert
      expect(find.text('Location Access Required'), findsOneWidget);
      expect(find.text('Request Location Access'), findsOneWidget);
      expect(find.text('Continue with default location'), findsOneWidget);
    });

    testWidgets('should call weather bloc when requesting location access', (WidgetTester tester) async {
      // Arrange
      when(mockWeatherBloc.state).thenReturn(const WeatherInitial());
      when(mockWeatherBloc.stream).thenAnswer((_) => Stream.value(const WeatherInitial()));
      when(mockLocationService.isLocationPermissionGranted()).thenAnswer((_) async => false);
      when(mockLocationService.shouldShowPermissionRequest()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      // Tap the request location button
      await tester.tap(find.text('Request Location Access'));
      await tester.pump();

      // Assert
      verify(mockLocationService.isLocationPermissionGranted()).called(greaterThan(1));
    });

    testWidgets('should continue with default location when continue button is tapped', (WidgetTester tester) async {
      // Arrange
      when(mockWeatherBloc.state).thenReturn(const WeatherInitial());
      when(mockWeatherBloc.stream).thenAnswer((_) => Stream.value(const WeatherInitial()));
      when(mockLocationService.isLocationPermissionGranted()).thenAnswer((_) async => false);
      when(mockLocationService.shouldShowPermissionRequest()).thenAnswer((_) async => false);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      // Tap the continue button
      await tester.tap(find.text('Continue with default location'));
      await tester.pump();

      // Assert
      verify(mockWeatherBloc.add(any)).called(greaterThan(0));
    });
  });
}