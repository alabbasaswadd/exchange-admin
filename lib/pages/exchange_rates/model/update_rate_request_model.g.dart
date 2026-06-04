// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_rate_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRateRequestModel _$UpdateRateRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateRateRequestModel(
  buyRate: (json['buyRate'] as num?)?.toDouble(),
  sellRate: (json['sellRate'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$UpdateRateRequestModelToJson(
  UpdateRateRequestModel instance,
) => <String, dynamic>{
  'buyRate': instance.buyRate,
  'sellRate': instance.sellRate,
  'isActive': instance.isActive,
};
