import 'package:dio/dio.dart';
import 'package:exchange_admin/core/networking/api_constans.dart';
import 'package:exchange_admin/pages/notifications/model/notifications_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'notifications_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class NotificationsApiService {
  factory NotificationsApiService(Dio dio, {String baseUrl}) =
      _NotificationsApiService;

  @GET(ApiConstants.notifications)
  Future<NotificationsResponseModel> getNotifications();

  @PUT(ApiConstants.notificationRead)
  Future<void> markAsRead(@Path('id') int id);

  @PUT(ApiConstants.notificationReadAll)
  Future<void> markAllAsRead();
}
