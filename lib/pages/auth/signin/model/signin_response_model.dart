import 'package:exchange_admin/core/constants/model/error_model.dart';
import 'package:exchange_admin/pages/auth/signin/model/account_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signin_response_model.g.dart';

@JsonSerializable()
class SigninResponseModel {
  final bool? succeeded;
  final AccountModel? data;
  final ErrorModel? error;

  SigninResponseModel({this.succeeded, this.data, this.error});

  factory SigninResponseModel.fromJson(Map<String, dynamic> json) {
    return _$SigninResponseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SigninResponseModelToJson(this);
  }
}
