import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../services/mock_api_service.dart';
import 'user_provider.dart';

/// 全局状态管理 - 管理食谱列表和应用状态
class GlobalProvider with ChangeNotifier {
  final MockApiService _apiService = MockApiService.getInstance();
  final UserProvider _userProvider;

  List<Recipe> _recipes = [];
  List<Ingredient> _identifiedIngredients = [];
  bool _isLoading = false;
  String? _errorMessage;
  Uint8List? _currentImage;
  String? _imageHash;

  GlobalProvider(this._userProvider);

  List<Recipe> get recipes => _recipes;
  List<Ingredient> get identifiedIngredients => _identifiedIngredients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Uint8List? get currentImage => _currentImage;

  /// 完整流程：识别食材并生成食谱
  /// 步骤1: 调用 /api/identify 识别食材
  /// 步骤2: 调用 /api/generate_recipes 生成食谱
  Future<void> identifyAndGenerateRecipes({
    required Uint8List imageBytes,
    String? customText,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _currentImage = imageBytes;
    notifyListeners();

    try {
      print('=== 步骤1: 开始识别食材 ===');

      // 步骤1: 识别食材
      final identifyResult = await _apiService.identifyIngredients(
        imageBytes: imageBytes,
      );

      _identifiedIngredients = identifyResult.ingredients;
      _imageHash = identifyResult.imageHash;

      print('识别成功！共识别到 ${identifyResult.totalItems} 种食材');
      for (var ingredient in _identifiedIngredients) {
        print('  - ${ingredient.name} x${ingredient.count} (置信度: ${(ingredient.confidence * 100).toStringAsFixed(1)}%)');
      }

      print('=== 步骤2: 开始生成食谱 ===');

      // 步骤2: 根据识别的食材生成食谱
      List<String> ingredientNames = _identifiedIngredients.map((i) => i.name).toList();

      List<Recipe> newRecipes = await _apiService.generateRecipes(
        ingredients: ingredientNames,
        allergens: _userProvider.user.allergens,
        servings: _userProvider.user.defaultServings,
        preferences: _userProvider.user.preferences,
        customText: customText,
      );

      _recipes = newRecipes;
      _isLoading = false;
      notifyListeners();

      print('生成成功！获得 ${_recipes.length} 个食谱');
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('失败: $e');
    }
  }

  /// 无感替换单个食谱
  /// 对应后端接口: POST /api/get_one_recipe
  Future<void> replaceRecipe(int index) async {
    if (index < 0 || index >= _recipes.length) {
      print('错误：索引超出范围');
      return;
    }

    try {
      print('正在替换第 $index 个食谱...');

      // 获取当前所有食谱的ID（用于排除）
      List<String> excludeIds = _recipes.map((r) => r.id).toList();

      // 获取食材名称列表
      List<String> ingredientNames = _identifiedIngredients.map((i) => i.name).toList();

      // 获取新食谱
      Recipe newRecipe = await _apiService.getOneRecipe(
        excludeIds: excludeIds,
        ingredients: ingredientNames,
        allergens: _userProvider.user.allergens,
        servings: _userProvider.user.defaultServings,
      );

      // 替换指定位置的食谱
      _recipes[index] = newRecipe;
      notifyListeners();

      print('替换成功！新食谱: ${newRecipe.name}');
    } catch (e) {
      print('替换失败: $e');
      _errorMessage = '替换失败: $e';
      notifyListeners();
    }
  }

  /// 清除所有食谱
  void clearRecipes() {
    _recipes = [];
    _identifiedIngredients = [];
    _currentImage = null;
    _imageHash = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 直接从食材列表生成食谱（用于虚拟冰箱）
  Future<void> generateRecipesFromIngredients({
    required List<String> ingredients,
    required List<String> allergens,
    required int servings,
    List<String>? preferences,
    String? customText,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('=== 使用冰箱食材生成食谱 ===');
      print('食材: $ingredients');

      List<Recipe> newRecipes = await _apiService.generateRecipes(
        ingredients: ingredients,
        allergens: allergens,
        servings: servings,
        preferences: preferences,
        customText: customText,
      );

      _recipes = newRecipes;
      _isLoading = false;
      notifyListeners();

      print('生成成功！获得 ${_recipes.length} 个食谱');
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('生成失败: $e');
    }
  }
}
