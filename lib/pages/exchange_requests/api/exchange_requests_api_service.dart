import 'package:dio/dio.dart';
import 'package:exchange_admin/core/networking/api_constans.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_model.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_request_model.dart';
import 'package:exchange_admin/pages/exchange_requests/model/exchange_request_response_model.dart';

class ExchangeRequestsApiService {
  final Dio _dio;

  ExchangeRequestsApiService(this._dio);

  Future<List<ExchangeRequestModel>> getRequests() async {
    final response = await _dio.get(ApiConstants.exchangeRequests);
    return _parseList(response.data, ExchangeRequestModel.fromJson);
  }

  Future<ExchangeRequestResponseModel> updateRequest(
    String id,
    ExchangeRequestRequestModel data,
  ) async {
    final response = await _dio.put(
      '${ApiConstants.exchangeRequests}/$id/status',
      data: data.toJson(),
    );
    return ExchangeRequestResponseModel.fromJson(response.data);
  }

  // Future<void> rejectRequest(String id) async {
  //   await _dio.put('${ApiConstants.exchangeRateUpdate}/$id');
  // }

  // Future<void> suspendRequest(String id) async {
  //   await _dio.put('${ApiConstants.exchangeRequestSuspend}/$id');
  // }

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
