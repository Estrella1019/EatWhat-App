import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/global_provider.dart';
import '../providers/user_provider.dart';
import '../config/theme.dart';
import 'result_screen.dart';

/// 虚拟冰箱页面 — Figma Harvest Warm 设计稿
class PantryScreen extends StatelessWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pantryProvider = Provider.of<PantryProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── 顶部导航栏 (Figma风格) ──
          _buildNavBar(context),
          // ── 内容区域 ──
          Expanded(
            child: pantryProvider.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : pantryProvider.items.isEmpty
                    ? _buildEmptyState(context)
                    : _buildPantryContent(context, pantryProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.outline.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                const Spacer(),
                const Text(
                  'EATWHAT',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    fontFamily: 'Manrope',
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_sweep, color: AppTheme.primary, size: 22),
                  onPressed: () {
                    // TODO: 批量清空功能
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
            color: AppTheme.outline.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your pantry is empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use AR scan to add ingredients',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  /// 冰箱内容
  Widget _buildPantryContent(BuildContext context, PantryProvider pantryProvider) {
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 16),

              // ── Stats Banner ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                ),
                child: Stack(
                  children: [
                    // Background icon
                    Positioned(
                      right: -24,
                      top: -24,
                      child: Icon(
                        Icons.kitchen,
                        size: 120,
                        color: AppTheme.textPrimary.withOpacity(0.05),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CURRENT INVENTORY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppTheme.secondary,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatValue('${pantryProvider.itemCount}', 'INGREDIENTS'),
                            Container(
                              width: 1,
                              height: 40,
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              color: AppTheme.outline.withOpacity(0.2),
                            ),
                            _buildStatValue('${groupedItems.length}', 'CATEGORIES'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Category Filter Chips ──
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: groupedItems.keys.map((category) {
                  return _CategoryChip(
                    label: category,
                    onRemove: () {
                      // TODO: 分类筛选移除功能
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // ── Item Cards Grid ──
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                ),
                itemCount: pantryProvider.items.length,
                itemBuilder: (context, index) {
                  final item = pantryProvider.items[index];
                  return _buildItemCard(context, item, pantryProvider);
                },
              ),
              const SizedBox(height: 120), // Space for FAB
            ],
          ),
        ),

        // ── Floating Cook Button ──
        Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _cookWithPantry(context, pantryProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'COOK WITH THESE INGREDIENTS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatValue(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
            fontFamily: 'Manrope',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, dynamic item, PantryProvider pantryProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: const Center(
                  child: Icon(Icons.eco, color: AppTheme.primary, size: 24),
                ),
              ),
              GestureDetector(
                onTap: () => pantryProvider.removeItem(item.id),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: AppTheme.error.withOpacity(0.4),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.displayText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontFamily: 'Inter',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.weightInGrams != null
                ? '${item.weightInGrams}g'
                : '${item.quantity.toInt()} Items',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  /// 用冰箱食材做菜
  Future<void> _cookWithPantry(BuildContext context, PantryProvider pantryProvider) async {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
                CircularProgressIndicator(color: AppTheme.primary),
                SizedBox(height: 16),
                Text('Generating recipes...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final ingredients = pantryProvider.getIngredientNames();
      await globalProvider.generateRecipesFromIngredients(
        ingredients: ingredients,
        allergens: userProvider.user.allergens,
        servings: userProvider.user.defaultServings,
        preferences: userProvider.user.preferences,
      );

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResultScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate recipes: $e')),
        );
      }
    }
  }
}

/// Figma风格分类标签
class _CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _CategoryChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 4, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textGreen,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
