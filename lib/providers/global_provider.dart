import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../services/api_service.dart';
import 'user_provider.dart';

/// 全局状态管理 - 管理食谱列表和应用状态
class GlobalProvider with ChangeNotifier {
  final ApiService _apiService = ApiService.getInstance();
  final UserProvider _userProvider;

  List<Recipe> _recipes = [];
  List<Recipe> _candidates = []; // LLM 一次性生成的备用菜，换菜时直接取
  List<Ingredient> _identifiedIngredients = [];
  bool _isLoading = false;
  String? _errorMessage;
  Uint8List? _currentImage;
  String? _imageHash;

  GlobalProvider(this._userProvider);

  List<Recipe> get recipes => _recipes;
  List<Recipe> get candidates => _candidates;
  List<Ingredient> get identifiedIngredients => _identifiedIngredients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Uint8List? get currentImage => _currentImage;

  /// 完整流程：识别食材并生成食谱
  Future<void> identifyAndGenerateRecipes({
    required Uint8List imageBytes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _currentImage = imageBytes;
    notifyListeners();

    try {
      print('=== 步骤1: 开始识别食材 ===');

      final identifyResult = await _apiService.identifyIngredients(
        imageBytes: imageBytes,
      );

      _identifiedIngredients = identifyResult.ingredients;
      _imageHash = identifyResult.imageHash;

      print('识别成功！共识别到 ${identifyResult.totalItems} 种食材');
      for (var ingredient in _identifiedIngredients) {
        print('  - ${ingredient.name} (置信度: ${(ingredient.confidence * 100).toStringAsFixed(1)}%)');
      }

      print('=== 步骤2: 开始生成食谱 ===');

      final List<String> ingredientNames =
          _identifiedIngredients.map((i) => i.name).toList();

      final result = await _apiService.generateRecipes(
        ingredients: ingredientNames,
        allergens: _userProvider.user.allergens,
        servings: _userProvider.user.defaultServings,
        preferences: _userProvider.user.preferences,
      );

      _recipes = result.recipes;
      _candidates = result.candidates;
      _isLoading = false;
      notifyListeners();

      print('生成成功！主菜单 ${_recipes.length} 道，备用菜 ${_candidates.length} 道');
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('失败: $e');
    }
  }

  /// 换掉指定位置的菜，直接从备用菜中取，无需调用接口
  void replaceRecipe(int index) {
    if (index < 0 || index >= _recipes.length) {
      print('错误：索引超出范围');
      return;
    }
    if (_candidates.isEmpty) {
      _errorMessage = '备用菜已用完，请重新生成';
      notifyListeners();
      print('备用菜已用完');
      return;
    }

    final newRecipe = _candidates.removeAt(0);
    _recipes[index] = newRecipe;
    notifyListeners();

    print('换菜成功！新菜: ${newRecipe.name}，剩余备用菜: ${_candidates.length} 道');
  }

  /// 直接从食材列表生成食谱（用于虚拟冰箱）
  Future<void> generateRecipesFromIngredients({
    required List<String> ingredients,
    required List<String> allergens,
    required int servings,
    List<String>? preferences,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('=== 使用冰箱食材生成食谱 ===');
      print('食材: $ingredients');

      final result = await _apiService.generateRecipes(
        ingredients: ingredients,
        allergens: allergens,
        servings: servings,
        preferences: preferences,
      );

      _recipes = result.recipes;
      _candidates = result.candidates;
      _isLoading = false;
      notifyListeners();

      print('生成成功！主菜单 ${_recipes.length} 道，备用菜 ${_candidates.length} 道');
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      print('生成失败: $e');
    }
  }

  /// 清除所有食谱
  void clearRecipes() {
    _recipes = [];
    _candidates = [];
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
}
