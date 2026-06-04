import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/exchange_rates/api/exchange_rates_api_service.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rates_response_model.dart';
import 'package:exchange_admin/pages/exchange_rates/model/update_rate_request_model.dart';

class ExchangeRatesApi extends BaseApi {
  final ExchangeRatesApiService _service;

  ExchangeRatesApi(this._service);

  Future<ApiResult<ExchangeRatesResponseModel>> getExchangeRates() =>
      execute(request: () => _service.getExchangeRates());

  Future<ApiResult<ExchangeRateResponseModel>> getActiveRate() =>
      execute(request: () => _service.getActiveRate());

  Future<ApiResult<ExchangeRateResponseModel>> updateExchangeRate(
    int id,
    UpdateRateRequestModel body,
  ) =>
      execute(request: () => _service.updateExchangeRate(id, body));
}
