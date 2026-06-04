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
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhNDRhN2RjYS04YzY0LTRjY2ItYmZmNS1mZjE4ODNkM2VlYTYiLCJqdGkiOiIyNjI1MzZhNS0zOGE4LTQ4MzAtYjFjZi1kY2IzNzg1MGY4OGYiLCJuYmYiOjE3ODA2MDU0MDgsImV4cCI6MTc4NTc4OTQwOCwiaWF0IjoxNzgwNjA1NDA4LCJpc3MiOiJDdXJyZW5jeUV4Y2hhbmdlVXNlckFwaSIsImF1ZCI6IkN1cnJlbmN5RXhjaGFuZ2VVc2VyQ2xpZW50cyJ9.5LdBVwA9wwrOn_KiX22IfEKU9n9H3cmJzEXgk3n3vLQ',
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
