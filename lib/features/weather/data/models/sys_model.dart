import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'sys_model.g.dart';

@JsonSerializable()
class SysModel extends Equatable {
  final String country;
  final int sunrise;
  final int sunset;

  const SysModel({
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory SysModel.fromJson(Map<String, dynamic> json) =>
      _$SysModelFromJson(json);

  Map<String, dynamic> toJson() => _$SysModelToJson(this);

  @override
  List<Object> get props => [country, sunrise, sunset];
}