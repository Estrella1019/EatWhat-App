import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';
import '../config/theme.dart';
import 'food_portion_input_screen.dart';
import 'pantry_screen.dart';

/// 食物重量估算演示页面
/// 展示YOLO识别后的重量输入流程
class FoodWeightDemoScreen extends StatefulWidget {
  const FoodWeightDemoScreen({super.key});

  @override
  State<FoodWeightDemoScreen> createState() => _FoodWeightDemoScreenState();
}

class _FoodWeightDemoScreenState extends State<FoodWeightDemoScreen> {
  // 模拟YOLO识别的结果
  final List<Map<String, String>> _detectedFoods = [
    {'name': '番茄', 'category': '蔬菜', 'confidence': '95%'},
    {'name': '鸡蛋', 'category': '蛋类', 'confidence': '92%'},
    {'name': '黄瓜', 'category': '蔬菜', 'confidence': '88%'},
    {'name': '五花肉', 'category': '肉类', 'confidence': '90%'},
  ];

  final List<bool> _addedStatus = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能重量估算演示'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          // 说明卡片
          _buildInfoCard(),

          // 识别结果列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _detectedFoods.length,
              itemBuilder: (context, index) {
                return _buildFoodCard(index);
              },
            ),
          ),

          // 底部按钮
          _buildBottomButtons(),
        ],
      ),
    );
  }

  /// 说明卡片
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'YOLO识别完成',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '检测到 ${_detectedFoods.length} 种食材，点击每个食材设置重量或份量',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 食物卡片
  Widget _buildFoodCard(int index) {
    final food = _detectedFoods[index];
    final isAdded = _addedStatus[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAdded ? Colors.green : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isAdded ? null : () => _showPortionInput(index),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 图标
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(food['category']!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(food['category']!),
                    color: _getCategoryColor(food['category']!),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                // 信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              food['category']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            food['confidence']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 状态图标
                if (isAdded)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 底部按钮
  Widget _buildBottomButtons() {
    final addedCount = _addedStatus.where((status) => status).length;
    final allAdded = addedCount == _detectedFoods.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 进度提示
            if (addedCount > 0 && !allAdded)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '已添加 $addedCount/${_detectedFoods.length} 种食材',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),

            // 按钮
            Row(
              children: [
                if (!allAdded)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _skipAll(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 56),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Text('全部跳过'),
                    ),
                  ),
                if (!allAdded) const SizedBox(width: 12),
                Expanded(
                  flex: allAdded ? 1 : 2,
                  child: ElevatedButton(
                    onPressed: addedCount > 0 ? () => _goToPantry() : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                      backgroundColor: AppTheme.secondaryColor,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: Text(
                      allAdded ? '查看冰箱' : '完成 ($addedCount)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 显示份量输入页面
  Future<void> _showPortionInput(int index) async {
    final food = _detectedFoods[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodPortionInputScreen(
          foodName: food['name']!,
          category: food['category']!,
        ),
      ),
    );

    if (result != null && mounted) {
      // 添加到冰箱
      final pantryProvider = Provider.of<PantryProvider>(context, listen: false);
      pantryProvider.addItem(result);

      setState(() {
        _addedStatus[index] = true;
      });

      // 显示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${food['name']} 已添加到冰箱'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  /// 跳过所有
  void _skipAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('跳过确认'),
        content: const Text('确定要跳过所有未添加的食材吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _goToPantry();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 前往冰箱页面
  void _goToPantry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PantryScreen(),
      ),
    );
  }

  /// 获取分类图标
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '蔬菜':
        return Icons.eco;
      case '水果':
        return Icons.apple;
      case '肉类':
        return Icons.set_meal;
      case '海鲜':
        return Icons.phishing;
      case '主食':
        return Icons.rice_bowl;
      case '奶制品':
        return Icons.local_drink;
      case '蛋类':
        return Icons.egg;
      default:
        return Icons.fastfood;
    }
  }

  /// 获取分类颜色
  Color _getCategoryColor(String category) {
    switch (category) {
      case '蔬菜':
        return Colors.green;
      case '水果':
        return Colors.orange;
      case '肉类':
        return Colors.red;
      case '海鲜':
        return Colors.blue;
      case '主食':
        return Colors.brown;
      case '奶制品':
        return Colors.purple;
      case '蛋类':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
