import 'package:exchange_admin/core/constants/base_cubit.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/notifications/api/notifications_api.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_state.dart';
import 'package:exchange_admin/pages/notifications/model/notification_model.dart';

class NotificationsCubit extends BaseCubit<NotificationsState> {
  final NotificationsApi _api;

  NotificationsCubit(this._api) : super(const NotificationsState.initial());

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);
  int get unreadCount =>
      _notifications.where((n) => n.isRead == false).length;

  Future<void> fetchNotifications() async {
    emit(const NotificationsState.loading());
    final result = await _api.getNotifications();
    result.when(
      success: (response) {
        _notifications = response.data ?? [];
        emit(NotificationsState.loaded(_notifications));
      },
      failure: (error) =>
          emit(NotificationsState.error(error.message ?? 'حدث خطأ')),
    );
  }

  Future<void> markAsRead(int? id) async {
    if (id == null) return;
    final result = await _api.markAsRead(id);
    result.when(
      success: (_) {
        _notifications = _notifications
            .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
            .toList();
        emit(NotificationsState.loaded(_notifications));
      },
      failure: (_) {},
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _api.markAllAsRead();
    result.when(
      success: (_) {
        _notifications =
            _notifications.map((n) => n.copyWith(isRead: true)).toList();
        emit(NotificationsState.loaded(_notifications));
      },
      failure: (_) {},
    );
  }
}
