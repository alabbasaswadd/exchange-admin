class CurrencyModel {
  final String? id;
  final String? name;
  final String? code;
  final String? symbol;
  final bool? isActive;
  final String? createdAt;

  const CurrencyModel({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.isActive,
    this.createdAt,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        code: json['code'] as String?,
        symbol: json['symbol'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'symbol': symbol,
        'isActive': isActive,
        'createdAt': createdAt,
      };

  CurrencyModel copyWith({
    String? id,
    String? name,
    String? code,
    String? symbol,
    bool? isActive,
    String? createdAt,
  }) =>
      CurrencyModel(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        symbol: symbol ?? this.symbol,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
}
