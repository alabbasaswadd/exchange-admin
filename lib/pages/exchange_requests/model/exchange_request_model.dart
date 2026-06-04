class ExchangeRequestModel {
  final String? id;
  final String? requesterName;
  final String? requesterPhone;
  final String? fromCurrencyCode;
  final String? toCurrencyCode;
  final double? amount;
  final double? exchangeRate;
  final double? convertedAmount;
  final String? status;
  final String? createdAt;
  final String? notes;

  const ExchangeRequestModel({
    this.id,
    this.requesterName,
    this.requesterPhone,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.amount,
    this.exchangeRate,
    this.convertedAmount,
    this.status,
    this.createdAt,
    this.notes,
  });

  factory ExchangeRequestModel.fromJson(Map<String, dynamic> json) =>
      ExchangeRequestModel(
        id: json['id'] as String?,
        requesterName: json['requesterName'] as String?,
        requesterPhone: json['requesterPhone'] as String?,
        fromCurrencyCode: json['fromCurrencyCode'] as String?,
        toCurrencyCode: json['toCurrencyCode'] as String?,
        amount: (json['amount'] as num?)?.toDouble(),
        exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
        convertedAmount: (json['convertedAmount'] as num?)?.toDouble(),
        status: json['status'] as String?,
        createdAt: json['createdAt'] as String?,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'requesterName': requesterName,
        'requesterPhone': requesterPhone,
        'fromCurrencyCode': fromCurrencyCode,
        'toCurrencyCode': toCurrencyCode,
        'amount': amount,
        'exchangeRate': exchangeRate,
        'convertedAmount': convertedAmount,
        'status': status,
        'createdAt': createdAt,
        'notes': notes,
      };

  ExchangeRequestModel copyWith({String? status}) => ExchangeRequestModel(
        id: id,
        requesterName: requesterName,
        requesterPhone: requesterPhone,
        fromCurrencyCode: fromCurrencyCode,
        toCurrencyCode: toCurrencyCode,
        amount: amount,
        exchangeRate: exchangeRate,
        convertedAmount: convertedAmount,
        status: status ?? this.status,
        createdAt: createdAt,
        notes: notes,
      );
}
