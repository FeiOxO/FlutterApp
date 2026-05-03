import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _strings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Material/Cupertino 系统本地化委托
  static List<LocalizationsDelegate<dynamic>> get systemDelegates => [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('zh'),
    Locale('ja'),
    Locale('en'),
  ];

  Future<void> load() async {
    final langCode = locale.languageCode;
    String jsonString;
    try {
      jsonString = await rootBundle.loadString(
        'assets/i18n/$langCode.json',
      );
    } catch (_) {
      jsonString = await rootBundle.loadString('assets/i18n/zh.json');
    }
    _strings = json.decode(jsonString) as Map<String, dynamic>;
  }

  String get(String key) {
    return _strings[key] as String? ?? key;
  }

  // ===== Convenience getters =====
  String get login => get('login');
  String get register => get('register');
  String get forgotPassword => get('forgotPassword');
  String get username => get('username');
  String get email => get('email');
  String get password => get('password');
  String get confirmPassword => get('confirmPassword');
  String get sendResetLink => get('sendResetLink');
  String get welcomeBack => get('welcomeBack');
  String get noAccount => get('noAccount');
  String get hasAccount => get('hasAccount');
  String get backToLogin => get('backToLogin');
  String get logout => get('logout');
  String get logoutConfirm => get('logoutConfirm');
  String get addImage => get('addImage');
  String get createCollection => get('createCollection');
  String get all => get('all');
  String get gallery => get('gallery');
  String get noCategory => get('noCategory');
  String get deleteConfirm => get('deleteConfirm');
  String get setAsAvatar => get('setAsAvatar');
  String get clearAvatar => get('clearAvatar');
  String get changeAvatar => get('changeAvatar');
  String get uploading => get('uploading');
  String get create => get('commonCreate');
  String get cancel => get('commonCancel');
  String get confirm => get('commonConfirm');
  String get delete => get('commonDelete');
  String get dashboardTitle => get('dashboardTitle');
  String get collectionName => get('collectionName');

  String get greetingMorning => get('greetingMorning');
  String get greetingNoon => get('greetingNoon');
  String get greetingAfternoon => get('greetingAfternoon');
  String get greetingEvening => get('greetingEvening');
  String get greetingNight => get('greetingNight');

  String get msgResetSent => get('msgResetSent');
  String get msgRegisterSuccess => get('msgRegisterSuccess');
  String get msgNetworkError => get('msgNetworkError');
  String get commonLoading => get('commonLoading');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['zh', 'ja', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
