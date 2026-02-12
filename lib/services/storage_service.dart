import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 本地存储服务
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  /// 获取单例
  static Future<StorageService> getInstance() async {
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
    print('==================');
  }
}
