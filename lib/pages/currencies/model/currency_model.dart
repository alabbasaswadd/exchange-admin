import 'package:json_annotation/json_annotation.dart';

part 'currency_model.g.dart';

@JsonSerializable()
class CurrencyModel {
  final int? id;
  final String? code;
  final String? name;
  final String? symbol;
  final String? flag;
  final bool? isActive;
  final String? createdAt;

  const CurrencyModel({
    this.id,
    this.code,
    this.name,
    this.symbol,
    this.flag,
    this.isActive,
    this.createdAt,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);

  CurrencyModel copyWith({
    String? name,
    String? symbol,
    String? flag,
    bool? isActive,
  }) =>
      CurrencyModel(
        id: id,
        code: code,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        flag: flag ?? this.flag,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
      );
}
