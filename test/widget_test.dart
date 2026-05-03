import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/ui/core/view_models/theme_provider.dart';
import 'package:login_flutter/ui/core/view_models/locale_provider.dart';
import 'package:login_flutter/ui/core/i18n/app_localizations.dart';
import 'package:login_flutter/ui/features/auth/views/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => _MockAuthProvider()),
        ],
        child: MaterialApp(
          home: const LoginScreen(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    // Wait for async localization loading
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify logo is present
    expect(find.text('錦'), findsOneWidget);
  });
}

/// Mock AuthProvider that doesn't make network calls
class _MockAuthProvider extends ChangeNotifier {
  final bool _isLoading = false;
  final bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => null;
}
