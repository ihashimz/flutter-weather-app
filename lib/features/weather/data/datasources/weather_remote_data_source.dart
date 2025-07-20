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
}