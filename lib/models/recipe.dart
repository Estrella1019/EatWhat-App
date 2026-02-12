/// 食谱数据模型
class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int servings;
  final int cookingTime; // 分钟
  final String difficulty; // 简单/中等/困难
  final List<String> tags; // 标签：川菜、素食等

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.servings,
    required this.cookingTime,
    required this.difficulty,
    required this.tags,
  });

  /// 从JSON创建Recipe对象
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '未知菜谱',
      imageUrl: json['image_url']?.toString() ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      servings: json['servings'] as int? ?? 2,
      cookingTime: json['cooking_time'] as int? ?? 30,
      difficulty: json['difficulty']?.toString() ?? '中等',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'steps': steps,
      'servings': servings,
      'cooking_time': cookingTime,
      'difficulty': difficulty,
      'tags': tags,
    };
  }

  /// 创建副本
  Recipe copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? steps,
    int? servings,
    int? cookingTime,
    String? difficulty,
    List<String>? tags,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      servings: servings ?? this.servings,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
    );
  }
}
