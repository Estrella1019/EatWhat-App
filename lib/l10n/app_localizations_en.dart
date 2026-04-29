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
  String allergenAdded(Object name) {
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
  String ingredientCount(Object count) {
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
  String moreItems(Object count) {
    return '$count more...';
  }

  @override
  String get cookWithThese => 'Cook with these';

  @override
  String get generatingRecipe => 'Generating recipe...';

  @override
  String get historyTitle => 'Your History';

  @override
  String get historySubtitle =>
      'A personal journal of your culinary discoveries.';

  @override
  String get emptyHistoryTitle => 'No history yet';

  @override
  String get emptyHistorySubtitle => 'Start scanning or generating recipes';

  @override
  String get historyDeleted => 'Deleted';

  @override
  String get clearHistoryTitle => 'Clear History';

  @override
  String get clearHistoryMessage =>
      'Are you sure you want to clear all history? This cannot be undone.';

  @override
  String get clearHistoryConfirm => 'Clear';

  @override
  String get favorites => 'Favorites';

  @override
  String get history => 'History';

  @override
  String get myProfile => 'My Profile';

  @override
  String get search => 'Search';

  @override
  String get currentInventory => 'Current Inventory';

  @override
  String categories(Object count) {
    return '$count Categories';
  }

  @override
  String get useARToAdd => 'Use AR scan to add ingredients';

  @override
  String kcal(Object count) {
    return '$count kcal';
  }

  @override
  String minutes(Object count) {
    return '$count min';
  }

  @override
  String get pantryEmptyHint => 'Your pantry is empty';

  @override
  String items(Object count) {
    return '$count items';
  }

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get logoutButton => 'Logout';

  @override
  String get enterAllergenHint => 'e.g. sesame';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get addProfile => 'Add Profile';

  @override
  String get profileManagement => 'Profile Management';

  @override
  String get preferences => 'Preferences';

  @override
  String get enterYourUsername => 'Enter your username';

  @override
  String get allergyFilters => 'ALLERGY FILTERS';

  @override
  String get servings => 'SERVINGS';

  @override
  String get language => 'LANGUAGE';

  @override
  String get savedRecipes => 'SAVED RECIPES';

  @override
  String get cookedThisWeek => 'COOKED THIS WEEK';

  @override
  String get premiumMember => 'PREMIUM MEMBER';

  @override
  String get yourName => 'Your Name';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get loginRegister => 'Login / Register';

  @override
  String get logout => 'Logout';

  @override
  String get account => 'Account';

  @override
  String get userSettings => 'USER SETTINGS';

  @override
  String get recommendedRecipes => 'Recommended Recipes';

  @override
  String get noRecipes => 'No recipes yet';

  @override
  String get goBack => 'Go Back';

  @override
  String get favoritesPageTitle => 'Your Favorites';

  @override
  String get favoritesSubtitle =>
      'A personal collection of your most cherished culinary discoveries.';

  @override
  String get favoritesRemoved => 'Removed from favorites';

  @override
  String get removeFavoriteTitle => 'Remove Favorite';

  @override
  String get removeFavoriteMessage =>
      'Are you sure you want to remove this recipe from favorites?';

  @override
  String get remove => 'Remove';

  @override
  String get emptyFavoritesTitle => 'No favorites yet';

  @override
  String get emptyFavoritesSubtitle => 'Start saving recipes you love';

  @override
  String get deleteFailed => 'Failed to delete';

  @override
  String get retry => 'Retry';

  @override
  String get pleaseLoginFirst => 'Please login first';

  @override
  String get favoriteAdded => 'Favorite added';

  @override
  String favoriteAddFailed(Object error) {
    return 'Failed to add favorite: $error';
  }

  @override
  String get weightDemo => 'Smart Weight Estimation';

  @override
  String get skipAll => 'Skip All';

  @override
  String get skipConfirm => 'Skip Confirmation';

  @override
  String get skipAllMessage =>
      'Are you sure you want to skip all remaining ingredients?';

  @override
  String get confirmPortion => 'Confirm Portion';

  @override
  String get addToFridge => 'Add to Fridge';

  @override
  String get generateRecipes => 'Generate Recipes';

  @override
  String ingredientsAdded(Object count) {
    return '$count ingredients added to fridge';
  }

  @override
  String get generatingRecipes => 'Generating recipes...';

  @override
  String get enterNickname => 'Please enter a nickname';

  @override
  String switchedTo(Object name) {
    return 'Switched to $name';
  }

  @override
  String get yoloComplete => 'YOLO Recognition Complete';

  @override
  String addedToFridge(Object name) {
    return '$name added to fridge';
  }

  @override
  String get viewFridge => 'View Fridge';

  @override
  String doneCount(Object count) {
    return 'Done ($count)';
  }

  @override
  String addedCountOf(Object count, Object total) {
    return '$count of $total items added';
  }

  @override
  String get selectImageToRecognize => 'Please select an image to recognize';

  @override
  String get reselectImage => 'Reselect';

  @override
  String get yoloRecognizing => 'YOLO Recognizing...';

  @override
  String get callingBackend => 'Calling backend to recognize ingredients';

  @override
  String detectedItems(Object count) {
    return '$count items detected';
  }

  @override
  String get skip => 'Skip';

  @override
  String generationFailed(Object error) {
    return 'Generation failed: $error';
  }

  @override
  String get profileIdentity => 'PROFILE IDENTITY';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknamePlaceholder => 'Artisan Chef';

  @override
  String get relationship => 'Relationship';

  @override
  String get gender => 'Gender';

  @override
  String get birthday => 'Birthday';

  @override
  String get selectBirthday => 'Select birthday';

  @override
  String get foodAllergies => 'Food Allergies';

  @override
  String get noAllergiesYet => 'No allergies added yet';

  @override
  String get tapToRemoveAllergy =>
      'Tapping an allergy chip will remove it from your profile.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String get deleteProfileConfirm =>
      'Are you sure you want to delete this profile?';

  @override
  String get addAllergy => 'Add Allergy';

  @override
  String get enterAllergenExample => 'e.g. Gluten, Soy...';

  @override
  String get addItem => 'Add Item';

  @override
  String get self => 'Self';

  @override
  String get spouse => 'Spouse';

  @override
  String get child => 'Child';

  @override
  String get friend => 'Friend';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get nonBinary => 'Non-binary';
}
