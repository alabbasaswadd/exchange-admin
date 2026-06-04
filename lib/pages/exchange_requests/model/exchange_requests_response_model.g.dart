// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_requests_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRequestsResponseModel _$ExchangeRequestsResponseModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRequestsResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ExchangeRequestModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num?)?.toInt(),
  error: json['error'],
);

Map<String, dynamic> _$ExchangeRequestsResponseModelToJson(
  ExchangeRequestsResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'totalCount': instance.totalCount,
  'error': instance.error,
};

ExchangeRequestResponseModel _$ExchangeRequestResponseModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRequestResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: json['data'] == null
      ? null
      : ExchangeRequestModel.fromJson(json['data'] as Map<String, dynamic>),
  error: json['error'],
);

Map<String, dynamic> _$ExchangeRequestResponseModelToJson(
  ExchangeRequestResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'error': instance.error,
};
