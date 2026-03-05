import 'recipe.dart';

/// 收藏的菜谱
class Favorite {
  final int id;
  final String recipeName;
  final Recipe recipeData;
  final DateTime createdAt;

  Favorite({
    required this.id,
    required this.recipeName,
    required this.recipeData,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as int,
      recipeName: json['recipe_name']?.toString() ?? '',
      recipeData: Recipe.fromJson(json['recipe_data'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_name': recipeName,
      'recipe_data': recipeData.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// 添加收藏请求
class AddFavoriteRequest {
  final String recipeName;
  final Map<String, dynamic> recipeData;

  AddFavoriteRequest({
    required this.recipeName,
    required this.recipeData,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipe_name': recipeName,
      'recipe_data': recipeData,
    };
  }
}

/// 过敏原模型
class Allergen {
  final int id;
  final String name;

  Allergen({
    required this.id,
    required this.name,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
