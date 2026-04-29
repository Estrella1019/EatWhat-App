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
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'吃啥APP'**
  String get appTitle;

  /// No description provided for @todayEatWhat.
  ///
  /// In zh, this message translates to:
  /// **'今天吃什么？'**
  String get todayEatWhat;

  /// No description provided for @myFridge.
  ///
  /// In zh, this message translates to:
  /// **'我的冰箱'**
  String get myFridge;

  /// No description provided for @profile.
  ///
  /// In zh, this message translates to:
  /// **'个人档案'**
  String get profile;

  /// No description provided for @profileTitle.
  ///
  /// In zh, this message translates to:
  /// **'个人档案'**
  String get profileTitle;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get confirm;

  /// No description provided for @manageProfiles.
  ///
  /// In zh, this message translates to:
  /// **'管理个人档案'**
  String get manageProfiles;

  /// No description provided for @addFamilyFriends.
  ///
  /// In zh, this message translates to:
  /// **'添加家人和朋友的档案'**
  String get addFamilyFriends;

  /// No description provided for @username.
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名'**
  String get enterUsername;

  /// No description provided for @allergens.
  ///
  /// In zh, this message translates to:
  /// **'过敏原'**
  String get allergens;

  /// No description provided for @selectOrAddAllergens.
  ///
  /// In zh, this message translates to:
  /// **'选择或添加你的过敏食材'**
  String get selectOrAddAllergens;

  /// No description provided for @customAllergen.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get customAllergen;

  /// No description provided for @customAllergens.
  ///
  /// In zh, this message translates to:
  /// **'自定义过敏源：'**
  String get customAllergens;

  /// No description provided for @addCustomAllergen.
  ///
  /// In zh, this message translates to:
  /// **'添加自定义过敏源'**
  String get addCustomAllergen;

  /// No description provided for @enterAllergenName.
  ///
  /// In zh, this message translates to:
  /// **'请输入过敏源名称'**
  String get enterAllergenName;

  /// No description provided for @allergenAdded.
  ///
  /// In zh, this message translates to:
  /// **'已添加过敏源: {name}'**
  String allergenAdded(Object name);

  /// No description provided for @tastePreferences.
  ///
  /// In zh, this message translates to:
  /// **'口味偏好'**
  String get tastePreferences;

  /// No description provided for @multipleChoice.
  ///
  /// In zh, this message translates to:
  /// **'可多选'**
  String get multipleChoice;

  /// No description provided for @defaultServings.
  ///
  /// In zh, this message translates to:
  /// **'默认就餐人数'**
  String get defaultServings;

  /// No description provided for @people.
  ///
  /// In zh, this message translates to:
  /// **'人'**
  String get people;

  /// No description provided for @languageSettings.
  ///
  /// In zh, this message translates to:
  /// **'语言设置'**
  String get languageSettings;

  /// No description provided for @followSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get followSystem;

  /// No description provided for @simplifiedChinese.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// No description provided for @traditionalChinese.
  ///
  /// In zh, this message translates to:
  /// **'繁體中文'**
  String get traditionalChinese;

  /// No description provided for @english.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @languageSwitched.
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

  /// No description provided for @pantryTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的冰箱'**
  String get pantryTitle;

  /// No description provided for @ingredientCount.
  ///
  /// In zh, this message translates to:
  /// **'{count} 种食材'**
  String ingredientCount(Object count);

  /// No description provided for @addIngredient.
  ///
  /// In zh, this message translates to:
  /// **'添加食材'**
  String get addIngredient;

  /// No description provided for @scanIngredient.
  ///
  /// In zh, this message translates to:
  /// **'扫描食材'**
  String get scanIngredient;

  /// No description provided for @emptyPantry.
  ///
  /// In zh, this message translates to:
  /// **'冰箱空空如也'**
  String get emptyPantry;

  /// No description provided for @addIngredientsToStart.
  ///
  /// In zh, this message translates to:
  /// **'添加食材开始使用吧'**
  String get addIngredientsToStart;

  /// No description provided for @generateRecipe.
  ///
  /// In zh, this message translates to:
  /// **'生成食谱'**
  String get generateRecipe;

  /// No description provided for @generating.
  ///
  /// In zh, this message translates to:
  /// **'生成中...'**
  String get generating;

  /// No description provided for @recipeRecommendation.
  ///
  /// In zh, this message translates to:
  /// **'食谱推荐'**
  String get recipeRecommendation;

  /// No description provided for @searchRecipesIngredients.
  ///
  /// In zh, this message translates to:
  /// **'搜索食谱、食材...'**
  String get searchRecipesIngredients;

  /// No description provided for @smartARScan.
  ///
  /// In zh, this message translates to:
  /// **'智能AR扫描'**
  String get smartARScan;

  /// No description provided for @startScan.
  ///
  /// In zh, this message translates to:
  /// **'开始扫描'**
  String get startScan;

  /// No description provided for @realtimeRecognition.
  ///
  /// In zh, this message translates to:
  /// **'实时识别食材，一键生成食谱'**
  String get realtimeRecognition;

  /// No description provided for @quickStart.
  ///
  /// In zh, this message translates to:
  /// **'快速开始，发现美味...'**
  String get quickStart;

  /// No description provided for @photoRecognition.
  ///
  /// In zh, this message translates to:
  /// **'相册识别'**
  String get photoRecognition;

  /// No description provided for @recognizeFromPhoto.
  ///
  /// In zh, this message translates to:
  /// **'从照片识别食材'**
  String get recognizeFromPhoto;

  /// No description provided for @weightEstimation.
  ///
  /// In zh, this message translates to:
  /// **'重量估算'**
  String get weightEstimation;

  /// No description provided for @smartPortionRecognition.
  ///
  /// In zh, this message translates to:
  /// **'智能份量识别'**
  String get smartPortionRecognition;

  /// No description provided for @todayTrending.
  ///
  /// In zh, this message translates to:
  /// **'今日热门'**
  String get todayTrending;

  /// No description provided for @viewMore.
  ///
  /// In zh, this message translates to:
  /// **'查看更多'**
  String get viewMore;

  /// No description provided for @viewAll.
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get viewAll;

  /// No description provided for @moreItems.
  ///
  /// In zh, this message translates to:
  /// **'还有 {count} 种...'**
  String moreItems(Object count);

  /// No description provided for @cookWithThese.
  ///
  /// In zh, this message translates to:
  /// **'用这些食材做菜'**
  String get cookWithThese;

  /// No description provided for @generatingRecipe.
  ///
  /// In zh, this message translates to:
  /// **'正在生成食谱...'**
  String get generatingRecipe;

  /// No description provided for @historyTitle.
  ///
  /// In zh, this message translates to:
  /// **'历史记录'**
  String get historyTitle;

  /// No description provided for @historySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'记录你的每一次美食探索，方便随时回顾。'**
  String get historySubtitle;

  /// No description provided for @emptyHistoryTitle.
  ///
  /// In zh, this message translates to:
  /// **'还没有记录'**
  String get emptyHistoryTitle;

  /// No description provided for @emptyHistorySubtitle.
  ///
  /// In zh, this message translates to:
  /// **'开始扫描食材或生成食谱吧'**
  String get emptyHistorySubtitle;

  /// No description provided for @historyDeleted.
  ///
  /// In zh, this message translates to:
  /// **'已删除'**
  String get historyDeleted;

  /// No description provided for @clearHistoryTitle.
  ///
  /// In zh, this message translates to:
  /// **'清空历史'**
  String get clearHistoryTitle;

  /// No description provided for @clearHistoryMessage.
  ///
  /// In zh, this message translates to:
  /// **'确定要清空所有历史记录吗？此操作不可撤销。'**
  String get clearHistoryMessage;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get clearHistoryConfirm;

  /// No description provided for @favorites.
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get favorites;

  /// No description provided for @history.
  ///
  /// In zh, this message translates to:
  /// **'历史'**
  String get history;

  /// No description provided for @myProfile.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get myProfile;

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @currentInventory.
  ///
  /// In zh, this message translates to:
  /// **'当前库存'**
  String get currentInventory;

  /// No description provided for @categories.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个分类'**
  String categories(Object count);

  /// No description provided for @useARToAdd.
  ///
  /// In zh, this message translates to:
  /// **'使用AR扫描添加食材'**
  String get useARToAdd;

  /// No description provided for @kcal.
  ///
  /// In zh, this message translates to:
  /// **'{count} 千卡'**
  String kcal(Object count);

  /// No description provided for @minutes.
  ///
  /// In zh, this message translates to:
  /// **'{count} 分钟'**
  String minutes(Object count);

  /// No description provided for @pantryEmptyHint.
  ///
  /// In zh, this message translates to:
  /// **'冰箱空空如也'**
  String get pantryEmptyHint;

  /// No description provided for @items.
  ///
  /// In zh, this message translates to:
  /// **'{count} 种食材'**
  String items(Object count);

  /// No description provided for @confirmLogout.
  ///
  /// In zh, this message translates to:
  /// **'确认登出'**
  String get confirmLogout;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In zh, this message translates to:
  /// **'确定要退出登录吗？'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutButton.
  ///
  /// In zh, this message translates to:
  /// **'登出'**
  String get logoutButton;

  /// No description provided for @enterAllergenHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：芝麻'**
  String get enterAllergenHint;

  /// No description provided for @profileUpdated.
  ///
  /// In zh, this message translates to:
  /// **'个人档案已更新'**
  String get profileUpdated;

  /// No description provided for @updateProfile.
  ///
  /// In zh, this message translates to:
  /// **'更新档案'**
  String get updateProfile;

  /// No description provided for @editProfile.
  ///
  /// In zh, this message translates to:
  /// **'编辑档案'**
  String get editProfile;

  /// No description provided for @addProfile.
  ///
  /// In zh, this message translates to:
  /// **'添加档案'**
  String get addProfile;

  /// No description provided for @profileManagement.
  ///
  /// In zh, this message translates to:
  /// **'档案管理'**
  String get profileManagement;

  /// No description provided for @preferences.
  ///
  /// In zh, this message translates to:
  /// **'偏好设置'**
  String get preferences;

  /// No description provided for @enterYourUsername.
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名'**
  String get enterYourUsername;

  /// No description provided for @allergyFilters.
  ///
  /// In zh, this message translates to:
  /// **'过敏原筛选'**
  String get allergyFilters;

  /// No description provided for @servings.
  ///
  /// In zh, this message translates to:
  /// **'就餐人数'**
  String get servings;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言设置'**
  String get language;

  /// No description provided for @savedRecipes.
  ///
  /// In zh, this message translates to:
  /// **'收藏食谱'**
  String get savedRecipes;

  /// No description provided for @cookedThisWeek.
  ///
  /// In zh, this message translates to:
  /// **'本周烹饪'**
  String get cookedThisWeek;

  /// No description provided for @premiumMember.
  ///
  /// In zh, this message translates to:
  /// **'高级会员'**
  String get premiumMember;

  /// No description provided for @yourName.
  ///
  /// In zh, this message translates to:
  /// **'你的名字'**
  String get yourName;

  /// No description provided for @myFavorites.
  ///
  /// In zh, this message translates to:
  /// **'我的收藏'**
  String get myFavorites;

  /// No description provided for @loginRegister.
  ///
  /// In zh, this message translates to:
  /// **'登录 / 注册'**
  String get loginRegister;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'登出'**
  String get logout;

  /// No description provided for @account.
  ///
  /// In zh, this message translates to:
  /// **'账户'**
  String get account;

  /// No description provided for @userSettings.
  ///
  /// In zh, this message translates to:
  /// **'用户设置'**
  String get userSettings;

  /// No description provided for @recommendedRecipes.
  ///
  /// In zh, this message translates to:
  /// **'推荐菜谱'**
  String get recommendedRecipes;

  /// No description provided for @noRecipes.
  ///
  /// In zh, this message translates to:
  /// **'暂无菜谱'**
  String get noRecipes;

  /// No description provided for @goBack.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get goBack;

  /// No description provided for @favoritesPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的收藏'**
  String get favoritesPageTitle;

  /// No description provided for @favoritesSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'收藏你最喜欢的菜谱，方便随时回来看。'**
  String get favoritesSubtitle;

  /// No description provided for @favoritesRemoved.
  ///
  /// In zh, this message translates to:
  /// **'已取消收藏'**
  String get favoritesRemoved;

  /// No description provided for @removeFavoriteTitle.
  ///
  /// In zh, this message translates to:
  /// **'移除收藏'**
  String get removeFavoriteTitle;

  /// No description provided for @removeFavoriteMessage.
  ///
  /// In zh, this message translates to:
  /// **'确定要把这道菜从收藏中移除吗？'**
  String get removeFavoriteMessage;

  /// No description provided for @remove.
  ///
  /// In zh, this message translates to:
  /// **'移除'**
  String get remove;

  /// No description provided for @emptyFavoritesTitle.
  ///
  /// In zh, this message translates to:
  /// **'还没有收藏'**
  String get emptyFavoritesTitle;

  /// No description provided for @emptyFavoritesSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'去收藏你喜欢的菜谱吧'**
  String get emptyFavoritesSubtitle;

  /// No description provided for @deleteFailed.
  ///
  /// In zh, this message translates to:
  /// **'删除失败'**
  String get deleteFailed;

  /// No description provided for @retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先登录'**
  String get pleaseLoginFirst;

  /// No description provided for @favoriteAdded.
  ///
  /// In zh, this message translates to:
  /// **'收藏成功'**
  String get favoriteAdded;

  /// No description provided for @favoriteAddFailed.
  ///
  /// In zh, this message translates to:
  /// **'收藏失败: {error}'**
  String favoriteAddFailed(Object error);

  /// No description provided for @weightDemo.
  ///
  /// In zh, this message translates to:
  /// **'智能重量估算演示'**
  String get weightDemo;

  /// No description provided for @skipAll.
  ///
  /// In zh, this message translates to:
  /// **'全部跳过'**
  String get skipAll;

  /// No description provided for @skipConfirm.
  ///
  /// In zh, this message translates to:
  /// **'跳过确认'**
  String get skipConfirm;

  /// No description provided for @skipAllMessage.
  ///
  /// In zh, this message translates to:
  /// **'确定要跳过所有未添加的食材吗？'**
  String get skipAllMessage;

  /// No description provided for @confirmPortion.
  ///
  /// In zh, this message translates to:
  /// **'确认食材份量'**
  String get confirmPortion;

  /// No description provided for @addToFridge.
  ///
  /// In zh, this message translates to:
  /// **'存入冰箱'**
  String get addToFridge;

  /// No description provided for @generateRecipes.
  ///
  /// In zh, this message translates to:
  /// **'生成菜谱'**
  String get generateRecipes;

  /// No description provided for @ingredientsAdded.
  ///
  /// In zh, this message translates to:
  /// **'已添加 {count} 种食材到冰箱'**
  String ingredientsAdded(Object count);

  /// No description provided for @generatingRecipes.
  ///
  /// In zh, this message translates to:
  /// **'正在生成食谱...'**
  String get generatingRecipes;

  /// No description provided for @enterNickname.
  ///
  /// In zh, this message translates to:
  /// **'请输入昵称'**
  String get enterNickname;

  /// No description provided for @switchedTo.
  ///
  /// In zh, this message translates to:
  /// **'已切换到 {name}'**
  String switchedTo(Object name);

  /// No description provided for @yoloComplete.
  ///
  /// In zh, this message translates to:
  /// **'YOLO识别完成'**
  String get yoloComplete;

  /// No description provided for @addedToFridge.
  ///
  /// In zh, this message translates to:
  /// **'{name} 已添加到冰箱'**
  String addedToFridge(Object name);

  /// No description provided for @viewFridge.
  ///
  /// In zh, this message translates to:
  /// **'查看冰箱'**
  String get viewFridge;

  /// No description provided for @doneCount.
  ///
  /// In zh, this message translates to:
  /// **'完成 ({count})'**
  String doneCount(Object count);

  /// No description provided for @addedCountOf.
  ///
  /// In zh, this message translates to:
  /// **'已添加 {count}/{total} 种食材'**
  String addedCountOf(Object count, Object total);

  /// No description provided for @selectImageToRecognize.
  ///
  /// In zh, this message translates to:
  /// **'请选择图片进行识别'**
  String get selectImageToRecognize;

  /// No description provided for @reselectImage.
  ///
  /// In zh, this message translates to:
  /// **'重新选图'**
  String get reselectImage;

  /// No description provided for @yoloRecognizing.
  ///
  /// In zh, this message translates to:
  /// **'YOLO识别中...'**
  String get yoloRecognizing;

  /// No description provided for @callingBackend.
  ///
  /// In zh, this message translates to:
  /// **'正在调用后端识别食材'**
  String get callingBackend;

  /// No description provided for @detectedItems.
  ///
  /// In zh, this message translates to:
  /// **'已识别到 {count} 种食材'**
  String detectedItems(Object count);

  /// No description provided for @skip.
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get skip;

  /// No description provided for @generationFailed.
  ///
  /// In zh, this message translates to:
  /// **'生成失败: {error}'**
  String generationFailed(Object error);

  /// No description provided for @profileIdentity.
  ///
  /// In zh, this message translates to:
  /// **'档案身份'**
  String get profileIdentity;

  /// No description provided for @nickname.
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get nickname;

  /// No description provided for @nicknamePlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'大厨'**
  String get nicknamePlaceholder;

  /// No description provided for @relationship.
  ///
  /// In zh, this message translates to:
  /// **'关系'**
  String get relationship;

  /// No description provided for @gender.
  ///
  /// In zh, this message translates to:
  /// **'性别'**
  String get gender;

  /// No description provided for @birthday.
  ///
  /// In zh, this message translates to:
  /// **'生日'**
  String get birthday;

  /// No description provided for @selectBirthday.
  ///
  /// In zh, this message translates to:
  /// **'选择生日'**
  String get selectBirthday;

  /// No description provided for @foodAllergies.
  ///
  /// In zh, this message translates to:
  /// **'食物过敏'**
  String get foodAllergies;

  /// No description provided for @noAllergiesYet.
  ///
  /// In zh, this message translates to:
  /// **'还没有添加过敏原'**
  String get noAllergiesYet;

  /// No description provided for @tapToRemoveAllergy.
  ///
  /// In zh, this message translates to:
  /// **'点击过敏原标签即可从档案中移除。'**
  String get tapToRemoveAllergy;

  /// No description provided for @saveChanges.
  ///
  /// In zh, this message translates to:
  /// **'保存更改'**
  String get saveChanges;

  /// No description provided for @deleteProfile.
  ///
  /// In zh, this message translates to:
  /// **'删除档案'**
  String get deleteProfile;

  /// No description provided for @deleteProfileConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这个档案吗？'**
  String get deleteProfileConfirm;

  /// No description provided for @addAllergy.
  ///
  /// In zh, this message translates to:
  /// **'添加过敏原'**
  String get addAllergy;

  /// No description provided for @enterAllergenExample.
  ///
  /// In zh, this message translates to:
  /// **'例如：麸质、大豆...'**
  String get enterAllergenExample;

  /// No description provided for @addItem.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get addItem;

  /// No description provided for @self.
  ///
  /// In zh, this message translates to:
  /// **'本人'**
  String get self;

  /// No description provided for @spouse.
  ///
  /// In zh, this message translates to:
  /// **'配偶'**
  String get spouse;

  /// No description provided for @child.
  ///
  /// In zh, this message translates to:
  /// **'子女'**
  String get child;

  /// No description provided for @friend.
  ///
  /// In zh, this message translates to:
  /// **'朋友'**
  String get friend;

  /// No description provided for @male.
  ///
  /// In zh, this message translates to:
  /// **'男'**
  String get male;

  /// No description provided for @female.
  ///
  /// In zh, this message translates to:
  /// **'女'**
  String get female;

  /// No description provided for @nonBinary.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get nonBinary;
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
