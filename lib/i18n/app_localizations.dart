import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _strings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<void> load() async {
    final langCode = locale.languageCode;
    final jsonString = await rootBundle.loadString(
      'assets/i18n/$langCode.json',
    );
    _strings = json.decode(jsonString) as Map<String, dynamic>;
  }

  String get(String key, {List<String>? args}) {
    final keys = key.split('.');
    dynamic value = _strings;
    for (final k in keys) {
      value = (value as Map<String, dynamic>)[k];
      if (value == null) return key;
    }
    if (value is String) {
      if (args != null) {
        for (int i = 0; i < args.length; i++) {
          value = value.replaceAll('{$i}', args[i]);
        }
      }
      return value;
    }
    return key;
  }

  // Convenience getters
  String get login => get('auth.login');
  String get register => get('auth.register');
  String get forgotPassword => get('auth.forgotPassword');
  String get username => get('auth.username');
  String get email => get('auth.email');
  String get password => get('auth.password');
  String get confirmPassword => get('auth.confirmPassword');
  String get sendResetLink => get('auth.sendResetLink');
  String get welcomeBack => get('auth.welcomeBack');
  String get noAccount => get('auth.noAccount');
  String get hasAccount => get('auth.hasAccount');
  String get backToLogin => get('auth.backToLogin');

  String get logout => get('dashboard.logout');
  String get addImage => get('dashboard.addImage');
  String get createCollection => get('dashboard.createCollection');
  String get all => get('dashboard.all');
  String get gallery => get('dashboard.gallery');
  String get noCategory => get('dashboard.noCategory');
  String get deleteConfirm => get('dashboard.deleteConfirm');
  String get setAsAvatar => get('dashboard.setAsAvatar');
  String get clearAvatar => get('dashboard.clearAvatar');
  String get changeAvatar => get('dashboard.changeAvatar');
  String get uploading => get('dashboard.uploading');
  String get create => get('common.create');
  String get cancel => get('common.cancel');
  String get delete => get('common.delete');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['zh', 'ja', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
