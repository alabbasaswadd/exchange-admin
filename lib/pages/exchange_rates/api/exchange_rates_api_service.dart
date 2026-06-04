import 'package:dio/dio.dart';
import 'package:exchange_admin/core/networking/api_constans.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rates_response_model.dart';
import 'package:exchange_admin/pages/exchange_rates/model/update_rate_request_model.dart';
import 'package:retrofit/retrofit.dart';

part 'exchange_rates_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ExchangeRatesApiService {
  factory ExchangeRatesApiService(Dio dio, {String baseUrl}) =
      _ExchangeRatesApiService;

  @GET(ApiConstants.exchangeRates)
  Future<ExchangeRatesResponseModel> getExchangeRates();

  @GET(ApiConstants.exchangeRateActive)
  Future<ExchangeRateResponseModel> getActiveRate();

  @PUT(ApiConstants.exchangeRateById)
  Future<ExchangeRateResponseModel> updateExchangeRate(
    @Path('id') int id,
    @Body() UpdateRateRequestModel body,
  );
}
