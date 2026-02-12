import 'dart:typed_data';
import 'dart:math';
import '../models/recipe.dart';
import '../models/ingredient.dart';

/// Mock API服务 - 用于开发阶段模拟后端响应（匹配后端接口设计）
class MockApiService {
  static MockApiService? _instance;

  MockApiService._();

  static MockApiService getInstance() {
    _instance ??= MockApiService._();
    return _instance!;
  }

  /// 步骤1: 模拟识别食材
  /// 对应后端接口: POST /api/identify
  Future<IdentifyResult> identifyIngredients({
    required Uint8List imageBytes,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    print('Mock API: 识别图片 (${(imageBytes.length / 1024).toStringAsFixed(2)} KB)');

    // 返回模拟的食材识别结果
    return IdentifyResult(
      ingredients: [
        Ingredient(name: '番茄', count: 2, confidence: 0.95),
        Ingredient(name: '鸡蛋', count: 3, confidence: 0.92),
        Ingredient(name: '五花肉', count: 1, confidence: 0.88),
        Ingredient(name: '黄瓜', count: 1, confidence: 0.90),
      ],
      totalItems: 4,
      imageHash: 'mock_hash_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// 步骤2: 模拟生成食谱
  /// 对应后端接口: POST /api/generate_recipes
  Future<List<Recipe>> generateRecipes({
    required List<String> ingredients,
    required List<String> allergens,
    required int servings,
    List<String>? preferences,
    String? customText,
  }) async {
    // 模拟网络延迟（大模型生成需要时间）
    await Future.delayed(const Duration(seconds: 2));

    print('Mock API: 生成食谱');
    print('Mock API: 食材 - $ingredients');
    print('Mock API: 过敏原 - $allergens');
    print('Mock API: 就餐人数 - $servings');
    if (preferences != null) print('Mock API: 口味偏好 - $preferences');
    if (customText != null) print('Mock API: 自定义文本 - $customText');

    // 返回模拟食谱
    return _getMockRecipes(servings);
  }

  /// 模拟获取单个新食谱
  /// 对应后端接口: POST /api/get_one_recipe
  Future<Recipe> getOneRecipe({
    required List<String> excludeIds,
    required List<String> ingredients,
    required List<String> allergens,
    required int servings,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    print('Mock API: 获取新食谱，排除ID: $excludeIds');
    print('Mock API: 基于食材: $ingredients');

    // 随机返回一个食谱
    List<Recipe> allRecipes = _getAllMockRecipes();
    allRecipes.removeWhere((recipe) => excludeIds.contains(recipe.id));

    if (allRecipes.isEmpty) {
      allRecipes = _getAllMockRecipes();
    }

    return allRecipes[Random().nextInt(allRecipes.length)];
  }

  /// 获取模拟食谱列表
  List<Recipe> _getMockRecipes(int servings) {
    return [
      Recipe(
        id: '1',
        name: '番茄炒蛋',
        imageUrl: 'https://picsum.photos/400/300?random=1',
        ingredients: [
          '番茄 ${servings * 2}个',
          '鸡蛋 ${servings * 3}个',
          '葱花 适量',
          '盐 适量',
          '糖 1勺',
        ],
        steps: [
          '番茄切块，鸡蛋打散',
          '热锅倒油，炒鸡蛋至凝固盛出',
          '锅中加油，炒番茄至软烂',
          '加入鸡蛋，调入盐和糖',
          '翻炒均匀，撒葱花出锅',
        ],
        servings: servings,
        cookingTime: 15,
        difficulty: '简单',
        tags: ['家常菜', '快手菜'],
      ),
      Recipe(
        id: '2',
        name: '红烧肉',
        imageUrl: 'https://picsum.photos/400/300?random=2',
        ingredients: [
          '五花肉 ${servings * 250}g',
          '冰糖 20g',
          '生抽 2勺',
          '老抽 1勺',
          '料酒 2勺',
          '八角 2个',
          '桂皮 1块',
        ],
        steps: [
          '五花肉切块，冷水下锅焯水',
          '锅中放冰糖炒糖色',
          '加入五花肉翻炒上色',
          '加入调料和热水，大火烧开',
          '转小火炖1小时，大火收汁',
        ],
        servings: servings,
        cookingTime: 90,
        difficulty: '中等',
        tags: ['家常菜', '肉菜'],
      ),
      Recipe(
        id: '3',
        name: '拍黄瓜',
        imageUrl: 'https://picsum.photos/400/300?random=3',
        ingredients: [
          '黄瓜 ${servings}根',
          '大蒜 3瓣',
          '香油 1勺',
          '醋 2勺',
          '生抽 1勺',
          '盐 适量',
        ],
        steps: [
          '黄瓜洗净，用刀拍碎',
          '切成小段，加盐腌制10分钟',
          '大蒜切末',
          '倒掉腌出的水分',
          '加入调料拌匀即可',
        ],
        servings: servings,
        cookingTime: 10,
        difficulty: '简单',
        tags: ['凉菜', '素菜'],
      ),
    ];
  }

  /// 获取所有模拟食谱（用于替换）
  List<Recipe> _getAllMockRecipes() {
    return [
      ..._getMockRecipes(2),
      Recipe(
        id: '4',
        name: '宫保鸡丁',
        imageUrl: 'https://picsum.photos/400/300?random=4',
        ingredients: ['鸡胸肉 300g', '花生米 50g', '干辣椒 10个', '葱姜蒜 适量'],
        steps: ['鸡肉切丁腌制', '炒花生米', '炒鸡丁', '加调料翻炒', '出锅'],
        servings: 2,
        cookingTime: 20,
        difficulty: '中等',
        tags: ['川菜', '肉菜'],
      ),
      Recipe(
        id: '5',
        name: '麻婆豆腐',
        imageUrl: 'https://picsum.photos/400/300?random=5',
        ingredients: ['豆腐 1块', '肉末 100g', '豆瓣酱 2勺', '花椒粉 适量'],
        steps: ['豆腐切块焯水', '炒肉末', '加豆瓣酱', '加豆腐煮', '勾芡出锅'],
        servings: 2,
        cookingTime: 15,
        difficulty: '简单',
        tags: ['川菜', '豆制品'],
      ),
      Recipe(
        id: '6',
        name: '清蒸鲈鱼',
        imageUrl: 'https://picsum.photos/400/300?random=6',
        ingredients: ['鲈鱼 1条', '葱姜 适量', '蒸鱼豉油 2勺', '料酒 1勺'],
        steps: ['鲈鱼处理干净', '抹料酒腌制', '上锅蒸8分钟', '淋热油', '浇豉油'],
        servings: 2,
        cookingTime: 20,
        difficulty: '简单',
        tags: ['海鲜', '清淡'],
      ),
    ];
  }
}
