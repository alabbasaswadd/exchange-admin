import 'package:dio/dio.dart';
import 'package:exchange_admin/core/networking/api_constans.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;
  static String _token = '';

  static Dio getDio() {
    if (_dio == null) {
      const timeOut = Duration(seconds: 30);
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
          headers: {
            if (_token.isNotEmpty) 'Authorization': 'Bearer $_token',
          },
        ),
      );
      _addInterceptor();
    }
    return _dio!;
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    _token = token;
    if (token.isEmpty) {
      _dio?.options.headers.remove('Authorization');
    } else {
      _dio?.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static void _addInterceptor() {
    _dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
