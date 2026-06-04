import 'package:exchange_admin/pages/notifications/model/notification_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _Initial;
  const factory NotificationsState.loading() = _Loading;
  const factory NotificationsState.loaded(
    List<NotificationModel> notifications,
  ) = _Loaded;
  const factory NotificationsState.error(String message) = _Error;
}
