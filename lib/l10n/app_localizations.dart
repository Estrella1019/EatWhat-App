import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// 应用标题
  ///
  /// In zh, this message translates to:
  /// **'吃啥APP'**
  String get appTitle;

  /// 首页标题
  ///
  /// In zh, this message translates to:
  /// **'今天吃什么？'**
  String get todayEatWhat;

  /// 冰箱标签
  ///
  /// In zh, this message translates to:
  /// **'我的冰箱'**
  String get myFridge;

  /// 个人档案标签
  ///
  /// In zh, this message translates to:
  /// **'个人档案'**
  String get profile;

  /// 个人档案页面标题
  ///
  /// In zh, this message translates to:
  /// **'个人档案'**
  String get profileTitle;

  /// 保存按钮
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// 取消按钮
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// 添加按钮
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// 删除按钮
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// 编辑按钮
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// 确认按钮
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// 管理档案标题
  ///
  /// In zh, this message translates to:
  /// **'管理个人档案'**
  String get manageProfiles;

  /// 管理档案副标题
  ///
  /// In zh, this message translates to:
  /// **'添加家人和朋友的档案'**
  String get addFamilyFriends;

  /// 用户名标签
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get username;

  /// 用户名输入提示
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名'**
  String get enterUsername;

  /// 过敏原标签
  ///
  /// In zh, this message translates to:
  /// **'过敏原'**
  String get allergens;

  /// 过敏原副标题
  ///
  /// In zh, this message translates to:
  /// **'选择或添加你的过敏食材'**
  String get selectOrAddAllergens;

  /// 自定义过敏原按钮
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get customAllergen;

  /// 自定义过敏原列表标题
  ///
  /// In zh, this message translates to:
  /// **'自定义过敏源：'**
  String get customAllergens;

  /// 添加自定义过敏原对话框标题
  ///
  /// In zh, this message translates to:
  /// **'添加自定义过敏源'**
  String get addCustomAllergen;

  /// 过敏原名称输入提示
  ///
  /// In zh, this message translates to:
  /// **'请输入过敏源名称'**
  String get enterAllergenName;

  /// 过敏原添加成功提示
  ///
  /// In zh, this message translates to:
  /// **'已添加过敏源: {name}'**
  String allergenAdded(String name);

  /// 口味偏好标签
  ///
  /// In zh, this message translates to:
  /// **'口味偏好'**
  String get tastePreferences;

  /// 多选提示
  ///
  /// In zh, this message translates to:
  /// **'可多选'**
  String get multipleChoice;

  /// 就餐人数标签
  ///
  /// In zh, this message translates to:
  /// **'默认就餐人数'**
  String get defaultServings;

  /// 人数单位
  ///
  /// In zh, this message translates to:
  /// **'人'**
  String get people;

  /// 语言设置标签
  ///
  /// In zh, this message translates to:
  /// **'语言设置'**
  String get languageSettings;

  /// 跟随系统语言选项
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get followSystem;

  /// 简体中文选项
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// 繁体中文选项
  ///
  /// In zh, this message translates to:
  /// **'繁体中文'**
  String get traditionalChinese;

  /// 英文选项
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get english;

  /// 语言切换成功提示
  ///
  /// In zh, this message translates to:
  /// **'语言已切换'**
  String get languageSwitched;

  /// No description provided for @peanut.
  ///
  /// In zh, this message translates to:
  /// **'花生'**
  String get peanut;

  /// No description provided for @seafood.
  ///
  /// In zh, this message translates to:
  /// **'海鲜'**
  String get seafood;

  /// No description provided for @milk.
  ///
  /// In zh, this message translates to:
  /// **'牛奶'**
  String get milk;

  /// No description provided for @egg.
  ///
  /// In zh, this message translates to:
  /// **'鸡蛋'**
  String get egg;

  /// No description provided for @soybean.
  ///
  /// In zh, this message translates to:
  /// **'大豆'**
  String get soybean;

  /// No description provided for @wheat.
  ///
  /// In zh, this message translates to:
  /// **'小麦'**
  String get wheat;

  /// No description provided for @nuts.
  ///
  /// In zh, this message translates to:
  /// **'坚果'**
  String get nuts;

  /// No description provided for @sesame.
  ///
  /// In zh, this message translates to:
  /// **'芝麻'**
  String get sesame;

  /// No description provided for @mild.
  ///
  /// In zh, this message translates to:
  /// **'清淡'**
  String get mild;

  /// No description provided for @heavy.
  ///
  /// In zh, this message translates to:
  /// **'重口味'**
  String get heavy;

  /// No description provided for @mildlySpicy.
  ///
  /// In zh, this message translates to:
  /// **'微辣'**
  String get mildlySpicy;

  /// No description provided for @mediumSpicy.
  ///
  /// In zh, this message translates to:
  /// **'中辣'**
  String get mediumSpicy;

  /// No description provided for @verySpicy.
  ///
  /// In zh, this message translates to:
  /// **'特辣'**
  String get verySpicy;

  /// No description provided for @sweet.
  ///
  /// In zh, this message translates to:
  /// **'甜味'**
  String get sweet;

  /// No description provided for @sour.
  ///
  /// In zh, this message translates to:
  /// **'酸味'**
  String get sour;

  /// 冰箱页面标题
  ///
  /// In zh, this message translates to:
  /// **'我的冰箱'**
  String get pantryTitle;

  /// 食材数量
  ///
  /// In zh, this message translates to:
  /// **'{count} 种食材'**
  String ingredientCount(int count);

  /// 添加食材按钮
  ///
  /// In zh, this message translates to:
  /// **'添加食材'**
  String get addIngredient;

  /// 扫描食材按钮
  ///
  /// In zh, this message translates to:
  /// **'扫描食材'**
  String get scanIngredient;

  /// 空冰箱提示
  ///
  /// In zh, this message translates to:
  /// **'冰箱空空如也'**
  String get emptyPantry;

  /// 空冰箱副标题
  ///
  /// In zh, this message translates to:
  /// **'添加食材开始使用吧'**
  String get addIngredientsToStart;

  /// 生成食谱按钮
  ///
  /// In zh, this message translates to:
  /// **'生成食谱'**
  String get generateRecipe;

  /// 生成中提示
  ///
  /// In zh, this message translates to:
  /// **'生成中...'**
  String get generating;

  /// 食谱推荐标题
  ///
  /// In zh, this message translates to:
  /// **'食谱推荐'**
  String get recipeRecommendation;

  /// 搜索框提示
  ///
  /// In zh, this message translates to:
  /// **'搜索食谱、食材...'**
  String get searchRecipesIngredients;

  /// AR扫描标题
  ///
  /// In zh, this message translates to:
  /// **'智能AR扫描'**
  String get smartARScan;

  /// 开始扫描按钮
  ///
  /// In zh, this message translates to:
  /// **'开始扫描'**
  String get startScan;

  /// AR扫描描述
  ///
  /// In zh, this message translates to:
  /// **'实时识别食材，一键生成食谱'**
  String get realtimeRecognition;

  /// 快速开始标题
  ///
  /// In zh, this message translates to:
  /// **'快速开始，发现美味...'**
  String get quickStart;

  /// 相册识别标题
  ///
  /// In zh, this message translates to:
  /// **'相册识别'**
  String get photoRecognition;

  /// 相册识别描述
  ///
  /// In zh, this message translates to:
  /// **'从照片识别食材'**
  String get recognizeFromPhoto;

  /// 重量估算标题
  ///
  /// In zh, this message translates to:
  /// **'重量估算'**
  String get weightEstimation;

  /// 重量估算描述
  ///
  /// In zh, this message translates to:
  /// **'智能份量识别'**
  String get smartPortionRecognition;

  /// 今日热门标题
  ///
  /// In zh, this message translates to:
  /// **'今日热门'**
  String get todayTrending;

  /// 查看更多按钮
  ///
  /// In zh, this message translates to:
  /// **'查看更多'**
  String get viewMore;

  /// 查看全部按钮
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get viewAll;

  /// 更多项目提示
  ///
  /// In zh, this message translates to:
  /// **'还有 {count} 种...'**
  String moreItems(int count);

  /// 用食材做菜按钮
  ///
  /// In zh, this message translates to:
  /// **'用这些食材做菜'**
  String get cookWithThese;

  /// 生成食谱中提示
  ///
  /// In zh, this message translates to:
  /// **'正在生成食谱...'**
  String get generatingRecipe;

  /// 生成失败提示
  ///
  /// In zh, this message translates to:
  /// **'生成失败: {error}'**
  String generationFailed(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
