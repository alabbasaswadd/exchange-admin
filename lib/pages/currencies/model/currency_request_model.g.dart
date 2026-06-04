// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCurrencyRequestModel _$CreateCurrencyRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateCurrencyRequestModel(
  code: json['code'] as String?,
  name: json['name'] as String?,
  symbol: json['symbol'] as String?,
  flag: json['flag'] as String?,
);

Map<String, dynamic> _$CreateCurrencyRequestModelToJson(
  CreateCurrencyRequestModel instance,
) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'symbol': instance.symbol,
  'flag': instance.flag,
};

UpdateCurrencyRequestModel _$UpdateCurrencyRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateCurrencyRequestModel(
  name: json['name'] as String?,
  symbol: json['symbol'] as String?,
  flag: json['flag'] as String?,
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$UpdateCurrencyRequestModelToJson(
  UpdateCurrencyRequestModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'symbol': instance.symbol,
  'flag': instance.flag,
  'isActive': instance.isActive,
};
