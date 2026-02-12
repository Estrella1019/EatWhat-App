import 'package:dio/dio.dart';
import 'dart:typed_data';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/user.dart';

/// API服务 - 处理所有网络请求（匹配后端接口设计）
class ApiService {
  static ApiService? _instance;
  late Dio _dio;

  // API基础URL（后续替换为实际地址）
  static const String _baseUrl = 'http://localhost:8000';

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30), // 生成食谱可能需要更长时间
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('请求: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('响应: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        print('错误: ${error.message}');
        _handleError(error);
        return handler.next(error);
      },
    ));
  }

  /// 获取单例
  static ApiService getInstance() {
    _instance ??= ApiService._();
    return _instance!;
  }

  /// 步骤1: 上传图片并识别食材
  /// 对应后端接口: POST /api/identify
  Future<IdentifyResult> identifyIngredients({
    required Uint8List imageBytes,
  }) async {
    try {
      // 创建FormData
      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: 'photo.jpg',
        ),
      });

      // 发送请求
      final response = await _dio.post(
        '/api/identify',
        data: formData,
      );

      // 解析响应
      if (response.statusCode == 200) {
        return IdentifyResult.fromJson(response.data);
      } else {
        throw Exception('识别失败: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('网络连接超时，请检查网络设置');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('网络连接失败，请检查网络设置');
      } else {
        throw Exception('请求失败: ${e.message}');
      }
    } catch (e) {
      throw Exception('未知错误: $e');
    }
  }

  /// 步骤2: 根据食材生成食谱
  /// 对应后端接口: POST /api/generate_recipes
  Future<List<Recipe>> generateRecipes({
    required List<String> ingredients,
    required List<String> allergens,
    required int servings,
    List<String>? preferences,
    String? customText,
  }) async {
    try {
      final response = await _dio.post(
        '/api/generate_recipes',
        data: {
          'ingredients': ingredients,
          'allergens': allergens,
          'servings': servings,
          if (preferences != null) 'preferences': preferences,
          if (customText != null && customText.isNotEmpty) 'custom_text': customText,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> recipesJson = response.data['recipes'] ?? [];
        return recipesJson.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('生成食谱失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('生成食谱失败: $e');
    }
  }

  /// 获取单个新食谱（用于无感替换）
  /// 对应后端接口: POST /api/get_one_recipe
  Future<Recipe> getOneRecipe({
    required List<String> excludeIds,
    required List<String> ingredients,
    required List<String> allergens,
    required int servings,
  }) async {
    try {
      final response = await _dio.post(
        '/api/get_one_recipe',
        data: {
          'exclude_ids': excludeIds,
          'ingredients': ingredients,
          'allergens': allergens,
          'servings': servings,
        },
      );

      if (response.statusCode == 200) {
        return Recipe.fromJson(response.data['recipe']);
      } else {
        throw Exception('获取食谱失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取食谱失败: $e');
    }
  }

  /// 创建/更新用户档案
  /// 对应后端接口: POST /api/user/profile
  Future<User> updateUserProfile({
    required String userId,
    required String name,
    required List<String> allergens,
    required List<String> preferences,
    required int defaultServings,
  }) async {
    try {
      final response = await _dio.post(
        '/api/user/profile',
        data: {
          'user_id': userId,
          'name': name,
          'allergens': allergens,
          'preferences': preferences,
          'default_servings': defaultServings,
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('更新用户档案失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('更新用户档案失败: $e');
    }
  }

  /// 获取用户档案
  /// 对应后端接口: GET /api/user/profile/{userId}
  Future<User> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/api/user/profile/$userId');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('获取用户档案失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取用户档案失败: $e');
    }
  }

  /// 获取用户历史记录
  /// 对应后端接口: GET /api/user/history/{userId}
  Future<List<Map<String, dynamic>>> getUserHistory(String userId) async {
    try {
      final response = await _dio.get('/api/user/history/$userId');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['history'] ?? []);
      } else {
        throw Exception('获取历史记录失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取历史记录失败: $e');
    }
  }

  /// 处理错误
  void _handleError(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        print('错误请求: 参数错误');
        break;
      case 404:
        print('错误请求: 接口不存在');
        break;
      case 500:
        print('服务器错误: 请稍后重试');
        break;
      default:
        print('未知错误: ${error.message}');
    }
  }
}
