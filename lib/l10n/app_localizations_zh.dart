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
  String allergenAdded(Object name) {
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
  String get traditionalChinese => '繁體中文';

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
  String ingredientCount(Object count) {
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
  String moreItems(Object count) {
    return '还有 $count 种...';
  }

  @override
  String get cookWithThese => '用这些食材做菜';

  @override
  String get generatingRecipe => '正在生成食谱...';

  @override
  String get historyTitle => '历史记录';

  @override
  String get historySubtitle => '记录你的每一次美食探索，方便随时回顾。';

  @override
  String get emptyHistoryTitle => '还没有记录';

  @override
  String get emptyHistorySubtitle => '开始扫描食材或生成食谱吧';

  @override
  String get historyDeleted => '已删除';

  @override
  String get clearHistoryTitle => '清空历史';

  @override
  String get clearHistoryMessage => '确定要清空所有历史记录吗？此操作不可撤销。';

  @override
  String get clearHistoryConfirm => '清空';

  @override
  String get favorites => '收藏';

  @override
  String get history => '历史';

  @override
  String get myProfile => '我的';

  @override
  String get search => '搜索';

  @override
  String get currentInventory => '当前库存';

  @override
  String categories(Object count) {
    return '$count 个分类';
  }

  @override
  String get useARToAdd => '使用AR扫描添加食材';

  @override
  String kcal(Object count) {
    return '$count 千卡';
  }

  @override
  String minutes(Object count) {
    return '$count 分钟';
  }

  @override
  String get pantryEmptyHint => '冰箱空空如也';

  @override
  String items(Object count) {
    return '$count 种食材';
  }

  @override
  String get confirmLogout => '确认登出';

  @override
  String get logoutConfirmMessage => '确定要退出登录吗？';

  @override
  String get logoutButton => '登出';

  @override
  String get enterAllergenHint => '例如：芝麻';

  @override
  String get profileUpdated => '个人档案已更新';

  @override
  String get updateProfile => '更新档案';

  @override
  String get editProfile => '编辑档案';

  @override
  String get addProfile => '添加档案';

  @override
  String get profileManagement => '档案管理';

  @override
  String get preferences => '偏好设置';

  @override
  String get enterYourUsername => '请输入用户名';

  @override
  String get allergyFilters => '过敏原筛选';

  @override
  String get servings => '就餐人数';

  @override
  String get language => '语言设置';

  @override
  String get savedRecipes => '收藏食谱';

  @override
  String get cookedThisWeek => '本周烹饪';

  @override
  String get premiumMember => '高级会员';

  @override
  String get yourName => '你的名字';

  @override
  String get myFavorites => '我的收藏';

  @override
  String get loginRegister => '登录 / 注册';

  @override
  String get logout => '登出';

  @override
  String get account => '账户';

  @override
  String get userSettings => '用户设置';

  @override
  String get recommendedRecipes => '推荐菜谱';

  @override
  String get noRecipes => '暂无菜谱';

  @override
  String get goBack => '返回';

  @override
  String get favoritesPageTitle => '我的收藏';

  @override
  String get favoritesSubtitle => '收藏你最喜欢的菜谱，方便随时回来看。';

  @override
  String get favoritesRemoved => '已取消收藏';

  @override
  String get removeFavoriteTitle => '移除收藏';

  @override
  String get removeFavoriteMessage => '确定要把这道菜从收藏中移除吗？';

  @override
  String get remove => '移除';

  @override
  String get emptyFavoritesTitle => '还没有收藏';

  @override
  String get emptyFavoritesSubtitle => '去收藏你喜欢的菜谱吧';

  @override
  String get deleteFailed => '删除失败';

  @override
  String get retry => '重试';

  @override
  String get pleaseLoginFirst => '请先登录';

  @override
  String get favoriteAdded => '收藏成功';

  @override
  String favoriteAddFailed(Object error) {
    return '收藏失败: $error';
  }

  @override
  String get weightDemo => '智能重量估算演示';

  @override
  String get skipAll => '全部跳过';

  @override
  String get skipConfirm => '跳过确认';

  @override
  String get skipAllMessage => '确定要跳过所有未添加的食材吗？';

  @override
  String get confirmPortion => '确认食材份量';

  @override
  String get addToFridge => '存入冰箱';

  @override
  String get generateRecipes => '生成菜谱';

  @override
  String ingredientsAdded(Object count) {
    return '已添加 $count 种食材到冰箱';
  }

  @override
  String get generatingRecipes => '正在生成食谱...';

  @override
  String get enterNickname => '请输入昵称';

  @override
  String switchedTo(Object name) {
    return '已切换到 $name';
  }

  @override
  String get yoloComplete => 'YOLO识别完成';

  @override
  String addedToFridge(Object name) {
    return '$name 已添加到冰箱';
  }

  @override
  String get viewFridge => '查看冰箱';

  @override
  String doneCount(Object count) {
    return '完成 ($count)';
  }

  @override
  String addedCountOf(Object count, Object total) {
    return '已添加 $count/$total 种食材';
  }

  @override
  String get selectImageToRecognize => '请选择图片进行识别';

  @override
  String get reselectImage => '重新选图';

  @override
  String get yoloRecognizing => 'YOLO识别中...';

  @override
  String get callingBackend => '正在调用后端识别食材';

  @override
  String detectedItems(Object count) {
    return '已识别到 $count 种食材';
  }

  @override
  String get skip => '跳过';

  @override
  String generationFailed(Object error) {
    return '生成失败: $error';
  }

  @override
  String get profileIdentity => '档案身份';

  @override
  String get nickname => '昵称';

  @override
  String get nicknamePlaceholder => '大厨';

  @override
  String get relationship => '关系';

  @override
  String get gender => '性别';

  @override
  String get birthday => '生日';

  @override
  String get selectBirthday => '选择生日';

  @override
  String get foodAllergies => '食物过敏';

  @override
  String get noAllergiesYet => '还没有添加过敏原';

  @override
  String get tapToRemoveAllergy => '点击过敏原标签即可从档案中移除。';

  @override
  String get saveChanges => '保存更改';

  @override
  String get deleteProfile => '删除档案';

  @override
  String get deleteProfileConfirm => '确定要删除这个档案吗？';

  @override
  String get addAllergy => '添加过敏原';

  @override
  String get enterAllergenExample => '例如：麸质、大豆...';

  @override
  String get addItem => '添加';

  @override
  String get self => '本人';

  @override
  String get spouse => '配偶';

  @override
  String get child => '子女';

  @override
  String get friend => '朋友';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get nonBinary => '其他';
}
