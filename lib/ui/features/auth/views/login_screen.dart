import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/i18n/app_localizations.dart';
import '../view_models/auth_provider.dart';
import '../../../core/view_models/theme_provider.dart';
import '../../../core/view_models/locale_provider.dart';
import '../../../core/theme/asumi_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go('/dashboard');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(auth.error ?? '登录失败'),
        backgroundColor: AsumiTheme.rose500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    final locale = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F0724),
                    const Color(0xFF1E0A3C),
                    const Color(0xFF2D1B2E),
                  ]
                : [
                    AsumiTheme.cream,
                    AsumiTheme.ivory,
                    const Color(0xFFF0EAE6),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: AuthCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Language Pills
                        _LanguagePills(locale: locale),
                        const SizedBox(height: 24),

                        // Logo
                        _Logo(),
                        const SizedBox(height: 16),

                        // Welcome text
                        Text(
                          t.welcomeBack,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 32),

                        // Username field
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: t.username,
                            prefixIcon: const Icon(Icons.person_outline, color: AsumiTheme.rose),
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? '请输入用户名' : null,
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: t.password,
                            prefixIcon: const Icon(Icons.lock_outline, color: AsumiTheme.rose),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AsumiTheme.lavender,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? '请输入密码' : null,
                        ),
                        const SizedBox(height: 8),

                        // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.go('/forgot-password'),
                              child: Text(
                              t.forgotPassword,
                              style: TextStyle(
                                color: AsumiTheme.rose,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _handleLogin,
                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.login, size: 20),
                                      const SizedBox(width: 8),
                                      Text(t.login),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Register link + theme toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${t.noAccount} ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                GestureDetector(
                                  onTap: () => context.go('/register'),
                                  child: Text(
                                    t.register,
                                    style: const TextStyle(
                                      color: AsumiTheme.rose,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Theme toggle
                            GestureDetector(
                              onTap: () => themeProvider.toggle(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : AsumiTheme.rose.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  isDark ? Icons.dark_mode : Icons.light_mode,
                                  size: 20,
                                  color: isDark ? AsumiTheme.roseLight : AsumiTheme.rose,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguagePills extends StatelessWidget {
  final LocaleProvider locale;

  const _LanguagePills({required this.locale});

  @override
  Widget build(BuildContext context) {
    final languages = [
      ('中文', 'zh'),
      ('日本語', 'ja'),
      ('English', 'en'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: languages.map((lang) {
        final active = locale.languageCode == lang.$2;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => locale.setLanguage(lang.$2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AsumiTheme.rose.withValues(alpha: 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? AsumiTheme.rose : AsumiTheme.lavender.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                lang.$1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  color: active ? AsumiTheme.rose : null,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AsumiTheme.rose,
        boxShadow: [
          BoxShadow(
            color: AsumiTheme.rose.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '錦',
          style: TextStyle(
            fontFamily: AsumiTheme.displayFont,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFF2D1B2E) : Colors.white,
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E0A3C).withValues(alpha: 0.75)
            : Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AsumiTheme.lavender.withValues(alpha: 0.15)
              : AsumiTheme.roseLight.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
