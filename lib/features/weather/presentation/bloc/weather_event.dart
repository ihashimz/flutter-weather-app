import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  const GetCurrentWeatherEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class RefreshWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  const RefreshWeatherEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}