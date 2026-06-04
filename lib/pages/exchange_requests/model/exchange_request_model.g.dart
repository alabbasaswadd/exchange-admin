// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRequestModel _$ExchangeRequestModelFromJson(
  Map<String, dynamic> json,
) => ExchangeRequestModel(
  id: (json['id'] as num?)?.toInt(),
  requestNumber: json['requestNumber'] as String?,
  clientName: json['clientName'] as String?,
  clientPhone: json['clientPhone'] as String?,
  type: json['type'] as String?,
  fromCurrencyCode: json['fromCurrencyCode'] as String?,
  toCurrencyCode: json['toCurrencyCode'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  equivalentAmount: (json['equivalentAmount'] as num?)?.toDouble(),
  rate: (json['rate'] as num?)?.toDouble(),
  status: json['status'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$ExchangeRequestModelToJson(
  ExchangeRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'requestNumber': instance.requestNumber,
  'clientName': instance.clientName,
  'clientPhone': instance.clientPhone,
  'type': instance.type,
  'fromCurrencyCode': instance.fromCurrencyCode,
  'toCurrencyCode': instance.toCurrencyCode,
  'amount': instance.amount,
  'equivalentAmount': instance.equivalentAmount,
  'rate': instance.rate,
  'status': instance.status,
  'notes': instance.notes,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
