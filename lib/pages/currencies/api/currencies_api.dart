import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/currencies/api/currencies_api_service.dart';
import 'package:exchange_admin/pages/currencies/model/currencies_response_model.dart';
import 'package:exchange_admin/pages/currencies/model/currency_request_model.dart';

class CurrenciesApi extends BaseApi {
  final CurrenciesApiService _service;

  CurrenciesApi(this._service);

  Future<ApiResult<CurrenciesResponseModel>> getCurrencies() =>
      execute(request: () => _service.getCurrencies());

  Future<ApiResult<CurrencyResponseModel>> createCurrency(
    CreateCurrencyRequestModel body,
  ) =>
      execute(request: () => _service.createCurrency(body));

  Future<ApiResult<CurrencyResponseModel>> updateCurrency(
    int id,
    UpdateCurrencyRequestModel body,
  ) =>
      execute(request: () => _service.updateCurrency(id, body));
}
