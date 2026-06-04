import 'package:json_annotation/json_annotation.dart';

import 'currency_model.dart';

part 'currencies_response_model.g.dart';

@JsonSerializable()
class CurrenciesResponseModel {
  final bool? succeeded;
  final List<CurrencyModel>? data;
  final dynamic error;

  const CurrenciesResponseModel({this.succeeded, this.data, this.error});

  factory CurrenciesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CurrenciesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrenciesResponseModelToJson(this);
}

@JsonSerializable()
class CurrencyResponseModel {
  final bool? succeeded;
  final CurrencyModel? data;
  final dynamic error;

  const CurrencyResponseModel({this.succeeded, this.data, this.error});

  factory CurrencyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyResponseModelToJson(this);
}
