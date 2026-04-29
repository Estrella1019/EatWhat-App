import 'recipe.dart';

/// 历史记录来源类型
enum HistorySource {
  arScan,      // AR扫描识别
  photoScan,   // 相册识别
  pantryCook,  // 冰箱食材生成
  manualInput, // 手动输入
}

/// 单条历史记录
class HistoryRecord {
  final String id;
  final DateTime timestamp;
  final HistorySource source;
  final List<Recipe> recipes;
  final int recipeCount;

  HistoryRecord({
    required this.id,
    required this.timestamp,
    required this.source,
    required this.recipes,
  }) : recipeCount = recipes.length;

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    final recipeList = json['recipes'] as List<dynamic>? ?? [];
    return HistoryRecord(
      id: json['id']?.toString() ?? '',
      timestamp: DateTime.parse(
        json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      source: HistorySource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => HistorySource.manualInput,
      ),
      recipes: recipeList
          .map((r) => Recipe.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'source': source.name,
      'recipes': recipes.map((r) => r.toJson()).toList(),
    };
  }

  /// 获取来源的显示名称（用于UI）
  String get sourceName {
    switch (source) {
      case HistorySource.arScan:
        return 'AR扫描';
      case HistorySource.photoScan:
        return '相册识别';
      case HistorySource.pantryCook:
        return '冰箱食材';
      case HistorySource.manualInput:
        return '手动输入';
    }
  }

  String get sourceNameEn {
    switch (source) {
      case HistorySource.arScan:
        return 'AR Scan';
      case HistorySource.photoScan:
        return 'Photo Scan';
      case HistorySource.pantryCook:
        return 'Pantry Cook';
      case HistorySource.manualInput:
        return 'Manual Input';
    }
  }
}
