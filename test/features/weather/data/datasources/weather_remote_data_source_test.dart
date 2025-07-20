import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_weather_app/core/network/dio_client.dart';
import 'package:flutter_weather_app/core/errors/exceptions.dart';
import 'package:flutter_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_weather_app/features/weather/data/models/weather_model.dart';
import '../../../../helpers/test_helper.dart';

@GenerateMocks([DioClient])
import 'weather_remote_data_source_test.mocks.dart';

void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = WeatherRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  group('getCurrentWeather', () {
    const tLat = 44.34;
    const tLon = 10.99;
    final tWeatherResponseJson = jsonFixture('weather_response.json');
    final tWeatherModel = WeatherModel.fromJson(tWeatherResponseJson);

    test('should perform a GET request on weather endpoint with correct parameters', () async {
      when(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: tWeatherResponseJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      await dataSource.getCurrentWeather(lat: tLat, lon: tLon);

      verify(mockDioClient.get(
        '/weather',
        queryParameters: {
          'lat': tLat,
          'lon': tLon,
        },
      ));
    });

    test('should return WeatherModel when the response code is 200', () async {
      when(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: tWeatherResponseJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataSource.getCurrentWeather(lat: tLat, lon: tLon);

      expect(result, equals(tWeatherModel));
    });

    test('should throw ServerException when the response code is not 200', () async {
      when(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'message': 'Server Error'},
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

      expect(
        () => dataSource.getCurrentWeather(lat: tLat, lon: tLon),
        throwsA(isA<ServerException>()),
      );
    });

    test('should handle empty response data', () async {
      when(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: null,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      expect(
        () => dataSource.getCurrentWeather(lat: tLat, lon: tLon),
        throwsA(isA<TypeError>()),
      );
    });

    test('should handle various coordinate formats', () async {
      when(mockDioClient.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                data: tWeatherResponseJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      const testCases = [
        {'lat': 0.0, 'lon': 0.0},
        {'lat': -90.0, 'lon': -180.0},
        {'lat': 90.0, 'lon': 180.0},
        {'lat': 44.123456, 'lon': 10.987654},
      ];

      for (final testCase in testCases) {
        await dataSource.getCurrentWeather(
          lat: testCase['lat']!,
          lon: testCase['lon']!,
        );

        verify(mockDioClient.get(
          '/weather',
          queryParameters: {
            'lat': testCase['lat'],
            'lon': testCase['lon'],
          },
        ));
      }
    });
  });
}