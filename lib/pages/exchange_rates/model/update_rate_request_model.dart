import 'package:json_annotation/json_annotation.dart';

part 'update_rate_request_model.g.dart';

@JsonSerializable()
class UpdateRateRequestModel {
  final double? buyRate;
  final double? sellRate;
  final bool? isActive;

  const UpdateRateRequestModel({this.buyRate, this.sellRate, this.isActive});

  factory UpdateRateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateRateRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateRateRequestModelToJson(this);
}
