// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rates_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRatesResponseModel _$ExchangeRatesResponseModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRatesResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ExchangeRateModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  error: json['error'],
);

Map<String, dynamic> _$ExchangeRatesResponseModelToJson(
  ExchangeRatesResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};

ExchangeRateResponseModel _$ExchangeRateResponseModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRateResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: json['data'] == null
      ? null
      : ExchangeRateModel.fromJson(json['data'] as Map<String, dynamic>),
  error: json['error'],
);

Map<String, dynamic> _$ExchangeRateResponseModelToJson(
  ExchangeRateResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};
