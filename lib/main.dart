import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'ui/core/theme/asumi_theme.dart';
import 'ui/core/i18n/app_localizations.dart';
import 'ui/core/view_models/theme_provider.dart';
import 'ui/core/view_models/locale_provider.dart';
import 'ui/features/auth/view_models/auth_provider.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const LoginFlutterApp(),
    ),
  );
}

class LoginFlutterApp extends StatelessWidget {
  const LoginFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      title: '锦亚澄 ✦ 登录',
      debugShowCheckedModeBanner: false,
      theme: AsumiTheme.lightTheme,
      darkTheme: AsumiTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: createAppRouter(),
    );
  }
}
