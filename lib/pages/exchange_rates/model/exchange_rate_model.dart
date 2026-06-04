class ExchangeRateModel {
  final String? id;
  final String? fromCurrencyId;
  final String? toCurrencyId;
  final String? fromCurrencyName;
  final String? toCurrencyName;
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final double? buyRate;
  final double? sellRate;
  final String? updatedAt;

  const ExchangeRateModel({
    this.id,
    this.fromCurrencyId,
    this.toCurrencyId,
    this.fromCurrencyName,
    this.toCurrencyName,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.buyRate,
    this.sellRate,
    this.updatedAt,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      ExchangeRateModel(
        id: json['id'] as String?,
        fromCurrencyId: json['fromCurrencyId'] as String?,
        toCurrencyId: json['toCurrencyId'] as String?,
        fromCurrencyName: json['fromCurrencyName'] as String?,
        toCurrencyName: json['toCurrencyName'] as String?,
        fromCurrencyCode: json['fromCurrencyCode'] as String?,
        toCurrencyCode: json['toCurrencyCode'] as String?,
        buyRate: (json['buyRate'] as num?)?.toDouble(),
        sellRate: (json['sellRate'] as num?)?.toDouble(),
        updatedAt: json['updatedAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromCurrencyId': fromCurrencyId,
        'toCurrencyId': toCurrencyId,
        'fromCurrencyName': fromCurrencyName,
        'toCurrencyName': toCurrencyName,
        'fromCurrencyCode': fromCurrencyCode,
        'toCurrencyCode': toCurrencyCode,
        'buyRate': buyRate,
        'sellRate': sellRate,
        'updatedAt': updatedAt,
      };

  ExchangeRateModel copyWith({
    String? id,
    String? fromCurrencyId,
    String? toCurrencyId,
    String? fromCurrencyName,
    String? toCurrencyName,
    String? fromCurrencyCode,
    String? toCurrencyCode,
    double? buyRate,
    double? sellRate,
    String? updatedAt,
  }) =>
      ExchangeRateModel(
        id: id ?? this.id,
        fromCurrencyId: fromCurrencyId ?? this.fromCurrencyId,
        toCurrencyId: toCurrencyId ?? this.toCurrencyId,
        fromCurrencyName: fromCurrencyName ?? this.fromCurrencyName,
        toCurrencyName: toCurrencyName ?? this.toCurrencyName,
        fromCurrencyCode: fromCurrencyCode ?? this.fromCurrencyCode,
        toCurrencyCode: toCurrencyCode ?? this.toCurrencyCode,
        buyRate: buyRate ?? this.buyRate,
        sellRate: sellRate ?? this.sellRate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
