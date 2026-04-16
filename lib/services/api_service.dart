import 'package:dio/dio.dart';
import 'dart:typed_data';
import '../models/recipe.dart';
import '../models/ingredient.dart';

/// 生成菜谱的返回结果，包含主菜单和备用菜
class GenerateResult {
  final List<Recipe> recipes;
  final List<Recipe> candidates;

  GenerateResult({required this.recipes, required this.candidates});
}

/// API服务 - 处理所有网络请求
class ApiService {
  static ApiService? _instance;
  late Dio _dio;

  static const String _baseUrl = 'http://192.168.31.65:8000';

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 180), // LLM 生成最长约 120 秒
      headers: {
        'Content-Type': 'application/json',
      },
    ));

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

  static ApiService getInstance() {
    _instance ??= ApiService._();
    return _instance!;
  }

  /// 步骤1: 上传图片并识别食材
  /// 对应后端接口: POST /api/ingredients/recognize
  Future<IdentifyResult> identifyIngredients({
    required Uint8List imageBytes,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(imageBytes, filename: 'photo.jpg'),
      });

      final response = await _dio.post(
        '/api/ingredients/recognize',
        data: formData,
      );

      if (response.statusCode == 200) {
        // 后端统一格式：{"code":200, "data": {"detected_ingredients": [...]}}
        final bodyCode = response.data['code'] as int;
        if (bodyCode != 200) {
          throw Exception(response.data['message']?.toString() ?? '识别失败');
        }
        final data = response.data['data'] as Map<String, dynamic>? ?? {};
        return IdentifyResult.fromJson(data);
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

  /// 步骤2: 根据食材生成食谱（含备用菜）
  /// 对应后端接口: POST /api/recipes/generate
  Future<GenerateResult> generateRecipes({
    required List<String> ingredients,
    required List<String> allergens,
    required int servings,
    List<String>? preferences,
    List<String>? dietary,
  }) async {
    try {
      final response = await _dio.post(
        '/api/recipes/generate',
        data: {
          'diners': servings,
          'ingredients': ingredients,
          'allergens': allergens,
          if (dietary != null && dietary.isNotEmpty) 'dietary': dietary,
          if (preferences != null) 'preferences': preferences,
        },
      );

      if (response.statusCode == 200) {
        // 后端统一格式：{"code":200, "data": {"recipes":[...], "candidates":[...]}}
        final bodyCode = response.data['code'] as int;
        if (bodyCode != 200) {
          throw Exception(response.data['message']?.toString() ?? '生成食谱失败');
        }
        final data = response.data['data'] as Map<String, dynamic>? ?? {};

        final recipes = (data['recipes'] as List<dynamic>? ?? [])
            .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
            .toList();

        final candidates = (data['candidates'] as List<dynamic>? ?? [])
            .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
            .toList();

        return GenerateResult(recipes: recipes, candidates: candidates);
      } else {
        throw Exception('生成食谱失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('生成食谱失败: $e');
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
