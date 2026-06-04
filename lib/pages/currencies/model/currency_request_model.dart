class CurrencyRequestModel {
  final String name;
  final String code;
  final String symbol;
  final bool isActive;

  const CurrencyRequestModel({
    required this.name,
    required this.code,
    required this.symbol,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'symbol': symbol,
        'isActive': isActive,
      };
}
