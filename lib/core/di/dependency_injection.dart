import 'package:exchange_admin/pages/auth/signin/api/signin_api.dart';
import 'package:exchange_admin/pages/auth/signin/api/signin_api_service.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:exchange_admin/pages/currencies/api/currencies_api.dart';
import 'package:exchange_admin/pages/currencies/api/currencies_api_service.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_admin/pages/exchange_rates/api/exchange_rates_api.dart';
import 'package:exchange_admin/pages/exchange_rates/api/exchange_rates_api_service.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/api/exchange_requests_api.dart';
import 'package:exchange_admin/pages/exchange_requests/api/exchange_requests_api_service.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/notifications/api/notifications_api.dart';
import 'package:exchange_admin/pages/notifications/api/notifications_api_service.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_admin/pages/startup/cubit/startup_cubit.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> initDI() async {
  getIt.registerLazySingleton(() => DioFactory.getDio());

  // API Services
  getIt.registerLazySingleton(() => SigninApiService(getIt()));
  getIt.registerLazySingleton(() => ExchangeRatesApiService(getIt()));
  getIt.registerLazySingleton(() => CurrenciesApiService(getIt()));
  getIt.registerLazySingleton(() => ExchangeRequestsApiService(getIt()));
  getIt.registerLazySingleton(() => NotificationsApiService(getIt()));

  // API Wrappers
  getIt.registerLazySingleton(() => SigninApi(getIt()));
  getIt.registerLazySingleton(() => ExchangeRatesApi(getIt()));
  getIt.registerLazySingleton(() => CurrenciesApi(getIt()));
  getIt.registerLazySingleton(() => ExchangeRequestsApi(getIt()));
  getIt.registerLazySingleton(() => NotificationsApi(getIt()));

  // Cubits
  getIt.registerLazySingleton(() => StartupCubit());
  getIt.registerFactory(() => SigninCubit(getIt()));
  getIt.registerFactory(() => ExchangeRatesCubit(getIt()));
  getIt.registerFactory(() => CurrenciesCubit(getIt()));
  getIt.registerFactory(() => ExchangeRequestsCubit(getIt()));
  getIt.registerLazySingleton(() => NotificationsCubit(getIt()));
}
