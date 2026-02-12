import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/pantry.dart';
import '../models/detection_result.dart';
import '../services/pantry_service.dart';

/// 虚拟冰箱状态管理
class PantryProvider with ChangeNotifier {
  final PantryService _pantryService;
  List<PantryItem> _items = [];
  bool _isLoading = false;

  PantryProvider(this._pantryService) {
    _loadItems();
  }

  List<PantryItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.length;

  /// 加载所有食材
  Future<void> _loadItems() async {
    _isLoading = true;
    notifyListeners();

    _items = await _pantryService.getAllItems();
    _isLoading = false;
    notifyListeners();

    print('虚拟冰箱已加载: ${_items.length} 种食材');
  }

  /// 从检测结果添加食材
  Future<void> addFromDetections(List<DetectionResult> detections) async {
    const uuid = Uuid();

    for (var detection in detections) {
      final item = PantryItem(
        id: uuid.v4(),
        name: detection.label,
        quantity: 1.0,
        unit: '个',
        addedDate: DateTime.now(),
        category: _getCategoryFromLabel(detection.label),
      );

      await _pantryService.addItem(item);
    }

    await _loadItems();
    print('已添加 ${detections.length} 种食材到虚拟冰箱');
  }

  /// 手动添加食材
  Future<void> addItem(PantryItem item) async {
    await _pantryService.addItem(item);
    await _loadItems();
  }

  /// 手动添加食材（简化版本）
  Future<void> addItemSimple(String name, {double quantity = 1.0, String unit = '个'}) async {
    const uuid = Uuid();

    final item = PantryItem(
      id: uuid.v4(),
      name: name,
      quantity: quantity,
      unit: unit,
      addedDate: DateTime.now(),
      category: _getCategoryFromLabel(name),
    );

    await _pantryService.addItem(item);
    await _loadItems();
  }

  /// 删除食材
  Future<void> removeItem(String id) async {
    await _pantryService.removeItem(id);
    await _loadItems();
  }

  /// 清空所有食材
  Future<void> clearAll() async {
    await _pantryService.clearAll();
    await _loadItems();
  }

  /// 获取食材名称列表（用于生成食谱）
  List<String> getIngredientNames() {
    return _items.map((item) => item.name).toList();
  }

  /// 根据标签推测分类
  String _getCategoryFromLabel(String label) {
    // 简单的分类逻辑
    if (label.contains('肉') || label.contains('鸡') || label.contains('猪') || label.contains('牛')) {
      return '肉类';
    } else if (label.contains('菜') || label.contains('瓜') || label.contains('茄') || label.contains('椒')) {
      return '蔬菜';
    } else if (label.contains('蛋') || label.contains('奶')) {
      return '蛋奶';
    } else if (label.contains('米') || label.contains('面') || label.contains('粉')) {
      return '主食';
    } else {
      return '其他';
    }
  }
}
