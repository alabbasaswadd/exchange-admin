import 'package:json_annotation/json_annotation.dart';

import 'exchange_rate_model.dart';

part 'exchange_rates_response_model.g.dart';

@JsonSerializable()
class ExchangeRatesResponseModel {
  final bool? succeeded;
  final List<ExchangeRateModel>? data;
  final dynamic error;

  const ExchangeRatesResponseModel({this.succeeded, this.data, this.error});

  factory ExchangeRatesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRatesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRatesResponseModelToJson(this);
}

@JsonSerializable()
class ExchangeRateResponseModel {
  final bool? succeeded;
  final ExchangeRateModel? data;
  final dynamic error;

  const ExchangeRateResponseModel({this.succeeded, this.data, this.error});

  factory ExchangeRateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateResponseModelToJson(this);
}
