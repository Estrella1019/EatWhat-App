import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

/// 用户状态管理
class UserProvider with ChangeNotifier {
  User _user = User(
    id: '1',
    name: '用户',
    allergens: [],
    preferences: [],
    defaultServings: 2,
  );

  // 多个用户档案
  List<User> _profiles = [];
  User? _currentProfile;

  final StorageService _storage;

  UserProvider(this._storage) {
    _loadUserData();
  }

  User get user {
    // 如果有当前档案，使用档案的数据，但 locale 始终使用 _user 的
    if (_currentProfile != null) {
      return _currentProfile!.copyWith(locale: _user.locale);
    }
    return _user;
  }

  List<User> get profiles => _profiles;
  User? get currentProfile => _currentProfile;

  /// 从本地存储加载用户数据
  Future<void> _loadUserData() async {
    _user = User(
      id: '1',
      name: _storage.getUserName(),
      allergens: _storage.getAllergens(),
      preferences: _storage.getPreferences(),
      defaultServings: _storage.getServings(),
      locale: _storage.getLocale(),
    );

    // 加载所有档案
    await _loadProfiles();

    notifyListeners();

    // 打印加载的数据
    print('=== 用户数据已加载 ===');
    _storage.printAllData();
  }

  /// 加载所有档案
  Future<void> _loadProfiles() async {
    final profilesData = _storage.getProfiles();
    _profiles = profilesData.map((data) => User.fromJson(data)).toList();

    // 如果没有档案，创建默认档案
    if (_profiles.isEmpty) {
      _profiles.add(_user.copyWith(
        relationship: '自己',
        nickname: _user.name,
      ));
      await _saveProfiles();
    }

    // 设置当前档案为第一个
    if (_profiles.isNotEmpty) {
      _currentProfile = _profiles.first;
    }
  }

  /// 保存所有档案
  Future<void> _saveProfiles() async {
    final profilesData = _profiles.map((p) => p.toJson()).toList();
    await _storage.saveProfiles(profilesData);
  }

  /// 添加新档案
  Future<void> addProfile(User profile) async {
    _profiles.add(profile);
    await _saveProfiles();
    notifyListeners();
  }

  /// 更新档案
  Future<void> updateProfile(String id, User updatedProfile) async {
    final index = _profiles.indexWhere((p) => p.id == id);
    if (index != -1) {
      _profiles[index] = updatedProfile;
      if (_currentProfile?.id == id) {
        _currentProfile = updatedProfile;
      }
      await _saveProfiles();
      notifyListeners();
    }
  }

  /// 删除档案
  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    if (_currentProfile?.id == id && _profiles.isNotEmpty) {
      _currentProfile = _profiles.first;
    }
    await _saveProfiles();
    notifyListeners();
  }

  /// 切换当前档案
  void setCurrentProfile(User profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  /// 更新用户名
  Future<void> updateUserName(String name) async {
    await _storage.saveUserName(name);
    _user = _user.copyWith(name: name);
    notifyListeners();
  }

  /// 更新过敏原
  Future<void> updateAllergens(List<String> allergens) async {
    await _storage.saveAllergens(allergens);
    if (_currentProfile != null) {
      final updated = _currentProfile!.copyWith(allergens: allergens);
      await updateProfile(_currentProfile!.id, updated);
    } else {
      _user = _user.copyWith(allergens: allergens);
      notifyListeners();
    }
    print('过敏原已更新: $allergens');
  }

  /// 添加过敏原
  Future<void> addAllergen(String allergen) async {
    final currentAllergens = _currentProfile?.allergens ?? _user.allergens;
    if (!currentAllergens.contains(allergen)) {
      List<String> newAllergens = [...currentAllergens, allergen];
      await updateAllergens(newAllergens);
    }
  }

  /// 移除过敏原
  Future<void> removeAllergen(String allergen) async {
    final currentAllergens = _currentProfile?.allergens ?? _user.allergens;
    List<String> newAllergens = currentAllergens.where((a) => a != allergen).toList();
    await updateAllergens(newAllergens);
  }

  /// 更新口味偏好
  Future<void> updatePreferences(List<String> preferences) async {
    await _storage.savePreferences(preferences);
    if (_currentProfile != null) {
      final updated = _currentProfile!.copyWith(preferences: preferences);
      await updateProfile(_currentProfile!.id, updated);
    } else {
      _user = _user.copyWith(preferences: preferences);
      notifyListeners();
    }
    print('口味偏好已更新: $preferences');
  }

  /// 更新就餐人数
  Future<void> updateServings(int servings) async {
    await _storage.saveServings(servings);
    _user = _user.copyWith(defaultServings: servings);
    notifyListeners();
    print('就餐人数已更新: $servings');
  }

  /// 更新语言偏好
  Future<void> updateLocale(String? locale) async {
    await _storage.saveLocale(locale);
    _user = _user.copyWith(locale: locale);
    notifyListeners();
    print('语言偏好已更新: $locale');
  }

  /// 清除所有用户数据
  Future<void> clearUserData() async {
    await _storage.clearAll();
    _user = User(
      id: '1',
      name: '用户',
      allergens: [],
      preferences: [],
      defaultServings: 2,
    );
    _profiles = [];
    _currentProfile = null;
    notifyListeners();
  }
}
