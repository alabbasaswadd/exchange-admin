import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate_model.g.dart';

@JsonSerializable()
class ExchangeRateModel {
  final int? id;
  final String? fromCurrency;
  final String? toCurrency;
  final double? buyRate;
  final double? sellRate;
  final bool? isActive;
  final String? updatedAt;

  const ExchangeRateModel({
    this.id,
    this.fromCurrency,
    this.toCurrency,
    this.buyRate,
    this.sellRate,
    this.isActive,
    this.updatedAt,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateModelToJson(this);

  ExchangeRateModel copyWith({
    double? buyRate,
    double? sellRate,
    bool? isActive,
    String? updatedAt,
  }) =>
      ExchangeRateModel(
        id: id,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        buyRate: buyRate ?? this.buyRate,
        sellRate: sellRate ?? this.sellRate,
        isActive: isActive ?? this.isActive,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
