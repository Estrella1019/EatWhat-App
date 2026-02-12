// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '吃啥APP';

  @override
  String get todayEatWhat => '今天吃什么？';

  @override
  String get myFridge => '我的冰箱';

  @override
  String get profile => '个人档案';

  @override
  String get profileTitle => '个人档案';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get add => '添加';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get confirm => '确认';

  @override
  String get manageProfiles => '管理个人档案';

  @override
  String get addFamilyFriends => '添加家人和朋友的档案';

  @override
  String get username => '用户名';

  @override
  String get enterUsername => '请输入用户名';

  @override
  String get allergens => '过敏原';

  @override
  String get selectOrAddAllergens => '选择或添加你的过敏食材';

  @override
  String get customAllergen => '自定义';

  @override
  String get customAllergens => '自定义过敏源：';

  @override
  String get addCustomAllergen => '添加自定义过敏源';

  @override
  String get enterAllergenName => '请输入过敏源名称';

  @override
  String allergenAdded(String name) {
    return '已添加过敏源: $name';
  }

  @override
  String get tastePreferences => '口味偏好';

  @override
  String get multipleChoice => '可多选';

  @override
  String get defaultServings => '默认就餐人数';

  @override
  String get people => '人';

  @override
  String get languageSettings => '语言设置';

  @override
  String get followSystem => '跟随系统';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁体中文';

  @override
  String get english => 'English';

  @override
  String get languageSwitched => '语言已切换';

  @override
  String get peanut => '花生';

  @override
  String get seafood => '海鲜';

  @override
  String get milk => '牛奶';

  @override
  String get egg => '鸡蛋';

  @override
  String get soybean => '大豆';

  @override
  String get wheat => '小麦';

  @override
  String get nuts => '坚果';

  @override
  String get sesame => '芝麻';

  @override
  String get mild => '清淡';

  @override
  String get heavy => '重口味';

  @override
  String get mildlySpicy => '微辣';

  @override
  String get mediumSpicy => '中辣';

  @override
  String get verySpicy => '特辣';

  @override
  String get sweet => '甜味';

  @override
  String get sour => '酸味';

  @override
  String get pantryTitle => '我的冰箱';

  @override
  String ingredientCount(int count) {
    return '$count 种食材';
  }

  @override
  String get addIngredient => '添加食材';

  @override
  String get scanIngredient => '扫描食材';

  @override
  String get emptyPantry => '冰箱空空如也';

  @override
  String get addIngredientsToStart => '添加食材开始使用吧';

  @override
  String get generateRecipe => '生成食谱';

  @override
  String get generating => '生成中...';

  @override
  String get recipeRecommendation => '食谱推荐';

  @override
  String get searchRecipesIngredients => '搜索食谱、食材...';

  @override
  String get smartARScan => '智能AR扫描';

  @override
  String get startScan => '开始扫描';

  @override
  String get realtimeRecognition => '实时识别食材，一键生成食谱';

  @override
  String get quickStart => '快速开始，发现美味...';

  @override
  String get photoRecognition => '相册识别';

  @override
  String get recognizeFromPhoto => '从照片识别食材';

  @override
  String get weightEstimation => '重量估算';

  @override
  String get smartPortionRecognition => '智能份量识别';

  @override
  String get todayTrending => '今日热门';

  @override
  String get viewMore => '查看更多';

  @override
  String get viewAll => '查看全部';

  @override
  String moreItems(int count) {
    return '还有 $count 种...';
  }

  @override
  String get cookWithThese => '用这些食材做菜';

  @override
  String get generatingRecipe => '正在生成食谱...';

  @override
  String generationFailed(String error) {
    return '生成失败: $error';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '吃啥APP';

  @override
  String get todayEatWhat => '今天吃什麼？';

  @override
  String get myFridge => '我的冰箱';

  @override
  String get profile => '個人檔案';

  @override
  String get profileTitle => '個人檔案';

  @override
  String get save => '儲存';

  @override
  String get cancel => '取消';

  @override
  String get add => '新增';

  @override
  String get delete => '刪除';

  @override
  String get edit => '編輯';

  @override
  String get confirm => '確認';

  @override
  String get manageProfiles => '管理個人檔案';

  @override
  String get addFamilyFriends => '新增家人和朋友的檔案';

  @override
  String get username => '使用者名稱';

  @override
  String get enterUsername => '請輸入使用者名稱';

  @override
  String get allergens => '過敏原';

  @override
  String get selectOrAddAllergens => '選擇或新增你的過敏食材';

  @override
  String get customAllergen => '自訂';

  @override
  String get customAllergens => '自訂過敏源：';

  @override
  String get addCustomAllergen => '新增自訂過敏源';

  @override
  String get enterAllergenName => '請輸入過敏源名稱';

  @override
  String allergenAdded(String name) {
    return '已新增過敏源: $name';
  }

  @override
  String get tastePreferences => '口味偏好';

  @override
  String get multipleChoice => '可多選';

  @override
  String get defaultServings => '預設用餐人數';

  @override
  String get people => '人';

  @override
  String get languageSettings => '語言設定';

  @override
  String get followSystem => '跟隨系統';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get english => 'English';

  @override
  String get languageSwitched => '語言已切換';

  @override
  String get peanut => '花生';

  @override
  String get seafood => '海鮮';

  @override
  String get milk => '牛奶';

  @override
  String get egg => '雞蛋';

  @override
  String get soybean => '大豆';

  @override
  String get wheat => '小麥';

  @override
  String get nuts => '堅果';

  @override
  String get sesame => '芝麻';

  @override
  String get mild => '清淡';

  @override
  String get heavy => '重口味';

  @override
  String get mildlySpicy => '微辣';

  @override
  String get mediumSpicy => '中辣';

  @override
  String get verySpicy => '特辣';

  @override
  String get sweet => '甜味';

  @override
  String get sour => '酸味';

  @override
  String get pantryTitle => '我的冰箱';

  @override
  String ingredientCount(int count) {
    return '$count 種食材';
  }

  @override
  String get addIngredient => '新增食材';

  @override
  String get scanIngredient => '掃描食材';

  @override
  String get emptyPantry => '冰箱空空如也';

  @override
  String get addIngredientsToStart => '新增食材開始使用吧';

  @override
  String get generateRecipe => '生成食譜';

  @override
  String get generating => '生成中...';

  @override
  String get recipeRecommendation => '食譜推薦';

  @override
  String get searchRecipesIngredients => '搜尋食譜、食材...';

  @override
  String get smartARScan => '智慧AR掃描';

  @override
  String get startScan => '開始掃描';

  @override
  String get realtimeRecognition => '即時識別食材，一鍵生成食譜';

  @override
  String get quickStart => '快速開始，發現美味...';

  @override
  String get photoRecognition => '相簿識別';

  @override
  String get recognizeFromPhoto => '從照片識別食材';

  @override
  String get weightEstimation => '重量估算';

  @override
  String get smartPortionRecognition => '智慧份量識別';

  @override
  String get todayTrending => '今日熱門';

  @override
  String get viewMore => '檢視更多';

  @override
  String get viewAll => '檢視全部';

  @override
  String moreItems(int count) {
    return '還有 $count 種...';
  }

  @override
  String get cookWithThese => '用這些食材做菜';

  @override
  String get generatingRecipe => '正在生成食譜...';

  @override
  String generationFailed(String error) {
    return '生成失敗: $error';
  }
}
