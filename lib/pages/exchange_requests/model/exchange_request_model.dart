import 'package:json_annotation/json_annotation.dart';

part 'exchange_request_model.g.dart';

@JsonSerializable()
class ExchangeRequestModel {
  final int? id;
  final String? requestNumber;
  final String? clientName;
  final String? clientPhone;
  final String? type;
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final double? amount;
  final double? equivalentAmount;
  final double? rate;
  final String? status;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  const ExchangeRequestModel({
    this.id,
    this.requestNumber,
    this.clientName,
    this.clientPhone,
    this.type,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.amount,
    this.equivalentAmount,
    this.rate,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory ExchangeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRequestModelToJson(this);

  ExchangeRequestModel copyWith({String? status, String? notes}) =>
      ExchangeRequestModel(
        id: id,
        requestNumber: requestNumber,
        clientName: clientName,
        clientPhone: clientPhone,
        type: type,
        fromCurrencyCode: fromCurrencyCode,
        toCurrencyCode: toCurrencyCode,
        amount: amount,
        equivalentAmount: equivalentAmount,
        rate: rate,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
