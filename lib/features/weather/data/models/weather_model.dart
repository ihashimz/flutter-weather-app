import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'coord_model.dart';
import 'weather_condition_model.dart';
import 'main_weather_model.dart';
import 'wind_model.dart';
import 'clouds_model.dart';
import 'sys_model.dart';

part 'weather_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WeatherModel extends Equatable {
  final CoordModel coord;
  final List<WeatherConditionModel> weather;
  final String base;
  final MainWeatherModel main;
  final int visibility;
  final WindModel wind;
  final CloudsModel clouds;
  final int dt;
  final SysModel sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  const WeatherModel({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  @override
  List<Object> get props => [
        coord,
        weather,
        base,
        main,
        visibility,
        wind,
        clouds,
        dt,
        sys,
        timezone,
        id,
        name,
        cod,
      ];
}