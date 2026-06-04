import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/exchange_requests/api/exchange_requests_api_service.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';

class ExchangeRequestsApi extends BaseApi {
  final ExchangeRequestsApiService _service;

  ExchangeRequestsApi(this._service);

  Future<ApiResult<List<ExchangeRequestModel>>> getRequests() =>
      execute(request: () => _service.getRequests());

  Future<ApiResult<bool>> acceptRequest(String id) => execute(
        request: () async {
          await _service.acceptRequest(id);
          return true;
        },
      );

  Future<ApiResult<bool>> rejectRequest(String id) => execute(
        request: () async {
          await _service.rejectRequest(id);
          return true;
        },
      );

  Future<ApiResult<bool>> suspendRequest(String id) => execute(
        request: () async {
          await _service.suspendRequest(id);
          return true;
        },
      );
}
