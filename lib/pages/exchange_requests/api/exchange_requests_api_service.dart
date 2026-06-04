import 'package:dio/dio.dart';
import 'package:exchange_admin/core/networking/api_constans.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_requests_response_model.dart';
import 'package:exchange_admin/pages/exchange_requests/model/update_request_status_model.dart';
import 'package:retrofit/retrofit.dart';

part 'exchange_requests_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ExchangeRequestsApiService {
  factory ExchangeRequestsApiService(Dio dio, {String baseUrl}) =
      _ExchangeRequestsApiService;

  @GET(ApiConstants.exchangeRequests)
  Future<ExchangeRequestsResponseModel> getExchangeRequests({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('status') String? status,
  });

  @GET(ApiConstants.exchangeRequestById)
  Future<ExchangeRequestResponseModel> getExchangeRequestById(
    @Path('id') int id,
  );

  @PUT(ApiConstants.exchangeRequestStatus)
  Future<ExchangeRequestResponseModel> updateRequestStatus(
    @Path('id') int id,
    @Body() UpdateRequestStatusModel body,
  );
}
