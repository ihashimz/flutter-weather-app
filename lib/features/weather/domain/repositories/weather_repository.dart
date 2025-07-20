import '../../../../core/utils/typedef.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  ResultFuture<Weather> getCurrentWeather({
    required double latitude,
    required double longitude,
  });
}