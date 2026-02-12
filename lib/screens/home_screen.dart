import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../providers/pantry_provider.dart';
import '../services/media_service.dart';
import '../config/theme.dart';
import 'profile_screen.dart';
import 'pantry_screen.dart';
import 'camera_scan_demo_screen.dart';
import 'result_screen.dart';
import 'food_weight_demo_screen.dart';
import '../providers/global_provider.dart';

/// 首页 - 参考Hungry App设计
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pantryProvider = Provider.of<PantryProvider>(context);
    final S = AppLocalizations.of(context);

    // 如果本地化还未加载，显示加载中
    if (S == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Text(
          S.todayEatWhat,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Featured Recipe (AR扫描) - Wrapper
          Container(
            height: 350,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  height: 245,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&h=400&fit=crop'),
                      fit: BoxFit.cover,
                    ),
                    color: AppTheme.primaryColor,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.7),
                          AppTheme.primaryColor.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),
                // Section 1 - Content
                Column(
                  children: [
                    // Search Bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Text(
                            S.searchRecipesIngredients,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.tune, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                    // AR扫描 - Header
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.smartARScan,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraScanDemoScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            child: Text(S.startScan),
                          ),
                        ],
                      ),
                    ),
                    // AR扫描 - Featured Card
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 220,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraScanDemoScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: 280,
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: const DecorationImage(
                                  image: NetworkImage('https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=600&h=400&fit=crop'),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF667EEA).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF667EEA).withOpacity(0.8),
                                      const Color(0xFF764BA2).withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // 装饰圆圈
                                    Positioned(
                                    right: -30,
                                    top: -30,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: -20,
                                    bottom: -20,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                  // 内容
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.25),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.auto_awesome,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'YOLO-World AI',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.qr_code_scanner,
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          S.smartARScan,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          S.realtimeRecognition,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Section 2 - 快捷功能
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    S.quickStart,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                // Content
                SizedBox(
                  height: 140,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildRecommendationCard(
                        context,
                        icon: Icons.photo_library_outlined,
                        title: S.photoRecognition,
                        subtitle: S.recognizeFromPhoto,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                        ),
                        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop',
                        onTap: () async {
                          final mediaService = MediaService();
                          final imageBytes = await mediaService.pickFromGallery();
                          if (imageBytes != null && context.mounted) {
                            final globalProvider = Provider.of<GlobalProvider>(
                              context,
                              listen: false,
                            );
                            await globalProvider.identifyAndGenerateRecipes(
                              imageBytes: imageBytes,
                            );
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResultScreen(),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildRecommendationCard(
                        context,
                        icon: Icons.kitchen_outlined,
                        title: S.myFridge,
                        subtitle: S.ingredientCount(pantryProvider.itemCount),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                        ),
                        imageUrl: 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=400&h=300&fit=crop',
                        badge: pantryProvider.itemCount > 0
                            ? '${pantryProvider.itemCount}'
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PantryScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildRecommendationCard(
                        context,
                        icon: Icons.scale,
                        title: S.weightEstimation,
                        subtitle: S.smartPortionRecognition,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
                        ),
                        imageUrl: 'https://images.unsplash.com/photo-1490818387583-1baba5e638af?w=400&h=300&fit=crop',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FoodWeightDemoScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Section 3 - 今日热门
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.todayTrending,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(S.viewMore),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildTrendingRecipeCard(
                        '牛油果吐司',
                        '350',
                        '15',
                        const Color(0xFF81C784),
                        imageUrl: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400&h=300&fit=crop',
                      ),
                      const SizedBox(width: 16),
                      _buildTrendingRecipeCard(
                        '三文鱼Poke碗',
                        '420',
                        '20',
                        const Color(0xFFFF8A65),
                        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop',
                      ),
                      const SizedBox(width: 16),
                      _buildTrendingRecipeCard(
                        '生酮汉堡',
                        '580',
                        '25',
                        const Color(0xFFBA68C8),
                        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
                      ),
                      const SizedBox(width: 16),
                      _buildTrendingRecipeCard(
                        '意式披萨',
                        '650',
                        '30',
                        const Color(0xFFFFD54F),
                        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Section 4 - 冰箱预览
          if (pantryProvider.items.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.myFridge,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PantryScreen(),
                            ),
                          );
                        },
                        child: Text(S.viewAll),
                      ),
                    ],
                  ),
                  _buildPantryPreview(context, pantryProvider),
                ],
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    String? badge,
    String? imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
          gradient: imageUrl == null ? gradient : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: imageUrl != null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                )
              : null,
          child: Stack(
            children: [
              Positioned(
              right: -15,
              top: -15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (badge != null)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingRecipeCard(
    String title,
    String calories,
    String time,
    Color color, {
    String? imageUrl,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 48,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 48,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '$calories Kcal',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      '$time min',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPantryPreview(BuildContext context, PantryProvider pantryProvider) {
    final S = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FACFE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.kitchen_outlined,
                  color: Color(0xFF4FACFE),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                S.ingredientCount(pantryProvider.itemCount),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pantryProvider.items.take(6).map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
              );
            }).toList(),
          ),
          if (pantryProvider.itemCount > 6) ...[
            const SizedBox(height: 8),
            Text(
              S.moreItems(pantryProvider.itemCount - 6),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final globalProvider = Provider.of<GlobalProvider>(
                  context,
                  listen: false,
                );
                final userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(S.generatingRecipe),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

                try {
                  await globalProvider.generateRecipesFromIngredients(
                    ingredients: pantryProvider.getIngredientNames(),
                    allergens: userProvider.user.allergens,
                    servings: userProvider.user.defaultServings,
                    preferences: userProvider.user.preferences,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultScreen(),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.generationFailed(e.toString()))),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant_menu, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    S.cookWithThese,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
