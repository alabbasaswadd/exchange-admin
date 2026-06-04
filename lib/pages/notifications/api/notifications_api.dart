import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/notifications/api/notifications_api_service.dart';
import 'package:exchange_admin/pages/notifications/model/notifications_response_model.dart';

class NotificationsApi extends BaseApi {
  final NotificationsApiService _service;

  NotificationsApi(this._service);

  Future<ApiResult<NotificationsResponseModel>> getNotifications() =>
      execute(request: () => _service.getNotifications());

  Future<ApiResult<void>> markAsRead(int id) =>
      execute(request: () => _service.markAsRead(id));

  Future<ApiResult<void>> markAllAsRead() =>
      execute(request: () => _service.markAllAsRead());
}
