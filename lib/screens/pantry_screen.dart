import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/global_provider.dart';
import '../providers/user_provider.dart';
import '../config/theme.dart';
import 'result_screen.dart';

/// 虚拟冰箱页面
class PantryScreen extends StatelessWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pantryProvider = Provider.of<PantryProvider>(context);
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的冰箱'),
        actions: [
          if (pantryProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearDialog(context, pantryProvider),
              tooltip: '清空冰箱',
            ),
        ],
      ),
      body: pantryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : pantryProvider.items.isEmpty
              ? _buildEmptyState(context)
              : _buildPantryContent(context, pantryProvider, globalProvider, userProvider),
    );
  }

  /// 空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.kitchen_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            '冰箱空空如也',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '使用AR扫描添加食材吧',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// 冰箱内容
  Widget _buildPantryContent(
    BuildContext context,
    PantryProvider pantryProvider,
    GlobalProvider globalProvider,
    UserProvider userProvider,
  ) {
    // 按分类分组
    final Map<String, List> groupedItems = {};
    for (var item in pantryProvider.items) {
      if (!groupedItems.containsKey(item.category)) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add(item);
    }

    return Column(
      children: [
        // 统计信息
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.secondaryColor.withOpacity(0.1),
                AppTheme.accentColor.withOpacity(0.1),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                Icons.inventory_2_outlined,
                '${pantryProvider.itemCount}',
                '种食材',
              ),
              _buildStatItem(
                context,
                Icons.category_outlined,
                '${groupedItems.length}',
                '个分类',
              ),
            ],
          ),
        ),

        // 食材列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedItems.length,
            itemBuilder: (context, index) {
              final category = groupedItems.keys.elementAt(index);
              final items = groupedItems[category]!;

              return _buildCategorySection(context, category, items, pantryProvider);
            },
          ),
        ),

        // 底部按钮
        Container(
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
            child: ElevatedButton(
              onPressed: () => _cookWithPantry(
                context,
                pantryProvider,
                globalProvider,
                userProvider,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppTheme.secondaryColor,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu),
                  SizedBox(width: 12),
                  Text(
                    '用这些食材做菜',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 统计项
  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppTheme.secondaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// 分类区块
  Widget _buildCategorySection(
    BuildContext context,
    String category,
    List items,
    PantryProvider pantryProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Chip(
              avatar: item.weightInGrams != null
                  ? CircleAvatar(
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                      child: const Icon(
                        Icons.scale,
                        size: 16,
                        color: AppTheme.secondaryColor,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                      child: Text(
                        '${item.quantity.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
              label: Text(item.displayText),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => pantryProvider.removeItem(item.id),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey[300]!),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// 用冰箱食材做菜
  Future<void> _cookWithPantry(
    BuildContext context,
    PantryProvider pantryProvider,
    GlobalProvider globalProvider,
    UserProvider userProvider,
  ) async {
    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在生成食谱...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // 获取食材名称列表
      final ingredients = pantryProvider.getIngredientNames();

      // 调用生成食谱API（使用Mock）
      await globalProvider.generateRecipesFromIngredients(
        ingredients: ingredients,
        allergens: userProvider.user.allergens,
        servings: userProvider.user.defaultServings,
        preferences: userProvider.user.preferences,
      );

      // 关闭加载对话框
      if (context.mounted) {
        Navigator.pop(context);

        // 跳转到结果页
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResultScreen()),
        );
      }
    } catch (e) {
      // 关闭加载对话框
      if (context.mounted) {
        Navigator.pop(context);

        // 显示错误
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('生成食谱失败: $e')),
        );
      }
    }
  }

  /// 显示清空确认对话框
  void _showClearDialog(BuildContext context, PantryProvider pantryProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空冰箱'),
        content: const Text('确定要清空所有食材吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              pantryProvider.clearAll();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }
}
