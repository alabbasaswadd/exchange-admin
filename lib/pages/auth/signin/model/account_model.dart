import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  final String? id;
  final String? accountId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool? isActive;

  AccountModel({
    this.id,
    this.accountId,
    this.firstName,
    this.lastName,
    this.email,
    this.isActive,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
