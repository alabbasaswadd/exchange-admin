// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateModel _$ExchangeRateModelFromJson(Map<String, dynamic> json) =>
    ExchangeRateModel(
      id: (json['id'] as num?)?.toInt(),
      fromCurrency: json['fromCurrency'] as String?,
      toCurrency: json['toCurrency'] as String?,
      buyRate: (json['buyRate'] as num?)?.toDouble(),
      sellRate: (json['sellRate'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ExchangeRateModelToJson(ExchangeRateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromCurrency': instance.fromCurrency,
      'toCurrency': instance.toCurrency,
      'buyRate': instance.buyRate,
      'sellRate': instance.sellRate,
      'isActive': instance.isActive,
      'updatedAt': instance.updatedAt,
    };
