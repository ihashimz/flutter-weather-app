import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedef.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  const WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<Weather> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final result = await remoteDataSource.getCurrentWeather(
        lat: latitude,
        lon: longitude,
      );
      return Right(_mapToEntity(result));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Weather _mapToEntity(WeatherModel model) {
    return Weather(
      latitude: model.coord.lat,
      longitude: model.coord.lon,
      cityName: model.name,
      country: model.sys.country,
      mainCondition: model.weather.first.main,
      description: model.weather.first.description,
      iconCode: model.weather.first.icon,
      temperature: model.main.temp,
      feelsLike: model.main.feelsLike,
      tempMin: model.main.tempMin,
      tempMax: model.main.tempMax,
      pressure: model.main.pressure,
      humidity: model.main.humidity,
      windSpeed: model.wind.speed,
      windDirection: model.wind.deg,
      windGust: model.wind.gust,
      cloudCoverage: model.clouds.all,
      visibility: model.visibility,
      dateTime: DateTime.fromMillisecondsSinceEpoch(model.dt * 1000),
      sunrise: DateTime.fromMillisecondsSinceEpoch(model.sys.sunrise * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(model.sys.sunset * 1000),
    );
  }
}