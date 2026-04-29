import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import 'food_portion_input_screen.dart';
import 'pantry_screen.dart';

/// 食物重量估算演示页面
class FoodWeightDemoScreen extends StatefulWidget {
  const FoodWeightDemoScreen({super.key});

  @override
  State<FoodWeightDemoScreen> createState() => _FoodWeightDemoScreenState();
}

class _FoodWeightDemoScreenState extends State<FoodWeightDemoScreen> {
  final List<Map<String, String>> _detectedFoods = [
    {'name': '番茄', 'category': '蔬菜', 'confidence': '95%'},
    {'name': '鸡蛋', 'category': '蛋类', 'confidence': '92%'},
    {'name': '黄瓜', 'category': '蔬菜', 'confidence': '88%'},
    {'name': '五花肉', 'category': '肉类', 'confidence': '90%'},
  ];

  final List<bool> _addedStatus = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context);
    if (S == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.weightDemo),
        backgroundColor: AppTheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildInfoCard(S),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _detectedFoods.length,
              itemBuilder: (context, index) {
                return _buildFoodCard(index, S);
              },
            ),
          ),
          _buildBottomButtons(S),
        ],
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations S) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withOpacity(0.1),
            AppTheme.primaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.3),
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
                  color: AppTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  S.yoloComplete,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(int index, AppLocalizations S) {
    final food = _detectedFoods[index];
    final isAdded = _addedStatus[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAdded ? Colors.green : AppTheme.primaryContainer,
          child: Icon(
            isAdded ? Icons.check : Icons.restaurant,
            color: isAdded ? Colors.white : AppTheme.primary,
          ),
        ),
        title: Text(
          food['name']!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${food['category']} | ${food['confidence']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: ElevatedButton(
          onPressed: isAdded ? null : () => _showPortionInput(index, S),
          style: ElevatedButton.styleFrom(
            backgroundColor: isAdded ? Colors.grey : AppTheme.primary,
          ),
          child: Text(isAdded ? S.historyDeleted : S.add),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(AppLocalizations S) {
    final addedCount = _addedStatus.where((s) => s).length;
    final allAdded = addedCount == _detectedFoods.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.addedCountOf(addedCount, _detectedFoods.length),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!allAdded)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _skipAll(S),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: Text(S.skipAll),
                  ),
                ),
              if (!allAdded) const SizedBox(width: 12),
              Expanded(
                flex: allAdded ? 1 : 2,
                child: ElevatedButton(
                  onPressed: addedCount > 0 ? () => _goToPantry() : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    backgroundColor: AppTheme.primaryContainer,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    allAdded ? S.viewFridge : S.doneCount(addedCount),
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
    );
  }

  Future<void> _showPortionInput(int index, AppLocalizations S) async {
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
      final pantryProvider = Provider.of<PantryProvider>(context, listen: false);
      pantryProvider.addItem(result);

      setState(() {
        _addedStatus[index] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.addedToFridge(food['name']!)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _skipAll(AppLocalizations S) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.skipConfirm),
        content: Text(S.skipAllMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(S.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(S.skipAll),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      Navigator.pop(context);
    }
  }

  void _goToPantry() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PantryScreen()),
    );
  }
}