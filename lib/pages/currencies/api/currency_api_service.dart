import 'package:dio/dio.dart';
import 'package:exchange_admin/core/networking/api_constans.dart';
import 'package:exchange_admin/pages/currencies/model/currency_model.dart';
import 'package:exchange_admin/pages/currencies/model/currency_request_model.dart';

class CurrenciesApiService {
  final Dio _dio;

  CurrenciesApiService(this._dio);

  Future<List<CurrencyModel>> getCurrencies() async {
    final response = await _dio.get(ApiConstants.currencies);
    return _parseList(response.data, CurrencyModel.fromJson);
  }

  Future<CurrencyModel> addCurrency(CurrencyRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.currencies,
      data: request.toJson(),
    );
    return _parseOne(response.data, CurrencyModel.fromJson);
  }

  Future<CurrencyModel> updateCurrency(
    String id,
    CurrencyRequestModel request,
  ) async {
    final response = await _dio.put(
      '${ApiConstants.currencies}/$id',
      data: request.toJson(),
    );
    return _parseOne(response.data, CurrencyModel.fromJson);
  }

  Future<void> deleteCurrency(String id) async {
    await _dio.delete('${ApiConstants.currencies}/$id');
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

  static T _parseOne<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data is Map<String, dynamic>) {
      if (data['succeeded'] == false) {
        throw Exception(
          (data['error'] as Map<String, dynamic>?)?['message'] ??
              'فشل في العملية',
        );
      }
      final item = data['data'] ?? data;
      return fromJson(item as Map<String, dynamic>);
    }
    return fromJson(data as Map<String, dynamic>);
  }
}
