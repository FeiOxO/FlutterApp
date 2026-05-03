import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/asumi_theme.dart';
import 'i18n/app_localizations.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';

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

    return MaterialApp(
      title: '锦亚澄 ✦ 登录',
      debugShowCheckedModeBanner: false,
      theme: AsumiTheme.lightTheme,
      darkTheme: AsumiTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('zh'),
        Locale('ja'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoading && !auth.isLoggedIn) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (auth.isLoggedIn) {
      return const DashboardScreen();
    }
    return const LoginScreen();
  }
}
