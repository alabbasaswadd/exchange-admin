import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/exchange_requests/api/exchange_requests_api_service.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_requests_response_model.dart';
import 'package:exchange_admin/pages/exchange_requests/model/update_request_status_model.dart';

class ExchangeRequestsApi extends BaseApi {
  final ExchangeRequestsApiService _service;

  ExchangeRequestsApi(this._service);

  Future<ApiResult<ExchangeRequestsResponseModel>> getExchangeRequests({
    int? page,
    int? pageSize,
    String? status,
  }) =>
      execute(
        request: () => _service.getExchangeRequests(
          page: page,
          pageSize: pageSize,
          status: status,
        ),
      );

  Future<ApiResult<ExchangeRequestResponseModel>> updateRequestStatus(
    int id,
    UpdateRequestStatusModel body,
  ) =>
      execute(request: () => _service.updateRequestStatus(id, body));
}
