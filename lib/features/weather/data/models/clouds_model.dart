import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'clouds_model.g.dart';

@JsonSerializable()
class CloudsModel extends Equatable {
  final int all;

  const CloudsModel({
    required this.all,
  });

  factory CloudsModel.fromJson(Map<String, dynamic> json) =>
      _$CloudsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CloudsModelToJson(this);

  @override
  List<Object> get props => [all];
}