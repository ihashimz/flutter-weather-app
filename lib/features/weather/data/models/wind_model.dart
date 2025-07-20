import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'wind_model.g.dart';

@JsonSerializable()
class WindModel extends Equatable {
  final double speed;
  final int deg;
  final double? gust;

  const WindModel({
    required this.speed,
    required this.deg,
    this.gust,
  });

  factory WindModel.fromJson(Map<String, dynamic> json) =>
      _$WindModelFromJson(json);

  Map<String, dynamic> toJson() => _$WindModelToJson(this);

  @override
  List<Object?> get props => [speed, deg, gust];
}