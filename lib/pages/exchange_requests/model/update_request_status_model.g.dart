// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_request_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRequestStatusModel _$UpdateRequestStatusModelFromJson(
  Map<String, dynamic> json,
) => UpdateRequestStatusModel(
  status: json['status'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$UpdateRequestStatusModelToJson(
  UpdateRequestStatusModel instance,
) => <String, dynamic>{'status': instance.status, 'notes': instance.notes};
