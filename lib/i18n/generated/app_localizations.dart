import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of GenLocalizations
/// returned by `GenLocalizations.of(context)`.
///
/// Applications need to include `GenLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GenLocalizations.localizationsDelegates,
///   supportedLocales: GenLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the GenLocalizations.supportedLocales
/// property.
abstract class GenLocalizations {
  GenLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GenLocalizations? of(BuildContext context) {
    return Localizations.of<GenLocalizations>(context, GenLocalizations);
  }

  static const LocalizationsDelegate<GenLocalizations> delegate =
      _GenLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh')
  ];

  /// No description provided for @login.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get login;

  /// No description provided for @register.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get register;

  /// No description provided for @forgotPassword.
  ///
  /// In zh, this message translates to:
  /// **'忘记密码'**
  String get forgotPassword;

  /// No description provided for @username.
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get username;

  /// No description provided for @email.
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get email;

  /// No description provided for @password.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In zh, this message translates to:
  /// **'确认密码'**
  String get confirmPassword;

  /// No description provided for @passwordHint.
  ///
  /// In zh, this message translates to:
  /// **'密码至少6位，需包含英文字母和数字'**
  String get passwordHint;

  /// No description provided for @sendResetLink.
  ///
  /// In zh, this message translates to:
  /// **'发送重置链接'**
  String get sendResetLink;

  /// No description provided for @welcomeBack.
  ///
  /// In zh, this message translates to:
  /// **'欢迎回来'**
  String get welcomeBack;

  /// No description provided for @noAccount.
  ///
  /// In zh, this message translates to:
  /// **'还没有账号？'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In zh, this message translates to:
  /// **'已有账号？'**
  String get hasAccount;

  /// No description provided for @backToLogin.
  ///
  /// In zh, this message translates to:
  /// **'返回登录'**
  String get backToLogin;

  /// No description provided for @registerNow.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get registerNow;

  /// No description provided for @loginNow.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get loginNow;

  /// No description provided for @dashboardTitle.
  ///
  /// In zh, this message translates to:
  /// **'锦亚澄'**
  String get dashboardTitle;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要退出当前账号吗？'**
  String get logoutConfirm;

  /// No description provided for @addImage.
  ///
  /// In zh, this message translates to:
  /// **'添加图片'**
  String get addImage;

  /// No description provided for @all.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @gallery.
  ///
  /// In zh, this message translates to:
  /// **'画廊'**
  String get gallery;

  /// No description provided for @createCollection.
  ///
  /// In zh, this message translates to:
  /// **'新建收藏栏'**
  String get createCollection;

  /// No description provided for @collectionName.
  ///
  /// In zh, this message translates to:
  /// **'收藏栏名称'**
  String get collectionName;

  /// No description provided for @noCategory.
  ///
  /// In zh, this message translates to:
  /// **'不归类'**
  String get noCategory;

  /// No description provided for @deleteConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定删除这张图片？'**
  String get deleteConfirm;

  /// No description provided for @setAsAvatar.
  ///
  /// In zh, this message translates to:
  /// **'设为头像'**
  String get setAsAvatar;

  /// No description provided for @clearAvatar.
  ///
  /// In zh, this message translates to:
  /// **'清除头像'**
  String get clearAvatar;

  /// No description provided for @changeAvatar.
  ///
  /// In zh, this message translates to:
  /// **'更换头像'**
  String get changeAvatar;

  /// No description provided for @uploading.
  ///
  /// In zh, this message translates to:
  /// **'上传中…'**
  String get uploading;

  /// No description provided for @greetingMorning.
  ///
  /// In zh, this message translates to:
  /// **'早上好'**
  String get greetingMorning;

  /// No description provided for @greetingNoon.
  ///
  /// In zh, this message translates to:
  /// **'中午好'**
  String get greetingNoon;

  /// No description provided for @greetingAfternoon.
  ///
  /// In zh, this message translates to:
  /// **'下午好'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In zh, this message translates to:
  /// **'晚上好'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In zh, this message translates to:
  /// **'夜深了'**
  String get greetingNight;

  /// No description provided for @commonCreate.
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get commonCreate;

  /// No description provided for @commonCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get commonConfirm;

  /// No description provided for @commonError.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get commonError;

  /// No description provided for @commonSuccess.
  ///
  /// In zh, this message translates to:
  /// **'成功'**
  String get commonSuccess;

  /// No description provided for @commonLoading.
  ///
  /// In zh, this message translates to:
  /// **'加载中…'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get commonRetry;

  /// No description provided for @labelAsumi.
  ///
  /// In zh, this message translates to:
  /// **'锦亚澄'**
  String get labelAsumi;

  /// No description provided for @labelAsumiCg.
  ///
  /// In zh, this message translates to:
  /// **'锦亚澄 CG'**
  String get labelAsumiCg;

  /// No description provided for @labelSister.
  ///
  /// In zh, this message translates to:
  /// **'妹妹'**
  String get labelSister;

  /// No description provided for @labelSisterCg.
  ///
  /// In zh, this message translates to:
  /// **'妹妹 CG'**
  String get labelSisterCg;

  /// No description provided for @labelHibikiAi.
  ///
  /// In zh, this message translates to:
  /// **'妃爱'**
  String get labelHibikiAi;

  /// No description provided for @msgResetSent.
  ///
  /// In zh, this message translates to:
  /// **'重置链接已发送到你的邮箱'**
  String get msgResetSent;

  /// No description provided for @msgRegisterSuccess.
  ///
  /// In zh, this message translates to:
  /// **'注册成功！即将跳转到登录页面'**
  String get msgRegisterSuccess;

  /// No description provided for @msgNetworkError.
  ///
  /// In zh, this message translates to:
  /// **'网络连接失败，请检查网络'**
  String get msgNetworkError;
}

class _GenLocalizationsDelegate
    extends LocalizationsDelegate<GenLocalizations> {
  const _GenLocalizationsDelegate();

  @override
  Future<GenLocalizations> load(Locale locale) {
    return SynchronousFuture<GenLocalizations>(lookupGenLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_GenLocalizationsDelegate old) => false;
}

GenLocalizations lookupGenLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return GenLocalizationsEn();
    case 'ja':
      return GenLocalizationsJa();
    case 'zh':
      return GenLocalizationsZh();
  }

  throw FlutterError(
      'GenLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
