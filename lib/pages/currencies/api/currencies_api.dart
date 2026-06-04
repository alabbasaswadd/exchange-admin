import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/currencies/api/currencies_api_service.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:exchange_admin/pages/currencies/model/currency_request_model.dart';

class CurrenciesApi extends BaseApi {
  final CurrenciesApiService _service;

  CurrenciesApi(this._service);

  Future<ApiResult<List<CurrencyModel>>> getCurrencies() =>
      execute(request: () => _service.getCurrencies());

  Future<ApiResult<CurrencyModel>> addCurrency(
    CurrencyRequestModel request,
  ) =>
      execute(request: () => _service.addCurrency(request));

  Future<ApiResult<CurrencyModel>> updateCurrency(
    String id,
    CurrencyRequestModel request,
  ) =>
      execute(request: () => _service.updateCurrency(id, request));

  Future<ApiResult<bool>> deleteCurrency(String id) => execute(
        request: () async {
          await _service.deleteCurrency(id);
          return true;
        },
      );
}
