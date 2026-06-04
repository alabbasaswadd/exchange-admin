// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currencies_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrenciesResponseModel _$CurrenciesResponseModelFromJson(
  Map<String, dynamic> json,
) => CurrenciesResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  error: json['error'],
);

Map<String, dynamic> _$CurrenciesResponseModelToJson(
  CurrenciesResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};

CurrencyResponseModel _$CurrencyResponseModelFromJson(
  Map<String, dynamic> json,
) => CurrencyResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: json['data'] == null
      ? null
      : CurrencyModel.fromJson(json['data'] as Map<String, dynamic>),
  error: json['error'],
);

Map<String, dynamic> _$CurrencyResponseModelToJson(
  CurrencyResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};
