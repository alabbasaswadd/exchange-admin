// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsResponseModel _$NotificationsResponseModelFromJson(
  Map<String, dynamic> json,
) => NotificationsResponseModel(
  succeeded: json['succeeded'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unreadCount'] as num?)?.toInt(),
  error: json['error'],
);

Map<String, dynamic> _$NotificationsResponseModelToJson(
  NotificationsResponseModel instance,
) => <String, dynamic>{
  'succeeded': instance.succeeded,
  'data': instance.data,
  'unreadCount': instance.unreadCount,
  'error': instance.error,
};
