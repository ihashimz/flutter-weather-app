import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'coord_model.g.dart';

@JsonSerializable()
class CoordModel extends Equatable {
  final double lon;
  final double lat;

  const CoordModel({
    required this.lon,
    required this.lat,
  });

  factory CoordModel.fromJson(Map<String, dynamic> json) =>
      _$CoordModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoordModelToJson(this);

  @override
  List<Object> get props => [lon, lat];
}