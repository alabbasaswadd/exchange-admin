import 'package:json_annotation/json_annotation.dart';

import 'notification_model.dart';

part 'notifications_response_model.g.dart';

@JsonSerializable()
class NotificationsResponseModel {
  final bool? succeeded;
  final List<NotificationModel>? data;
  final int? unreadCount;
  final dynamic error;

  const NotificationsResponseModel({
    this.succeeded,
    this.data,
    this.unreadCount,
    this.error,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsResponseModelToJson(this);
}
