import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../config/theme.dart';

/// 食谱卡片组件
class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onReplace;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onReplace,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isReplacing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 执行替换动画
  Future<void> _handleReplace() async {
    if (_isReplacing) return;

    setState(() {
      _isReplacing = true;
    });

    // 执行翻转动画
    await _controller.forward();

    // 调用替换回调
    widget.onReplace();

    // 等待数据更新
    await Future.delayed(const Duration(milliseconds: 100));

    // 翻转回来
    await _controller.reverse();

    setState(() {
      _isReplacing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // 计算翻转角度
        final angle = _animation.value * 3.14159; // π
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: angle > 1.5708 // π/2
              ? Transform(
                  transform: Matrix4.identity()..rotateY(3.14159),
                  alignment: Alignment.center,
                  child: _buildCard(),
                )
              : _buildCard(),
        );
      },
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 图片
                Stack(
                  children: [
                    Hero(
                      tag: 'recipe_${widget.recipe.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.borderRadiusMedium),
                          topRight: Radius.circular(AppTheme.borderRadiusMedium),
                        ),
                        child: Image.network(
                          widget.recipe.imageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.restaurant,
                                size: 64,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // 替换按钮
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: _isReplacing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh),
                          onPressed: _isReplacing ? null : _handleReplace,
                          tooltip: '换一换',
                        ),
                      ),
                    ),
                  ],
                ),

                // 内容
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Text(
                        widget.recipe.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),

                      // 信息行
                      Row(
                        children: [
                          _buildInfoItem(
                            Icons.people,
                            '${widget.recipe.servings}人份',
                          ),
                          const SizedBox(width: 16),
                          _buildInfoItem(
                            Icons.timer,
                            '${widget.recipe.cookingTime}分钟',
                          ),
                          const SizedBox(width: 16),
                          _buildInfoItem(
                            Icons.star,
                            widget.recipe.difficulty,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 标签
                      if (widget.recipe.tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          children: widget.recipe.tags.take(3).map((tag) {
                            return Chip(
                              label: Text(
                                tag,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
