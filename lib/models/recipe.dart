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
  /// 兼容后端格式：name/difficulty/tags 均为 {"zh":..., "en":...} 对象
  /// ingredients 为对象列表，steps 为带 step 序号的对象列表
  factory Recipe.fromJson(Map<String, dynamic> json) {
    // 解析双语字段，优先取中文
    String parseBilingual(dynamic field) {
      if (field is Map) {
        return field['zh']?.toString() ?? field['en']?.toString() ?? '';
      }
      return field?.toString() ?? '';
    }

    // 解析 ingredients：[{name: {zh,en}, quantity, unit: {zh,en}}] → ["番茄 2个"]
    final rawIngredients = json['ingredients'] as List<dynamic>? ?? [];
    final ingredients = rawIngredients.map((item) {
      if (item is Map) {
        final itemName = parseBilingual(item['name']);
        final quantity = item['quantity']?.toString() ?? '';
        return quantity.isNotEmpty ? '$itemName $quantity' : itemName;
      }
      return item.toString();
    }).toList();

    // 解析 steps：[{step:1, description:{zh,en}}] → ["步骤文字"]
    final rawSteps = json['steps'] as List<dynamic>? ?? [];
    final steps = rawSteps.map((item) {
      if (item is Map) {
        return parseBilingual(item['description']);
      }
      return item.toString();
    }).toList();

    // 解析 tags：[{zh,en}] → ["快手菜"]
    final rawTags = json['tags'] as List<dynamic>? ?? [];
    final tags = rawTags.map((item) => parseBilingual(item)).toList();

    return Recipe(
      id: json['id']?.toString() ?? '',
      name: parseBilingual(json['name']),
      imageUrl: json['image_url']?.toString() ?? '',
      ingredients: ingredients,
      steps: steps,
      servings: json['servings'] as int? ?? 2,
      cookingTime: json['cooking_time'] as int? ?? 30,
      difficulty: parseBilingual(json['difficulty']),
      tags: tags,
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
