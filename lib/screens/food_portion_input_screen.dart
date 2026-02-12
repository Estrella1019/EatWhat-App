import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/food_portion_data.dart';
import '../models/pantry.dart';

/// 食物份量输入页面
/// 在YOLO识别后，让用户选择或输入食物的重量/数量
class FoodPortionInputScreen extends StatefulWidget {
  final String foodName;
  final String category;
  final VoidCallback? onSkip;

  const FoodPortionInputScreen({
    super.key,
    required this.foodName,
    this.category = '其他',
    this.onSkip,
  });

  @override
  State<FoodPortionInputScreen> createState() => _FoodPortionInputScreenState();
}

class _FoodPortionInputScreenState extends State<FoodPortionInputScreen> {
  final FoodPortionDatabase _database = FoodPortionDatabase();
  late FoodPortionData _portionData;

  // 选中的份量选项索引
  int? _selectedPortionIndex;

  // 自定义输入模式
  bool _isCustomMode = false;
  final TextEditingController _customWeightController = TextEditingController();
  String _customUnit = 'g';

  @override
  void initState() {
    super.initState();
    // 获取食物份量数据
    _portionData = _database.getPortionData(widget.foodName) ??
        _database.getDefaultPortionData(widget.foodName);
  }

  @override
  void dispose() {
    _customWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('确认食材份量'),
        actions: [
          if (widget.onSkip != null)
            TextButton(
              onPressed: widget.onSkip,
              child: const Text('跳过'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 食物信息卡片
                _buildFoodInfoCard(),
                const SizedBox(height: 24),

                // 方法选择提示
                _buildMethodSelector(),
                const SizedBox(height: 20),

                // 快速选择模式
                if (!_isCustomMode) ...[
                  _buildQuickSelectSection(),
                ] else ...[
                  _buildCustomInputSection(),
                ],

                const SizedBox(height: 24),

                // 参考信息
                _buildReferenceInfo(),
              ],
            ),
          ),

          // 底部确认按钮
          _buildBottomButton(),
        ],
      ),
    );
  }

  /// 食物信息卡片
  Widget _buildFoodInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(widget.category),
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 方法选择器
  Widget _buildMethodSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildMethodButton(
            icon: Icons.touch_app,
            label: '快速选择',
            isSelected: !_isCustomMode,
            onTap: () => setState(() => _isCustomMode = false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMethodButton(
            icon: Icons.edit,
            label: '自定义输入',
            isSelected: _isCustomMode,
            onTap: () => setState(() => _isCustomMode = true),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 快速选择区域
  Widget _buildQuickSelectSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择份量',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _portionData.portions.length,
          itemBuilder: (context, index) {
            final portion = _portionData.portions[index];
            final isSelected = _selectedPortionIndex == index;

            return InkWell(
              onTap: () => setState(() => _selectedPortionIndex = index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      portion.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (portion.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        portion.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 自定义输入区域
  Widget _buildCustomInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '输入重量',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _customWeightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  hintText: '输入数量',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _customUnit,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: ['g', 'kg', '个', '份', 'ml', 'L']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _customUnit = value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 参考信息
  Widget _buildReferenceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                '参考信息',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 如果不确定重量，可以选择"适量"或"中份"\n'
            '• 系统会根据常见份量智能估算\n'
            '• 后续可以在冰箱中修改数量',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[900],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 底部确认按钮
  Widget _buildBottomButton() {
    final canConfirm = _isCustomMode
        ? _customWeightController.text.isNotEmpty
        : _selectedPortionIndex != null;

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
        child: ElevatedButton(
          onPressed: canConfirm ? _confirmAndReturn : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: Theme.of(context).primaryColor,
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: const Text(
            '确认添加',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  /// 确认并返回
  void _confirmAndReturn() {
    double weightInGrams;
    double quantity;
    String unit;

    if (_isCustomMode) {
      // 自定义输入模式
      final inputValue = double.tryParse(_customWeightController.text) ?? 0;
      unit = _customUnit;

      // 转换为克
      switch (_customUnit) {
        case 'kg':
          weightInGrams = inputValue * 1000;
          quantity = inputValue;
          break;
        case 'L':
          weightInGrams = inputValue * 1000 * (_portionData.density ?? 1.0);
          quantity = inputValue;
          break;
        case 'ml':
          weightInGrams = inputValue * (_portionData.density ?? 1.0);
          quantity = inputValue;
          break;
        default:
          weightInGrams = inputValue;
          quantity = inputValue;
      }
    } else {
      // 快速选择模式
      final portion = _portionData.portions[_selectedPortionIndex!];
      weightInGrams = portion.grams;
      quantity = 1;
      unit = portion.label;
    }

    // 创建PantryItem并返回
    final item = PantryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: widget.foodName,
      quantity: quantity,
      unit: unit,
      addedDate: DateTime.now(),
      category: widget.category,
      weightInGrams: weightInGrams,
    );

    Navigator.pop(context, item);
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
}
