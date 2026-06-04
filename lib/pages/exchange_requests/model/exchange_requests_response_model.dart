import 'package:json_annotation/json_annotation.dart';

import 'exchange_request_model.dart';

part 'exchange_requests_response_model.g.dart';

@JsonSerializable()
class ExchangeRequestsResponseModel {
  final bool? succeeded;
  final List<ExchangeRequestModel>? data;
  final int? totalCount;
  final dynamic error;

  const ExchangeRequestsResponseModel({
    this.succeeded,
    this.data,
    this.totalCount,
    this.error,
  });

  factory ExchangeRequestsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRequestsResponseModelToJson(this);
}

@JsonSerializable()
class ExchangeRequestResponseModel {
  final bool? succeeded;
  final ExchangeRequestModel? data;
  final dynamic error;

  const ExchangeRequestResponseModel({this.succeeded, this.data, this.error});

  factory ExchangeRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRequestResponseModelToJson(this);
}
