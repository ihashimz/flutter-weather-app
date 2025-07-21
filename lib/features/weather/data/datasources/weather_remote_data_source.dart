import 'package:flutter/foundation.dart';
import '../../../../core/api/base_api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather({
    required double lat,
    required double lon,
  });
}

class WeatherRemoteDataSourceImpl extends BaseApiService
    implements WeatherRemoteDataSource {
  const WeatherRemoteDataSourceImpl({required super.dioClient});

  @override
  Future<WeatherModel> getCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    // For web platform, return mock data due to CORS issues
    if (kIsWeb) {
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      return WeatherModel.fromJson(_getMockWeatherData());
    }
    
    final response = await handleApiCall(
      dioClient.get(
        ApiConstants.weatherEndpoint,
        queryParameters: {
          'lat': lat,
          'lon': lon,
        },
      ),
    );

    return WeatherModel.fromJson(response);
  }

  Map<String, dynamic> _getMockWeatherData() {
    return {
      "coord": {
        "lon": 10.99,
        "lat": 44.34
      },
      "weather": [
        {
          "id": 803,
          "main": "Clouds",
          "description": "broken clouds",
          "icon": "04d"
        }
      ],
      "base": "stations",
      "main": {
        "temp": 301.1,
        "feels_like": 301.37,
        "temp_min": 301.1,
        "temp_max": 301.1,
        "pressure": 1008,
        "humidity": 48,
        "sea_level": 1008,
        "grnd_level": 943
      },
      "visibility": 10000,
      "wind": {
        "speed": 1.24,
        "deg": 113,
        "gust": 3.56
      },
      "clouds": {
        "all": 51
      },
      "dt": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "sys": {
        "country": "IT",
        "sunrise": DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        "sunset": DateTime.now().add(const Duration(hours: 8)).millisecondsSinceEpoch ~/ 1000
      },
      "timezone": 7200,
      "id": 3163858,
      "name": "Zocca",
      "cod": 200
    };
  }
}