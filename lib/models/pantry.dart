/// 虚拟冰箱食材项
class PantryItem {
  final String id;
  final String name;
  final double quantity; // 改为double支持小数
  final String unit;
  final DateTime addedDate;
  final String category;
  final double? weightInGrams; // 新增：以克为单位的重量

  PantryItem({
    required this.id,
    required this.name,
    this.quantity = 1.0,
    this.unit = '个',
    required this.addedDate,
    this.category = '其他',
    this.weightInGrams,
  });

  /// 从JSON创建
  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit']?.toString() ?? '个',
      addedDate: json['added_date'] != null
          ? DateTime.parse(json['added_date'])
          : DateTime.now(),
      category: json['category']?.toString() ?? '其他',
      weightInGrams: (json['weight_in_grams'] as num?)?.toDouble(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'added_date': addedDate.toIso8601String(),
      'category': category,
      'weight_in_grams': weightInGrams,
    };
  }

  /// 创建副本
  PantryItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    DateTime? addedDate,
    String? category,
    double? weightInGrams,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      addedDate: addedDate ?? this.addedDate,
      category: category ?? this.category,
      weightInGrams: weightInGrams ?? this.weightInGrams,
    );
  }

  /// 获取显示文本
  String get displayText {
    if (weightInGrams != null && weightInGrams! > 0) {
      // 如果有重量信息，优先显示重量
      if (weightInGrams! >= 1000) {
        return '$name ${(weightInGrams! / 1000).toStringAsFixed(1)}kg';
      } else {
        return '$name ${weightInGrams!.toStringAsFixed(0)}g';
      }
    } else {
      // 否则显示数量和单位
      if (quantity == quantity.toInt()) {
        return '$name ${quantity.toInt()}$unit';
      } else {
        return '$name ${quantity.toStringAsFixed(1)}$unit';
      }
    }
  }
}
