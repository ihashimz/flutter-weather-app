import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_weather_app/core/errors/failures.dart';
import 'package:flutter_weather_app/features/weather/domain/entities/weather.dart';
import 'package:flutter_weather_app/features/weather/domain/usecases/get_current_weather.dart';
import 'package:flutter_weather_app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter_weather_app/features/weather/presentation/bloc/weather_event.dart';
import 'package:flutter_weather_app/features/weather/presentation/bloc/weather_state.dart';

@GenerateMocks([GetCurrentWeather])
import 'weather_bloc_test.mocks.dart';

void main() {
  late WeatherBloc weatherBloc;
  late MockGetCurrentWeather mockGetCurrentWeather;

  setUp(() {
    mockGetCurrentWeather = MockGetCurrentWeather();
    weatherBloc = WeatherBloc(getCurrentWeather: mockGetCurrentWeather);
  });

  tearDown(() {
    weatherBloc.close();
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

  group('WeatherBloc', () {
    test('initial state should be WeatherInitial', () {
      expect(weatherBloc.state, equals(const WeatherInitial()));
    });

    group('GetCurrentWeatherEvent', () {
      blocTest<WeatherBloc, WeatherState>(
        'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => Right(tWeather));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const GetCurrentWeatherEvent(
          latitude: tLat,
          longitude: tLon,
        )),
        expect: () => [
          const WeatherLoading(),
          WeatherLoaded(weather: tWeather),
        ],
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'should emit [WeatherLoading, WeatherError] when getting data fails',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const GetCurrentWeatherEvent(
          latitude: tLat,
          longitude: tLon,
        )),
        expect: () => [
          const WeatherLoading(),
          const WeatherError(message: 'Server error'),
        ],
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'should emit [WeatherLoading, WeatherError] when getting data fails with network failure',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const GetCurrentWeatherEvent(
          latitude: tLat,
          longitude: tLon,
        )),
        expect: () => [
          const WeatherLoading(),
          const WeatherError(message: 'No internet connection'),
        ],
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'should call GetCurrentWeather use case with correct parameters',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => Right(tWeather));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const GetCurrentWeatherEvent(
          latitude: tLat,
          longitude: tLon,
        )),
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
          verifyNoMoreInteractions(mockGetCurrentWeather);
        },
      );
    });

    group('RefreshWeatherEvent', () {
      blocTest<WeatherBloc, WeatherState>(
        'should emit [WeatherLoaded] when refresh is successful (no loading state)',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => Right(tWeather));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const RefreshWeatherEvent(
          latitude: tLat,
          longitude: tLon,
        )),
        expect: () => [
          WeatherLoaded(weather: tWeather),
        ],
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'should emit [WeatherError] when refresh fails',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => const Left(ServerFailure(message: 'Refresh failed')));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const RefreshWeatherEvent(
          latitude: tLat,
          longitude: tLon,
        )),
        expect: () => [
          const WeatherError(message: 'Refresh failed'),
        ],
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'should call GetCurrentWeather use case with correct parameters on refresh',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => Right(tWeather));
          return weatherBloc;
        },
        act: (bloc) => bloc.add(const RefreshWeatherEvent(
          latitude: tLat,
          longitude: tLon,
        )),
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
          verifyNoMoreInteractions(mockGetCurrentWeather);
        },
      );
    });

    group('Multiple events', () {
      blocTest<WeatherBloc, WeatherState>(
        'should handle multiple GetCurrentWeatherEvent correctly',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => Right(tWeather));
          return weatherBloc;
        },
        act: (bloc) {
          bloc.add(const GetCurrentWeatherEvent(
            latitude: tLat,
            longitude: tLon,
          ));
        },
        expect: () => [
          const WeatherLoading(),
          WeatherLoaded(weather: tWeather),
        ],
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'should handle RefreshWeatherEvent from initial state',
        build: () {
          when(mockGetCurrentWeather(any))
              .thenAnswer((_) async => Right(tWeather));
          return weatherBloc;
        },
        act: (bloc) {
          bloc.add(const RefreshWeatherEvent(
            latitude: tLat,
            longitude: tLon,
          ));
        },
        expect: () => [
          WeatherLoaded(weather: tWeather),
        ],
        verify: (_) {
          verify(mockGetCurrentWeather(tParams));
        },
      );
    });
  });

  group('WeatherEvent', () {
    group('GetCurrentWeatherEvent', () {
      test('should be a subclass of WeatherEvent', () {
        const event = GetCurrentWeatherEvent(latitude: tLat, longitude: tLon);
        expect(event, isA<WeatherEvent>());
      });

      test('should return correct props', () {
        const event = GetCurrentWeatherEvent(latitude: tLat, longitude: tLon);
        expect(event.props, [tLat, tLon]);
      });

      test('should be equal when properties are the same', () {
        const event1 = GetCurrentWeatherEvent(latitude: tLat, longitude: tLon);
        const event2 = GetCurrentWeatherEvent(latitude: tLat, longitude: tLon);
        expect(event1, equals(event2));
      });

      test('should not be equal when properties are different', () {
        const event1 = GetCurrentWeatherEvent(latitude: tLat, longitude: tLon);
        const event2 = GetCurrentWeatherEvent(latitude: 45.0, longitude: tLon);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('RefreshWeatherEvent', () {
      test('should be a subclass of WeatherEvent', () {
        const event = RefreshWeatherEvent(latitude: tLat, longitude: tLon);
        expect(event, isA<WeatherEvent>());
      });

      test('should return correct props', () {
        const event = RefreshWeatherEvent(latitude: tLat, longitude: tLon);
        expect(event.props, [tLat, tLon]);
      });

      test('should be equal when properties are the same', () {
        const event1 = RefreshWeatherEvent(latitude: tLat, longitude: tLon);
        const event2 = RefreshWeatherEvent(latitude: tLat, longitude: tLon);
        expect(event1, equals(event2));
      });

      test('should not be equal when properties are different', () {
        const event1 = RefreshWeatherEvent(latitude: tLat, longitude: tLon);
        const event2 = RefreshWeatherEvent(latitude: 45.0, longitude: tLon);
        expect(event1, isNot(equals(event2)));
      });
    });
  });

  group('WeatherState', () {
    group('WeatherInitial', () {
      test('should be a subclass of WeatherState', () {
        const state = WeatherInitial();
        expect(state, isA<WeatherState>());
      });

      test('should return empty props', () {
        const state = WeatherInitial();
        expect(state.props, []);
      });

      test('should be equal to another WeatherInitial', () {
        const state1 = WeatherInitial();
        const state2 = WeatherInitial();
        expect(state1, equals(state2));
      });
    });

    group('WeatherLoading', () {
      test('should be a subclass of WeatherState', () {
        const state = WeatherLoading();
        expect(state, isA<WeatherState>());
      });

      test('should return empty props', () {
        const state = WeatherLoading();
        expect(state.props, []);
      });

      test('should be equal to another WeatherLoading', () {
        const state1 = WeatherLoading();
        const state2 = WeatherLoading();
        expect(state1, equals(state2));
      });
    });

    group('WeatherLoaded', () {
      test('should be a subclass of WeatherState', () {
        final state = WeatherLoaded(weather: tWeather);
        expect(state, isA<WeatherState>());
      });

      test('should return correct props', () {
        final state = WeatherLoaded(weather: tWeather);
        expect(state.props, [tWeather]);
      });

      test('should be equal when weather is the same', () {
        final state1 = WeatherLoaded(weather: tWeather);
        final state2 = WeatherLoaded(weather: tWeather);
        expect(state1, equals(state2));
      });
    });

    group('WeatherError', () {
      test('should be a subclass of WeatherState', () {
        const state = WeatherError(message: 'Error message');
        expect(state, isA<WeatherState>());
      });

      test('should return correct props', () {
        const state = WeatherError(message: 'Error message');
        expect(state.props, ['Error message']);
      });

      test('should be equal when message is the same', () {
        const state1 = WeatherError(message: 'Error message');
        const state2 = WeatherError(message: 'Error message');
        expect(state1, equals(state2));
      });

      test('should not be equal when message is different', () {
        const state1 = WeatherError(message: 'Error message 1');
        const state2 = WeatherError(message: 'Error message 2');
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}