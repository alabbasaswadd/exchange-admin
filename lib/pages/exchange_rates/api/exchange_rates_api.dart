import 'package:exchange_admin/core/constants/base_api.dart';
import 'package:exchange_admin/core/networking/api_result.dart';
import 'package:exchange_admin/pages/exchange_rates/api/exchange_rates_api_service.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';

class ExchangeRatesApi extends BaseApi {
  final ExchangeRatesApiService _service;

  ExchangeRatesApi(this._service);

  Future<ApiResult<List<ExchangeRateModel>>> getRates() =>
      execute(request: () => _service.getExchangeRates());

  Future<ApiResult<bool>> updateRate(
    String id,
    double buyRate,
    double sellRate,
  ) =>
      execute(
        request: () async {
          await _service.updateExchangeRate(id, buyRate, sellRate);
          return true;
        },
      );
}
