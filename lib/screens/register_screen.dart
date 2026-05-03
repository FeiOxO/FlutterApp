import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/app_localizations.dart';
import '../providers/providers.dart';
import '../theme/asumi_theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).get('messages.registerSuccess')),
          backgroundColor: AsumiTheme.emerald400,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? '注册失败'),
          backgroundColor: AsumiTheme.rose500,
        ),
      );
    }
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return '请输入密码';
    if (v.length < 6) return '密码至少6位';
    if (!RegExp(r'[a-zA-Z]').hasMatch(v)) return '密码需包含英文字母';
    if (!RegExp(r'[0-9]').hasMatch(v)) return '密码需包含数字';
    return null;
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
                        // Language pills
                        _LanguagePills(locale: locale),
                        const SizedBox(height: 24),

                        // Logo
                        const _Logo(),
                        const SizedBox(height: 16),
                        Text(
                          t.register,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 32),

                        // Username
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: t.username,
                            prefixIcon: const Icon(Icons.person_outline, color: AsumiTheme.rose),
                          ),
                          validator: (v) =>
                              v == null || v.trim().length < 2 ? '用户名至少2个字符' : null,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: t.email,
                            prefixIcon: const Icon(Icons.email_outlined, color: AsumiTheme.rose),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return '请输入邮箱';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return '邮箱格式不正确';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
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
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 16),

                        // Confirm password
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          decoration: InputDecoration(
                            labelText: t.confirmPassword,
                            prefixIcon: const Icon(Icons.lock_outline, color: AsumiTheme.rose),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AsumiTheme.lavender,
                              ),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                          validator: (v) {
                            if (v != _passwordController.text) return '两次密码不一致';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Register button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _handleRegister,
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
                                      const Icon(Icons.person_add, size: 20),
                                      const SizedBox(width: 8),
                                      Text(t.register),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${t.hasAccount} ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                t.login,
                                style: const TextStyle(
                                  color: AsumiTheme.rose,
                                  fontWeight: FontWeight.w600,
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
  const _Logo();

  @override
  Widget build(BuildContext context) {
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
      child: const Center(
        child: Text(
          '錦',
          style: TextStyle(
            fontFamily: AsumiTheme.displayFont,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
