import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/ui/core/theme/asumi_theme.dart';
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
        child: const MaterialApp(
          home: LoginScreen(),
          localizationsDelegates: AppLocalizations.delegate,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    // Wait for async localization loading
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify logo is present
    expect(find.text('錦'), findsOneWidget);

    // Verify welcome back text
    expect(find.text('登录'), findsWidgets);
  });
}

/// Mock AuthProvider that doesn't make network calls
class _MockAuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => null;
}
