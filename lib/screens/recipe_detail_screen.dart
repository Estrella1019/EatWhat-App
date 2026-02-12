import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/recipe.dart';
import '../config/theme.dart';

/// 食谱详情页面 - 参考Hungry App的RecipeDetailPage设计
class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      changeAppBarColor(_scrollController);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {
          appBarColor = AppTheme.primaryColor;
        });
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AnimatedContainer(
          color: appBarColor,
          duration: const Duration(milliseconds: 200),
          child: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '食谱详情',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Recipe Image
          GestureDetector(
            onTap: () {
              // 可以添加全屏查看图片功能
            },
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.recipe.imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // 图片加载失败处理
                  },
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                height: 280,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Section 2 - Recipe Info
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
            color: AppTheme.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Time and Servings
                Row(
                  children: [
                    const Icon(Icons.alarm, size: 16, color: Colors.white),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Text(
                        '${widget.recipe.cookingTime}分钟',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.people, size: 16, color: Colors.white),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Text(
                        '${widget.recipe.servings}人份',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.star, size: 16, color: Colors.white),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Text(
                        widget.recipe.difficulty,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                // Recipe Title
                Container(
                  margin: const EdgeInsets.only(bottom: 12, top: 16),
                  child: Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Recipe Tags
                if (widget.recipe.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.recipe.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          // Tabbar ( Ingredients, Steps )
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: AppTheme.secondaryColor,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: '食材'),
                Tab(text: '步骤'),
              ],
            ),
          ),
          // IndexedStack based on TabBar index
          IndexedStack(
            index: _tabController.index,
            children: [
              // Ingredients
              _buildIngredientsTab(),
              // Steps
              _buildStepsTab(),
            ],
          ),
        ],
      ),
    );
  }

  /// 食材标签页
  Widget _buildIngredientsTab() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.recipe.ingredients.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _IngredientTile(
          ingredient: widget.recipe.ingredients[index],
        );
      },
    );
  }

  /// 步骤标签页
  Widget _buildStepsTab() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: widget.recipe.steps.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _StepTile(
          stepNumber: index + 1,
          step: widget.recipe.steps[index],
        );
      },
    );
  }
}

/// 食材项
class _IngredientTile extends StatelessWidget {
  final String ingredient;

  const _IngredientTile({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              ingredient,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 步骤项
class _StepTile extends StatelessWidget {
  final int stepNumber;
  final String step;

  const _StepTile({
    required this.stepNumber,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                step,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
