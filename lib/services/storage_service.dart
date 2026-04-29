import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/history.dart';

/// 本地存储服务
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  /// 获取单例（必须在 main() 已完成 await init() 后调用）
  static StorageService getInstance() {
    if (_instance == null) {
      throw StateError('StorageService 未初始化，请先调用 await init()');
    }
    return _instance!;
  }

  /// 异步初始化（main() 中调用一次）
  static Future<StorageService> init() async {
    if (_instance == null) {
      _instance = StorageService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // 存储键名
  static const String _keyAllergens = 'user_allergens';
  static const String _keyServings = 'default_servings';
  static const String _keyPreferences = 'user_preferences';
  static const String _keyUserName = 'user_name';
  static const String _keyProfiles = 'user_profiles';
  static const String _keyLocale = 'user_locale';
  static const String _keyHistory = 'history_records';
  static const int _maxHistoryItems = 50;

  /// 保存用户档案列表
  Future<bool> saveProfiles(List<Map<String, dynamic>> profiles) async {
    final jsonString = jsonEncode(profiles);
    return await _prefs!.setString(_keyProfiles, jsonString);
  }

  /// 获取用户档案列表
  List<Map<String, dynamic>> getProfiles() {
    final jsonString = _prefs!.getString(_keyProfiles);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('解析档案数据失败: $e');
      return [];
    }
  }

  /// 保存过敏原列表
  Future<bool> saveAllergens(List<String> allergens) async {
    return await _prefs!.setStringList(_keyAllergens, allergens);
  }

  /// 获取过敏原列表
  List<String> getAllergens() {
    return _prefs!.getStringList(_keyAllergens) ?? [];
  }

  /// 保存就餐人数
  Future<bool> saveServings(int servings) async {
    return await _prefs!.setInt(_keyServings, servings);
  }

  /// 获取就餐人数
  int getServings() {
    return _prefs!.getInt(_keyServings) ?? 2;
  }

  /// 保存口味偏好
  Future<bool> savePreferences(List<String> preferences) async {
    return await _prefs!.setStringList(_keyPreferences, preferences);
  }

  /// 获取口味偏好
  List<String> getPreferences() {
    return _prefs!.getStringList(_keyPreferences) ?? [];
  }

  /// 保存用户名
  Future<bool> saveUserName(String name) async {
    return await _prefs!.setString(_keyUserName, name);
  }

  /// 获取用户名
  String getUserName() {
    return _prefs!.getString(_keyUserName) ?? '用户';
  }

  /// 保存语言偏好
  Future<bool> saveLocale(String? locale) async {
    if (locale == null) {
      return await _prefs!.remove(_keyLocale);
    }
    return await _prefs!.setString(_keyLocale, locale);
  }

  /// 获取语言偏好
  String? getLocale() {
    return _prefs!.getString(_keyLocale);
  }

  /// 保存历史记录
  Future<bool> saveHistoryRecord(HistoryRecord record) async {
    final records = getHistoryRecords();
    records.insert(0, record);
    // 最多保留50条
    final trimmed = records.take(_maxHistoryItems).toList();
    final jsonList = trimmed.map((r) => r.toJson()).toList();
    return await _prefs!.setString(_keyHistory, jsonEncode(jsonList));
  }

  /// 获取历史记录列表
  List<HistoryRecord> getHistoryRecords() {
    final jsonString = _prefs!.getString(_keyHistory);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((e) => HistoryRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('解析历史记录失败: $e');
      return [];
    }
  }

  /// 清空历史记录
  Future<bool> clearHistoryRecords() async {
    return await _prefs!.remove(_keyHistory);
  }

  /// 删除单条历史记录
  Future<bool> deleteHistoryRecord(String recordId) async {
    final records = getHistoryRecords();
    records.removeWhere((r) => r.id == recordId);
    final jsonList = records.map((r) => r.toJson()).toList();
    return await _prefs!.setString(_keyHistory, jsonEncode(jsonList));
  }

  /// 清除所有数据
  Future<bool> clearAll() async {
    return await _prefs!.clear();
  }

  /// 打印当前存储的所有数据（用于调试）
  void printAllData() {
    print('=== 本地存储数据 ===');
    print('用户名: ${getUserName()}');
    print('过敏原: ${getAllergens()}');
    print('口味偏好: ${getPreferences()}');
    print('就餐人数: ${getServings()}');
    print('语言设置: ${getLocale()}');
    print('历史记录数: ${getHistoryRecords().length}');
    print('==================');
  }
}
