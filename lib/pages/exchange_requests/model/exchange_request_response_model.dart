import 'package:exchange_admin/core/constants/model/error_model.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_request_response_model.g.dart';

@JsonSerializable()
class ExchangeRequestResponseModel {
  final bool? succeeded;
  final ExchangeRequestModel? data;
  final ErrorModel? error;

  const ExchangeRequestResponseModel({this.succeeded, this.data, this.error});
  factory ExchangeRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRequestResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExchangeRequestResponseModelToJson(this);
}
