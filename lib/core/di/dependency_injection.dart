import 'package:exchange_admin/pages/auth/signin/api/signin_api.dart';
import 'package:exchange_admin/pages/auth/signin/api/signin_api_service.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:exchange_admin/pages/startup/cubit/startup_cubit.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> initDI() async {
  getIt.registerLazySingleton(() => DioFactory.getDio());

  // API Services
  getIt.registerLazySingleton(() => SigninApiService(getIt()));
  // API Wrappers
  getIt.registerLazySingleton(() => SigninApi(getIt()));

  // Cubits
  getIt.registerLazySingleton(() => StartupCubit());
  getIt.registerFactory(() => SigninCubit(getIt()));
}
