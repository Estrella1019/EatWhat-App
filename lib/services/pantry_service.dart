import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pantry.dart';

/// 虚拟冰箱本地存储服务
class PantryService {
  static PantryService? _instance;
  static SharedPreferences? _prefs;

  PantryService._();

  static Future<PantryService> getInstance() async {
    if (_instance == null) {
      _instance = PantryService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  static const String _keyPantryItems = 'pantry_items';

  /// 获取所有食材
  Future<List<PantryItem>> getAllItems() async {
    final String? itemsJson = _prefs!.getString(_keyPantryItems);
    if (itemsJson == null || itemsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> itemsList = json.decode(itemsJson);
      return itemsList
          .map((item) => PantryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('解析Pantry数据失败: $e');
      return [];
    }
  }

  /// 添加食材
  Future<void> addItem(PantryItem item) async {
    final items = await getAllItems();

    // 检查是否已存在同名食材
    final existingIndex = items.indexWhere((i) => i.name == item.name);
    if (existingIndex != -1) {
      // 更新数量
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + item.quantity,
      );
    } else {
      // 添加新食材
      items.add(item);
    }

    await _saveItems(items);
  }

  /// 批量添加食材
  Future<void> addItems(List<PantryItem> newItems) async {
    for (var item in newItems) {
      await addItem(item);
    }
  }

  /// 删除食材
  Future<void> removeItem(String id) async {
    final items = await getAllItems();
    items.removeWhere((item) => item.id == id);
    await _saveItems(items);
  }

  /// 更新食材
  Future<void> updateItem(PantryItem item) async {
    final items = await getAllItems();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveItems(items);
    }
  }

  /// 清空所有食材
  Future<void> clearAll() async {
    await _prefs!.remove(_keyPantryItems);
  }

  /// 保存食材列表
  Future<void> _saveItems(List<PantryItem> items) async {
    final itemsJson = json.encode(items.map((item) => item.toJson()).toList());
    await _prefs!.setString(_keyPantryItems, itemsJson);
  }

  /// 打印所有食材（调试用）
  Future<void> printAllItems() async {
    final items = await getAllItems();
    print('=== 虚拟冰箱食材 ===');
    for (var item in items) {
      print('${item.name} x${item.quantity}${item.unit} (${item.category})');
    }
    print('总计: ${items.length} 种食材');
    print('==================');
  }
}
