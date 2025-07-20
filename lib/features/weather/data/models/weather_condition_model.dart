import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'weather_condition_model.g.dart';

@JsonSerializable()
class WeatherConditionModel extends Equatable {
  final int id;
  final String main;
  final String description;
  final String icon;

  const WeatherConditionModel({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherConditionModelToJson(this);

  @override
  List<Object> get props => [id, main, description, icon];
}