import 'package:equatable/equatable.dart';

import '../../../../core/utils/typedef.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  const GetCurrentWeather(this.repository);

  ResultFuture<Weather> call(GetCurrentWeatherParams params) async {
    return await repository.getCurrentWeather(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class GetCurrentWeatherParams extends Equatable {
  final double latitude;
  final double longitude;

  const GetCurrentWeatherParams({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}