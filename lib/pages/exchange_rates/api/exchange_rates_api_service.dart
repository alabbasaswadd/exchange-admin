import 'package:dio/dio.dart';
import 'package:exchange_admin/core/networking/api_constans.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_model.dart';
import 'package:exchange_admin/pages/exchange_rates/model/exchange_rate_request_model.dart';

class ExchangeRatesApiService {
  final Dio _dio;

  ExchangeRatesApiService(this._dio);

  Future<List<ExchangeRateModel>> getExchangeRates() async {
    final response = await _dio.get(ApiConstants.exchangeRates);
    return _parseList(response.data, ExchangeRateModel.fromJson);
  }

  Future<ExchangeRateModel> updateExchangeRate(
    String id,
    ExchangeRateRequestModel request,
  ) async {
    final response = await _dio.put(
      '${ApiConstants.exchangeRateUpdate}/$id',
      data: request.toJson(),
    );
    return ExchangeRateModel.fromJson(response.data);
  }

  static List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data is List) {
      return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }
    if (data is Map<String, dynamic>) {
      if (data['succeeded'] == false) {
        throw Exception(
          (data['error'] as Map<String, dynamic>?)?['message'] ??
              'فشل تحميل البيانات',
        );
      }
      final list = data['data'];
      if (list is List) {
        return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }
    }
    return [];
  }
}
