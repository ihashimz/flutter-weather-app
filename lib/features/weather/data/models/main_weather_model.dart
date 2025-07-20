import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'main_weather_model.g.dart';

@JsonSerializable()
class MainWeatherModel extends Equatable {
  final double temp;
  @JsonKey(name: 'feels_like')
  final double feelsLike;
  @JsonKey(name: 'temp_min')
  final double tempMin;
  @JsonKey(name: 'temp_max')
  final double tempMax;
  final int pressure;
  final int humidity;
  @JsonKey(name: 'sea_level')
  final int? seaLevel;
  @JsonKey(name: 'grnd_level')
  final int? grndLevel;

  const MainWeatherModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory MainWeatherModel.fromJson(Map<String, dynamic> json) =>
      _$MainWeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$MainWeatherModelToJson(this);

  @override
  List<Object?> get props => [
        temp,
        feelsLike,
        tempMin,
        tempMax,
        pressure,
        humidity,
        seaLevel,
        grndLevel,
      ];
}