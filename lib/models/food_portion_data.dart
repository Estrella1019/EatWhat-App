/// 食物份量数据库
/// 基于营养学标准和常见食材份量
class FoodPortionData {
  // 食物名称
  final String name;

  // 标准份量选项（克）
  final List<PortionOption> portions;

  // 默认单位
  final String defaultUnit;

  // 密度（g/ml）用于体积转换
  final double? density;

  FoodPortionData({
    required this.name,
    required this.portions,
    this.defaultUnit = 'g',
    this.density,
  });
}

/// 份量选项
class PortionOption {
  final String label; // 显示标签，如"小份"、"1个"
  final double grams; // 对应克数
  final String? description; // 描述，如"约100g"

  PortionOption({
    required this.label,
    required this.grams,
    this.description,
  });
}

/// 食物份量数据库
class FoodPortionDatabase {
  // 单例模式
  static final FoodPortionDatabase _instance = FoodPortionDatabase._internal();
  factory FoodPortionDatabase() => _instance;
  FoodPortionDatabase._internal();

  // 食物份量数据映射
  final Map<String, FoodPortionData> _database = {
    // 蔬菜类
    '番茄': FoodPortionData(
      name: '番茄',
      defaultUnit: '个',
      density: 0.95,
      portions: [
        PortionOption(label: '小个', grams: 80, description: '约80g'),
        PortionOption(label: '中个', grams: 150, description: '约150g'),
        PortionOption(label: '大个', grams: 250, description: '约250g'),
      ],
    ),
    '黄瓜': FoodPortionData(
      name: '黄瓜',
      defaultUnit: '根',
      density: 0.96,
      portions: [
        PortionOption(label: '半根', grams: 100, description: '约100g'),
        PortionOption(label: '1根', grams: 200, description: '约200g'),
        PortionOption(label: '2根', grams: 400, description: '约400g'),
      ],
    ),
    '胡萝卜': FoodPortionData(
      name: '胡萝卜',
      defaultUnit: '根',
      density: 0.98,
      portions: [
        PortionOption(label: '小根', grams: 80, description: '约80g'),
        PortionOption(label: '中根', grams: 150, description: '约150g'),
        PortionOption(label: '大根', grams: 250, description: '约250g'),
      ],
    ),
    '土豆': FoodPortionData(
      name: '土豆',
      defaultUnit: '个',
      density: 1.08,
      portions: [
        PortionOption(label: '小个', grams: 100, description: '约100g'),
        PortionOption(label: '中个', grams: 200, description: '约200g'),
        PortionOption(label: '大个', grams: 350, description: '约350g'),
      ],
    ),
    '洋葱': FoodPortionData(
      name: '洋葱',
      defaultUnit: '个',
      density: 1.05,
      portions: [
        PortionOption(label: '小个', grams: 100, description: '约100g'),
        PortionOption(label: '中个', grams: 200, description: '约200g'),
        PortionOption(label: '大个', grams: 300, description: '约300g'),
      ],
    ),
    '青椒': FoodPortionData(
      name: '青椒',
      defaultUnit: '个',
      density: 0.92,
      portions: [
        PortionOption(label: '1个', grams: 150, description: '约150g'),
        PortionOption(label: '2个', grams: 300, description: '约300g'),
        PortionOption(label: '3个', grams: 450, description: '约450g'),
      ],
    ),
    '白菜': FoodPortionData(
      name: '白菜',
      defaultUnit: 'g',
      density: 0.95,
      portions: [
        PortionOption(label: '小份', grams: 200, description: '约200g'),
        PortionOption(label: '中份', grams: 500, description: '约500g'),
        PortionOption(label: '大份', grams: 1000, description: '约1kg'),
      ],
    ),
    '生菜': FoodPortionData(
      name: '生菜',
      defaultUnit: 'g',
      density: 0.95,
      portions: [
        PortionOption(label: '小份', grams: 100, description: '约100g'),
        PortionOption(label: '中份', grams: 250, description: '约250g'),
        PortionOption(label: '1颗', grams: 500, description: '约500g'),
      ],
    ),

    // 肉类
    '鸡胸肉': FoodPortionData(
      name: '鸡胸肉',
      defaultUnit: 'g',
      density: 1.05,
      portions: [
        PortionOption(label: '小份', grams: 100, description: '约100g'),
        PortionOption(label: '中份', grams: 200, description: '约200g'),
        PortionOption(label: '1块', grams: 250, description: '约250g'),
        PortionOption(label: '大份', grams: 500, description: '约500g'),
      ],
    ),
    '猪肉': FoodPortionData(
      name: '猪肉',
      defaultUnit: 'g',
      density: 1.04,
      portions: [
        PortionOption(label: '小份', grams: 150, description: '约150g'),
        PortionOption(label: '中份', grams: 300, description: '约300g'),
        PortionOption(label: '大份', grams: 500, description: '约500g'),
      ],
    ),
    '牛肉': FoodPortionData(
      name: '牛肉',
      defaultUnit: 'g',
      density: 1.05,
      portions: [
        PortionOption(label: '小份', grams: 150, description: '约150g'),
        PortionOption(label: '中份', grams: 300, description: '约300g'),
        PortionOption(label: '大份', grams: 500, description: '约500g'),
      ],
    ),

    // 海鲜类
    '三文鱼': FoodPortionData(
      name: '三文鱼',
      defaultUnit: 'g',
      density: 1.05,
      portions: [
        PortionOption(label: '1片', grams: 120, description: '约120g'),
        PortionOption(label: '2片', grams: 240, description: '约240g'),
        PortionOption(label: '中份', grams: 300, description: '约300g'),
      ],
    ),
    '虾': FoodPortionData(
      name: '虾',
      defaultUnit: 'g',
      density: 1.02,
      portions: [
        PortionOption(label: '小份', grams: 100, description: '约10只'),
        PortionOption(label: '中份', grams: 200, description: '约20只'),
        PortionOption(label: '大份', grams: 500, description: '约50只'),
      ],
    ),

    // 水果类
    '苹果': FoodPortionData(
      name: '苹果',
      defaultUnit: '个',
      density: 0.83,
      portions: [
        PortionOption(label: '小个', grams: 150, description: '约150g'),
        PortionOption(label: '中个', grams: 200, description: '约200g'),
        PortionOption(label: '大个', grams: 300, description: '约300g'),
      ],
    ),
    '香蕉': FoodPortionData(
      name: '香蕉',
      defaultUnit: '根',
      density: 0.94,
      portions: [
        PortionOption(label: '1根', grams: 120, description: '约120g'),
        PortionOption(label: '2根', grams: 240, description: '约240g'),
        PortionOption(label: '3根', grams: 360, description: '约360g'),
      ],
    ),
    '橙子': FoodPortionData(
      name: '橙子',
      defaultUnit: '个',
      density: 0.87,
      portions: [
        PortionOption(label: '小个', grams: 150, description: '约150g'),
        PortionOption(label: '中个', grams: 200, description: '约200g'),
        PortionOption(label: '大个', grams: 300, description: '约300g'),
      ],
    ),

    // 蛋类
    '鸡蛋': FoodPortionData(
      name: '鸡蛋',
      defaultUnit: '个',
      density: 1.03,
      portions: [
        PortionOption(label: '1个', grams: 50, description: '约50g'),
        PortionOption(label: '2个', grams: 100, description: '约100g'),
        PortionOption(label: '6个', grams: 300, description: '约300g'),
      ],
    ),

    // 主食类
    '米饭': FoodPortionData(
      name: '米饭',
      defaultUnit: 'g',
      density: 1.25,
      portions: [
        PortionOption(label: '小碗', grams: 150, description: '约150g'),
        PortionOption(label: '中碗', grams: 250, description: '约250g'),
        PortionOption(label: '大碗', grams: 400, description: '约400g'),
      ],
    ),
    '面条': FoodPortionData(
      name: '面条',
      defaultUnit: 'g',
      density: 1.1,
      portions: [
        PortionOption(label: '小份', grams: 100, description: '干面约100g'),
        PortionOption(label: '中份', grams: 150, description: '干面约150g'),
        PortionOption(label: '大份', grams: 250, description: '干面约250g'),
      ],
    ),
    '面包': FoodPortionData(
      name: '面包',
      defaultUnit: '片',
      density: 0.28,
      portions: [
        PortionOption(label: '1片', grams: 40, description: '约40g'),
        PortionOption(label: '2片', grams: 80, description: '约80g'),
        PortionOption(label: '半个', grams: 150, description: '约150g'),
      ],
    ),

    // 奶制品
    '牛奶': FoodPortionData(
      name: '牛奶',
      defaultUnit: 'ml',
      density: 1.03,
      portions: [
        PortionOption(label: '1杯', grams: 250, description: '约250ml'),
        PortionOption(label: '1盒', grams: 500, description: '约500ml'),
        PortionOption(label: '1升', grams: 1000, description: '约1L'),
      ],
    ),
    '酸奶': FoodPortionData(
      name: '酸奶',
      defaultUnit: 'ml',
      density: 1.05,
      portions: [
        PortionOption(label: '小杯', grams: 100, description: '约100ml'),
        PortionOption(label: '中杯', grams: 200, description: '约200ml'),
        PortionOption(label: '大杯', grams: 400, description: '约400ml'),
      ],
    ),
  };

  /// 获取食物份量数据
  FoodPortionData? getPortionData(String foodName) {
    // 精确匹配
    if (_database.containsKey(foodName)) {
      return _database[foodName];
    }

    // 模糊匹配
    for (var entry in _database.entries) {
      if (foodName.contains(entry.key) || entry.key.contains(foodName)) {
        return entry.value;
      }
    }

    // 未找到，返回默认
    return null;
  }

  /// 获取默认份量数据（用于未知食物）
  FoodPortionData getDefaultPortionData(String foodName) {
    return FoodPortionData(
      name: foodName,
      defaultUnit: 'g',
      portions: [
        PortionOption(label: '少量', grams: 50, description: '约50g'),
        PortionOption(label: '适量', grams: 100, description: '约100g'),
        PortionOption(label: '中量', grams: 200, description: '约200g'),
        PortionOption(label: '较多', grams: 500, description: '约500g'),
      ],
    );
  }

  /// 获取所有食物名称
  List<String> getAllFoodNames() {
    return _database.keys.toList();
  }

  /// 添加自定义食物数据
  void addCustomFood(String name, FoodPortionData data) {
    _database[name] = data;
  }
}
