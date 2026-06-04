// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: json['id'] as String?,
  accountId: json['accountId'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'isActive': instance.isActive,
    };
