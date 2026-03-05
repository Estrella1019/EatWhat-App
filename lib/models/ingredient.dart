/// 食材数据模型
class Ingredient {
  final String name;
  final int count;
  final double confidence;
  final List<double>? bbox; // 边界框 [x, y, width, height]

  Ingredient({
    required this.name,
    required this.count,
    required this.confidence,
    this.bbox,
  });

  /// 从JSON创建Ingredient对象
  /// 兼容后端格式：name 为 {"zh": "番茄/西红柿", "en": "Tomato"} 对象
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    // name 可能是字符串（旧格式）或 {"zh":..., "en":...} 对象（后端格式）
    String parsedName;
    final rawName = json['name'];
    if (rawName is Map) {
      parsedName = rawName['zh']?.toString() ?? rawName['en']?.toString() ?? '';
    } else {
      parsedName = rawName?.toString() ?? '';
    }

    return Ingredient(
      name: parsedName,
      count: json['count'] as int? ?? 1,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      bbox: (json['bbox'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'count': count,
      'confidence': confidence,
      if (bbox != null) 'bbox': bbox,
    };
  }
}

/// 识别结果模型
class IdentifyResult {
  final List<Ingredient> ingredients;
  final int totalItems;
  final String imageHash;

  IdentifyResult({
    required this.ingredients,
    required this.totalItems,
    required this.imageHash,
  });

  /// 从JSON创建IdentifyResult对象
  /// 后端返回字段：detected_ingredients（非 ingredients）
  factory IdentifyResult.fromJson(Map<String, dynamic> json) {
    final list = (json['detected_ingredients'] as List<dynamic>?)
            ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return IdentifyResult(
      ingredients: list,
      totalItems: list.length,
      imageHash: json['image_hash']?.toString() ?? '',
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'total_items': totalItems,
      'image_hash': imageHash,
    };
  }
}
