import 'package:json_annotation/json_annotation.dart';

part 'currency_request_model.g.dart';

@JsonSerializable()
class CreateCurrencyRequestModel {
  final String? code;
  final String? name;
  final String? symbol;
  final String? flag;

  const CreateCurrencyRequestModel({
    this.code,
    this.name,
    this.symbol,
    this.flag,
  });

  factory CreateCurrencyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCurrencyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCurrencyRequestModelToJson(this);
}

@JsonSerializable()
class UpdateCurrencyRequestModel {
  final String? name;
  final String? symbol;
  final String? flag;
  final bool? isActive;

  const UpdateCurrencyRequestModel({
    this.name,
    this.symbol,
    this.flag,
    this.isActive,
  });

  factory UpdateCurrencyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateCurrencyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCurrencyRequestModelToJson(this);
}
