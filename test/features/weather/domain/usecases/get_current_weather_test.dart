import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_weather_app/core/errors/failures.dart';
import 'package:flutter_weather_app/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:flutter_weather_app/features/weather/domain/usecases/get_current_weather.dart';

@GenerateMocks([WeatherRepository])
import 'get_current_weather_test.mocks.dart';

void main() {
  late GetCurrentWeather usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeather(mockWeatherRepository);
  });

  const tLat = 44.34;
  const tLon = 10.99;
  const tParams = GetCurrentWeatherParams(latitude: tLat, longitude: tLon);

  final tWeather = Weather(
    latitude: tLat,
    longitude: tLon,
    cityName: 'Zocca',
    country: 'IT',
    mainCondition: 'Clouds',
    description: 'broken clouds',
    iconCode: '04d',
    temperature: 301.1,
    feelsLike: 301.37,
    tempMin: 301.1,
    tempMax: 301.1,
    pressure: 1008,
    humidity: 48,
    windSpeed: 1.24,
    windDirection: 113,
    windGust: 3.56,
    cloudCoverage: 51,
    visibility: 10000,
    dateTime: DateTime.fromMillisecondsSinceEpoch(1753012959 * 1000),
    sunrise: DateTime.fromMillisecondsSinceEpoch(1752983429 * 1000),
    sunset: DateTime.fromMillisecondsSinceEpoch(1753037636 * 1000),
  );

  group('GetCurrentWeather', () {
    test('should get weather data from the repository', () async {
      when(mockWeatherRepository.getCurrentWeather(
        latitude: anyNamed('latitude'),
        longitude: anyNamed('longitude'),
      )).thenAnswer((_) async => Right(tWeather));

      final result = await usecase(tParams);

      expect(result, Right(tWeather));
      verify(mockWeatherRepository.getCurrentWeather(
        latitude: tLat,
        longitude: tLon,
      ));
      verifyNoMoreInteractions(mockWeatherRepository);
    });

    test('should return failure when repository call fails', () async {
      const tFailure = ServerFailure(message: 'Server error');
      when(mockWeatherRepository.getCurrentWeather(
        latitude: anyNamed('latitude'),
        longitude: anyNamed('longitude'),
      )).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      verify(mockWeatherRepository.getCurrentWeather(
        latitude: tLat,
        longitude: tLon,
      ));
      verifyNoMoreInteractions(mockWeatherRepository);
    });

    test('should pass correct parameters to repository', () async {
      when(mockWeatherRepository.getCurrentWeather(
        latitude: anyNamed('latitude'),
        longitude: anyNamed('longitude'),
      )).thenAnswer((_) async => Right(tWeather));

      await usecase(tParams);

      verify(mockWeatherRepository.getCurrentWeather(
        latitude: tLat,
        longitude: tLon,
      ));
    });
  });

  group('GetCurrentWeatherParams', () {
    test('should be a subclass of Equatable', () {
      expect(tParams, isA<GetCurrentWeatherParams>());
    });

    test('should return correct props', () {
      expect(tParams.props, [tLat, tLon]);
    });

    test('should be equal when properties are the same', () {
      const params1 = GetCurrentWeatherParams(latitude: tLat, longitude: tLon);
      const params2 = GetCurrentWeatherParams(latitude: tLat, longitude: tLon);
      expect(params1, equals(params2));
    });

    test('should not be equal when properties are different', () {
      const params1 = GetCurrentWeatherParams(latitude: tLat, longitude: tLon);
      const params2 = GetCurrentWeatherParams(latitude: 45.0, longitude: tLon);
      expect(params1, isNot(equals(params2)));
    });
  });
}