// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      id: (json['id'] as num?)?.toInt(),
      code: json['code'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      flag: json['flag'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'flag': instance.flag,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
    };
