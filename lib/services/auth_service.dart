import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth.dart';
import '../models/favorite.dart';

/// 认证服务 - 处理用户登录、注册、token管理
class AuthService {
  static AuthService? _instance;
  late Dio _dio;
  String? _token;

  static const String _baseUrl = 'http://localhost:8000';
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';

  AuthService._() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加拦截器，自动在请求头中添加token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        print('请求: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('响应: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        print('错误: ${error.message}');
        return handler.next(error);
      },
    ));

    // 启动时加载token
    _loadToken();
  }

  static AuthService getInstance() {
    _instance ??= AuthService._();
    return _instance!;
  }

  /// 从本地存储加载token
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    if (_token != null) {
      print('已加载token');
    }
  }

  /// 保存token到本地
  Future<void> _saveToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
    _token = token;
  }

  /// 清除token
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    _token = null;
  }

  /// 检查是否已登录
  bool get isLoggedIn => _token != null;

  /// 获取当前用户名
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// 注册
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: RegisterRequest(
          username: username,
          email: email,
          password: password,
        ).toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final authResponse = AuthResponse.fromJson(data);
        await _saveToken(authResponse.accessToken, authResponse.username);
        return authResponse;
      } else {
        throw Exception('注册失败: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('注册失败: $e');
    }
  }

  /// 登录
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: LoginRequest(
          username: username,
          password: password,
        ).toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final authResponse = AuthResponse.fromJson(data);
        await _saveToken(authResponse.accessToken, authResponse.username);
        return authResponse;
      } else {
        throw Exception('登录失败: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  /// 登出
  Future<void> logout() async {
    await _clearToken();
  }

  /// 获取当前用户信息
  Future<UserInfo> getUserInfo() async {
    try {
      final response = await _dio.get('/api/users/me');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return UserInfo.fromJson(data);
      } else {
        throw Exception('获取用户信息失败');
      }
    } catch (e) {
      throw Exception('获取用户信息失败: $e');
    }
  }

  /// 获取过敏原列表
  Future<List<Allergen>> getAllergens() async {
    try {
      final response = await _dio.get('/api/users/allergens');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final list = data['allergens'] as List<dynamic>;
        return list.map((json) => Allergen.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('获取过敏原失败');
      }
    } catch (e) {
      throw Exception('获取过敏原失败: $e');
    }
  }

  /// 添加过敏原
  Future<Allergen> addAllergen(String name) async {
    try {
      final response = await _dio.post(
        '/api/users/allergens',
        data: {'name': name},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return Allergen.fromJson(data);
      } else {
        throw Exception('添加过敏原失败');
      }
    } catch (e) {
      throw Exception('添加过敏原失败: $e');
    }
  }

  /// 删除过敏原
  Future<void> deleteAllergen(int allergenId) async {
    try {
      final response = await _dio.delete('/api/users/allergens/$allergenId');

      if (response.statusCode != 200) {
        throw Exception('删除过敏原失败');
      }
    } catch (e) {
      throw Exception('删除过敏原失败: $e');
    }
  }

  /// 获取收藏列表
  Future<List<Favorite>> getFavorites() async {
    try {
      final response = await _dio.get('/api/users/favorites');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final list = data['favorites'] as List<dynamic>;
        return list.map((json) => Favorite.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('获取收藏失败');
      }
    } catch (e) {
      throw Exception('获取收藏失败: $e');
    }
  }

  /// 添加收藏
  Future<Favorite> addFavorite({
    required String recipeName,
    required Map<String, dynamic> recipeData,
  }) async {
    try {
      final response = await _dio.post(
        '/api/users/favorites',
        data: AddFavoriteRequest(
          recipeName: recipeName,
          recipeData: recipeData,
        ).toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return Favorite.fromJson(data);
      } else {
        throw Exception('添加收藏失败');
      }
    } catch (e) {
      throw Exception('添加收藏失败: $e');
    }
  }

  /// 删除收藏
  Future<void> deleteFavorite(int favoriteId) async {
    try {
      final response = await _dio.delete('/api/users/favorites/$favoriteId');

      if (response.statusCode != 200) {
        throw Exception('删除收藏失败');
      }
    } catch (e) {
      throw Exception('删除收藏失败: $e');
    }
  }
}
