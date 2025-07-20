import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double latitude;
  final double longitude;
  final String cityName;
  final String country;
  final String mainCondition;
  final String description;
  final String iconCode;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final double? windGust;
  final int cloudCoverage;
  final int visibility;
  final DateTime dateTime;
  final DateTime sunrise;
  final DateTime sunset;

  const Weather({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.country,
    required this.mainCondition,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    this.windGust,
    required this.cloudCoverage,
    required this.visibility,
    required this.dateTime,
    required this.sunrise,
    required this.sunset,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        cityName,
        country,
        mainCondition,
        description,
        iconCode,
        temperature,
        feelsLike,
        tempMin,
        tempMax,
        pressure,
        humidity,
        windSpeed,
        windDirection,
        windGust,
        cloudCoverage,
        visibility,
        dateTime,
        sunrise,
        sunset,
      ];

  double get temperatureInCelsius => temperature - 273.15;
  double get feelsLikeInCelsius => feelsLike - 273.15;
  double get tempMinInCelsius => tempMin - 273.15;
  double get tempMaxInCelsius => tempMax - 273.15;
}