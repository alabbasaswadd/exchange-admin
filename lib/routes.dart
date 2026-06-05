import 'package:exchange_admin/core/constants/cached/cached_helper.dart';
import 'package:exchange_admin/core/di/dependency_injection.dart';
import 'package:exchange_admin/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:exchange_admin/pages/auth/signin/screen/signin_screen.dart';
import 'package:exchange_admin/pages/currencies/cubit/currencies_cubit.dart';
import 'package:exchange_admin/pages/exchange_rates/cubit/exchange_rates_cubit.dart';
import 'package:exchange_admin/pages/exchange_requests/cubit/exchange_requests_cubit.dart';
import 'package:exchange_admin/pages/home/screen/history_screen.dart';
import 'package:exchange_admin/pages/home/screen/home_screen.dart';
import 'package:exchange_admin/pages/notifications/cubit/notifications_cubit.dart';
import 'package:exchange_admin/pages/notifications/screen/notifications_screen.dart';
import 'package:exchange_admin/pages/startup/cubit/startup_cubit.dart';
import 'package:exchange_admin/pages/startup/screen/startup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _publicPaths = ['/', '/signin'];

final GoRouter router = GoRouter(
  redirect: (context, state) async {
    final token = await CacheHelper.getString('token');
    final isLoggedIn = token.isNotEmpty;
    final isPublic = _publicPaths.contains(state.uri.path);
    if (!isLoggedIn && !isPublic) return '/signin';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<StartupCubit>(),
        child: const StartupScreen(),
      ),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<SigninCubit>(),
        child: const SigninScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<ExchangeRatesCubit>()..fetchRates(),
          ),
          BlocProvider(
            create: (_) => getIt<CurrenciesCubit>()..fetchCurrencies(),
          ),
          BlocProvider(
            create: (_) => getIt<ExchangeRequestsCubit>()..fetchRequests(),
          ),
          BlocProvider(create: (_) => getIt<NotificationsCubit>()),
        ],
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => BlocProvider.value(
        value: getIt<NotificationsCubit>(),
        child: const NotificationsScreen(),
      ),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<ExchangeRequestsCubit>()..fetchRequests(),
        child: const HistoryScreen(),
      ),
    ),
  ],
);
