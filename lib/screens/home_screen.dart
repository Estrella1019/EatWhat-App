import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../providers/pantry_provider.dart';
import '../providers/global_provider.dart';
import '../services/media_service.dart';
import '../config/theme.dart';
import 'pantry_screen.dart';
import 'result_screen.dart';
import 'food_weight_demo_screen.dart';
import 'camera_scan_demo_screen.dart';

/// 首页 - Figma Harvest Warm 设计（带图片美化）
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 美食图片URL
  static const _heroImage = 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&h=400&fit=crop';
  static const _scanImage = 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=600&h=400&fit=crop';
  static const _photoImage = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop';
  static const _fridgeImage = 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=400&h=300&fit=crop';
  static const _scaleImage = 'https://images.unsplash.com/photo-1490818387583-1baba5e638af?w=400&h=300&fit=crop';

  @override
  Widget build(BuildContext context) {
    final pantryProvider = Provider.of<PantryProvider>(context);
    final S = AppLocalizations.of(context);

    if (S == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Figma风格顶部导航栏
          FigmaAppBar(title: 'EATWHAT'),
          // 内容
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20),

                // ── Hero Banner 带图片 ──
                _buildHeroBanner(context, S),
                const SizedBox(height: 24),

                // ── AR扫描卡片 ──
                _buildScanCard(context, S),
                const SizedBox(height: 24),

                // ── 快捷功能 ──
                _buildQuickActions(context, S, pantryProvider),
                const SizedBox(height: 28),

                // ── 今日推荐 ──
                _buildTodayPicks(S),
                const SizedBox(height: 28),

                // ── 冰箱预览 ──
                if (pantryProvider.items.isNotEmpty)
                  _buildPantryPreview(context, pantryProvider, S),

                // ── 空状态 ──
                if (pantryProvider.items.isEmpty)
                  _buildEmptyPantry(context, S),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hero Banner — 带背景图片的欢迎区域
  Widget _buildHeroBanner(BuildContext context, AppLocalizations S) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        image: const DecorationImage(
          image: NetworkImage(_heroImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primary.withOpacity(0.7),
              AppTheme.primary.withOpacity(0.95),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              S.todayEatWhat,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: 'Manrope',
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              S.realtimeRecognition,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.85),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AR扫描卡片 — 带图片背景
  Widget _buildScanCard(BuildContext context, AppLocalizations S) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraScanDemoScreen()));
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          image: const DecorationImage(
            image: NetworkImage(_scanImage),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF667EEA).withOpacity(0.9),
                const Color(0xFF764BA2).withOpacity(0.85),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'YOLO-World AI',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      S.smartARScan,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.startScan,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 快捷功能 — 带图片背景的卡片
  Widget _buildQuickActions(BuildContext context, AppLocalizations S, PantryProvider pantryProvider) {
    return Row(
      children: [
        Expanded(
          child: _ImageActionCard(
            imageUrl: _photoImage,
            label: S.photoRecognition,
            icon: Icons.photo_library_outlined,
            onTap: () async {
              final mediaService = MediaService();
              final imageBytes = await mediaService.pickFromGallery();
              if (imageBytes != null && context.mounted) {
                final gp = Provider.of<GlobalProvider>(context, listen: false);
                await gp.identifyAndGenerateRecipes(imageBytes: imageBytes);
                if (context.mounted) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
                }
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ImageActionCard(
            imageUrl: _fridgeImage,
            label: S.myFridge,
            icon: Icons.kitchen_outlined,
            badge: pantryProvider.itemCount > 0 ? '${pantryProvider.itemCount}' : null,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PantryScreen()));
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ImageActionCard(
            imageUrl: _scaleImage,
            label: S.weightEstimation,
            icon: Icons.scale_outlined,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodWeightDemoScreen()));
            },
          ),
        ),
      ],
    );
  }

  /// 今日推荐 — 横向滚动食谱卡片
  Widget _buildTodayPicks(AppLocalizations S) {
    final recipes = [
      _RecipeInfo('Avocado Toast', '350 Kcal', '15 min', 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400&h=300&fit=crop'),
      _RecipeInfo('Salmon Poke Bowl', '420 Kcal', '20 min', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop'),
      _RecipeInfo('Keto Burger', '580 Kcal', '25 min', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop'),
      _RecipeInfo('Italian Pizza', '650 Kcal', '30 min', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.todayTrending,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                fontFamily: 'Manrope',
              ),
            ),
            Text(
              S.viewMore,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final r = recipes[index];
              return _RecipeCard(recipe: r);
            },
          ),
        ),
      ],
    );
  }

  /// 冰箱预览
  Widget _buildPantryPreview(BuildContext context, PantryProvider pantryProvider, AppLocalizations S) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.myFridge,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                fontFamily: 'Manrope',
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantryScreen())),
              child: Text(
                S.viewAll,
                style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.kitchen_outlined, color: AppTheme.secondary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.ingredientCount(pantryProvider.itemCount),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pantryProvider.items.take(6).map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLow,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(item.name, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontFamily: 'Inter')),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              GradientButton(
                label: S.cookWithThese,
                icon: Icons.restaurant_menu,
                height: 48,
                onPressed: () async {
                  final gp = Provider.of<GlobalProvider>(context, listen: false);
                  final up = Provider.of<UserProvider>(context, listen: false);
                  try {
                    await gp.generateRecipesFromIngredients(
                      ingredients: pantryProvider.getIngredientNames(),
                      allergens: up.user.allergens,
                      servings: up.user.defaultServings,
                      preferences: up.user.preferences,
                    );
                    if (context.mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.generationFailed(e.toString()))));
                    }
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  /// 空冰箱状态
  Widget _buildEmptyPantry(BuildContext context, AppLocalizations S) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Column(
        children: [
          Icon(Icons.kitchen_outlined, size: 64, color: AppTheme.outline.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            S.emptyPantry,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontFamily: 'Manrope'),
          ),
          const SizedBox(height: 8),
          Text(
            S.addIngredientsToStart,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: S.startScan,
            icon: Icons.photo_camera,
            width: 200,
            height: 48,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraScanDemoScreen())),
          ),
        ],
      ),
    );
  }
}

/// 带图片背景的快捷功能卡片
class _ImageActionCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final IconData icon;
  final String? badge;
  final VoidCallback onTap;

  const _ImageActionCard({
    required this.imageUrl,
    required this.label,
    required this.icon,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 食谱信息
class _RecipeInfo {
  final String name;
  final String calories;
  final String time;
  final String imageUrl;
  const _RecipeInfo(this.name, this.calories, this.time, this.imageUrl);
}

/// 食谱推荐卡片
class _RecipeCard extends StatelessWidget {
  final _RecipeInfo recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        color: Colors.white,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              recipe.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: AppTheme.surfaceContainer,
                child: const Icon(Icons.restaurant, size: 40, color: AppTheme.primary),
              ),
            ),
          ),
          // 信息
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 13, color: Color(0xFFFF8A65)),
                    const SizedBox(width: 3),
                    Text(recipe.calories, style: const TextStyle(fontSize: 10, color: AppTheme.textHint)),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time, size: 13, color: AppTheme.primary),
                    const SizedBox(width: 3),
                    Text(recipe.time, style: const TextStyle(fontSize: 10, color: AppTheme.textHint)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
