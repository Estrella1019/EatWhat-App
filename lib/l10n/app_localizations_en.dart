// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'What to Eat';

  @override
  String get todayEatWhat => 'What to Eat Today?';

  @override
  String get myFridge => 'My Fridge';

  @override
  String get profile => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get confirm => 'Confirm';

  @override
  String get manageProfiles => 'Manage Profiles';

  @override
  String get addFamilyFriends => 'Add profiles for family and friends';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get allergens => 'Allergens';

  @override
  String get selectOrAddAllergens => 'Select or add your allergens';

  @override
  String get customAllergen => 'Custom';

  @override
  String get customAllergens => 'Custom Allergens:';

  @override
  String get addCustomAllergen => 'Add Custom Allergen';

  @override
  String get enterAllergenName => 'Enter allergen name';

  @override
  String allergenAdded(String name) {
    return 'Allergen added: $name';
  }

  @override
  String get tastePreferences => 'Taste Preferences';

  @override
  String get multipleChoice => 'Multiple choice';

  @override
  String get defaultServings => 'Default Servings';

  @override
  String get people => 'people';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get followSystem => 'Follow System';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get english => 'English';

  @override
  String get languageSwitched => 'Language switched';

  @override
  String get peanut => 'Peanut';

  @override
  String get seafood => 'Seafood';

  @override
  String get milk => 'Milk';

  @override
  String get egg => 'Egg';

  @override
  String get soybean => 'Soybean';

  @override
  String get wheat => 'Wheat';

  @override
  String get nuts => 'Nuts';

  @override
  String get sesame => 'Sesame';

  @override
  String get mild => 'Mild';

  @override
  String get heavy => 'Heavy';

  @override
  String get mildlySpicy => 'Mildly Spicy';

  @override
  String get mediumSpicy => 'Medium Spicy';

  @override
  String get verySpicy => 'Very Spicy';

  @override
  String get sweet => 'Sweet';

  @override
  String get sour => 'Sour';

  @override
  String get pantryTitle => 'My Fridge';

  @override
  String ingredientCount(int count) {
    return '$count ingredients';
  }

  @override
  String get addIngredient => 'Add Ingredient';

  @override
  String get scanIngredient => 'Scan Ingredient';

  @override
  String get emptyPantry => 'Your fridge is empty';

  @override
  String get addIngredientsToStart => 'Add ingredients to get started';

  @override
  String get generateRecipe => 'Generate Recipe';

  @override
  String get generating => 'Generating...';

  @override
  String get recipeRecommendation => 'Recipe Recommendation';

  @override
  String get searchRecipesIngredients => 'Search recipes, ingredients...';

  @override
  String get smartARScan => 'Smart AR Scan';

  @override
  String get startScan => 'Start Scan';

  @override
  String get realtimeRecognition =>
      'Real-time ingredient recognition, one-click recipe generation';

  @override
  String get quickStart => 'Quick start, discover delicious...';

  @override
  String get photoRecognition => 'Photo Recognition';

  @override
  String get recognizeFromPhoto => 'Recognize ingredients from photos';

  @override
  String get weightEstimation => 'Weight Estimation';

  @override
  String get smartPortionRecognition => 'Smart portion recognition';

  @override
  String get todayTrending => 'Today\'s Trending';

  @override
  String get viewMore => 'View More';

  @override
  String get viewAll => 'View All';

  @override
  String moreItems(int count) {
    return '$count more...';
  }

  @override
  String get cookWithThese => 'Cook with these';

  @override
  String get generatingRecipe => 'Generating recipe...';

  @override
  String generationFailed(String error) {
    return 'Generation failed: $error';
  }
}
