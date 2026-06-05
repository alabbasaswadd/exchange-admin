import 'package:exchange_admin/core/constants/cached/cached_helper.dart';
import 'package:exchange_admin/core/constants/functions.dart';
import 'package:exchange_admin/core/networking/dio_factory.dart';
import 'package:exchange_admin/core/di/dependency_injection.dart';
import 'package:exchange_admin/l10n/app_localizations.dart';
import 'package:exchange_admin/routes.dart';
import 'package:exchange_admin/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  await UserSession.init();
  final token = await CacheHelper.getString('token');
  if (token.isNotEmpty) {
    DioFactory.setTokenIntoHeaderAfterLogin(token);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      locale: const Locale("ar"),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
