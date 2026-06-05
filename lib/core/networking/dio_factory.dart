import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constans.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      const timeOut = Duration(seconds: 30);
      dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: timeOut,
          receiveTimeout: timeOut,
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJmMDU4MmUyOC1lNjJjLTRmN2YtOWYyYS1hYmI1NTIyOTY4NjYiLCJqdGkiOiJjY2UyMjI5NS1hNjNhLTQ2ZDAtYjk5Mi04ZTRiYTg0MTVjMjciLCJuYmYiOjE3ODA2NTczNjcsImV4cCI6MTc4NTg0MTM2NywiaWF0IjoxNzgwNjU3MzY3LCJpc3MiOiJDdXJyZW5jeUV4Y2hhbmdlQXBpIiwiYXVkIjoiQ3VycmVuY3lFeGNoYW5nZUNsaWVudHMifQ.x5zaP0ALeLaG89OuljFSM1byq9k90mLX1qChnUSjIyY',
          },
        ),
      );
      addDioInterceptor();
    }
    return dio!;
  }

  // static void addDioHeaders() async {
  //   dio?.options.headers = {
  //     'Accept': 'application/json',
  //     'Authorization':
  //         'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
  //   };
  // }

  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      // 'X-Tenant-Id':
      //     UserSession.user?.subscriptions.first.id ?? ApiConstants.tenantId,
      // 'Authorization': 'Bearer ${UserSession.user?.token ?? token}',
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
