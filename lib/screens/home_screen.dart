import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/pantry_provider.dart';
import '../providers/global_provider.dart';
import '../services/media_service.dart';
import '../config/theme.dart';
import 'pantry_screen.dart';
import 'result_screen.dart';
import 'camera_scan_demo_screen.dart';
import 'food_weight_demo_screen.dart';

/// 首页 — 参考图设计：大图Banner + 叠加文字按钮
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context);
    if (S == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── 顶部 Logo ──
          _Header(),
          // ── 内容区 ──
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // ── 大图 Banner 区 ──
                _HeroBanner(S: S),
                const SizedBox(height: 24),

                // ── 主标题 ──
                _HeroTitle(S: S),
                const SizedBox(height: 20),

                // ── 功能按钮 ──
                _QuickActions(S: S),
                const SizedBox(height: 32),

                // ── 今日热门 ──
                _TrendingSection(S: S),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 顶部 Logo Header
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            'EATWHAT',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
              color: AppTheme.primary,
              fontFamily: 'Manrope',
            ),
          ),
        ],
      ),
    );
  }
}

/// 大图 Hero Banner — 高级AR扫描卡片设计
class _HeroBanner extends StatelessWidget {
  final AppLocalizations S;
  const _HeroBanner({required this.S});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4A843).withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── 背景渐变（使用 Align 填充）─
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFFF8F0),
                        const Color(0xFFFFF0E3),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── 装饰圆环 ──
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.1),
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.08),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // ── 中央 AR 扫描区域（食物图片 + AR 扫描遮罩）─
            Center(
              child: _ARScannerView(),
            ),

            // ── 左上角 AI 标签 ──
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 右上角扫描图标 ──
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
            ),

            // ── 底部文字和按钮 ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 主标题
                    Text(
                      S.smartARScan,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        fontFamily: 'Manrope',
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 副标题
                    Text(
                      S.realtimeRecognition,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary.withOpacity(0.8),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 扫描按钮
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CameraScanDemoScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              S.startScan,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AR 扫描视图 — 圆形食物图片叠加扫描遮罩
class _ARScannerView extends StatefulWidget {
  @override
  State<_ARScannerView> createState() => _ARScannerViewState();
}

class _ARScannerViewState extends State<_ARScannerView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 外圈光晕
          Container(
            width: 178,
            height: 178,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // 食物图片圆形容器
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  // 食物图片
                  Image.network(
                    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop',
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 160,
                      height: 160,
                      color: AppTheme.surfaceContainer,
                      child: Icon(
                        Icons.restaurant,
                        size: 50,
                        color: AppTheme.textHint.withOpacity(0.5),
                      ),
                    ),
                  ),

                  // 扫描网格遮罩（底部渐变消失）
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.15),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // AR 扫描线（动画）
                  AnimatedBuilder(
                    animation: _scanAnim,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanAnim.value * 140,
                        left: 8,
                        right: 8,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppTheme.primary.withOpacity(0.8),
                                Colors.white,
                                AppTheme.primary.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(1),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // 扫描线顶部小光点
                  AnimatedBuilder(
                    animation: _scanAnim,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanAnim.value * 138 + 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary,
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── 扫描框四角（覆盖在图片边缘上）─
          // 左上角
          Positioned(
            top: 8,
            left: 8,
            child: _ScanCorner(corner: _Corner.topLeft),
          ),
          // 右上角
          Positioned(
            top: 8,
            right: 8,
            child: _ScanCorner(corner: _Corner.topRight),
          ),
          // 左下角
          Positioned(
            bottom: 8,
            left: 8,
            child: _ScanCorner(corner: _Corner.bottomLeft),
          ),
          // 右下角
          Positioned(
            bottom: 8,
            right: 8,
            child: _ScanCorner(corner: _Corner.bottomRight),
          ),
        ],
      ),
    );
  }
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

/// 扫描框角落
class _ScanCorner extends StatelessWidget {
  final _Corner corner;
  const _ScanCorner({required this.corner});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _CornerPainter(corner: corner),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final _Corner corner;
  _CornerPainter({required this.corner});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glow = Paint()
      ..color = AppTheme.primary.withOpacity(0.3)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();
    final w = size.width;
    final h = size.height;

    switch (corner) {
      case _Corner.topLeft:
        path.moveTo(0, h * 0.6);
        path.lineTo(0, 2);
        path.lineTo(w * 0.6, 0);
      case _Corner.topRight:
        path.moveTo(w * 0.4, 0);
        path.lineTo(w - 2, 0);
        path.lineTo(w, h * 0.6);
      case _Corner.bottomLeft:
        path.moveTo(0, h * 0.4);
        path.lineTo(0, h - 2);
        path.lineTo(w * 0.6, h);
      case _Corner.bottomRight:
        path.moveTo(w * 0.4, h);
        path.lineTo(w - 2, h);
        path.lineTo(w, h * 0.4);
    }

    canvas.drawPath(path, glow);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 主标题区域
class _HeroTitle extends StatelessWidget {
  final AppLocalizations S;
  const _HeroTitle({required this.S});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.todayEatWhat,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              fontFamily: 'Manrope',
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            S.quickStart,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// 功能快捷按钮 — 三个横排
class _QuickActions extends StatelessWidget {
  final AppLocalizations S;
  const _QuickActions({required this.S});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _ActionCard(
            icon: Icons.photo_library_outlined,
            label: S.photoRecognition,
            onTap: () => _handlePhotoRecognition(context),
          )),
          const SizedBox(width: 10),
          Expanded(child: _ActionCard(
            icon: Icons.kitchen_outlined,
            label: S.myFridge,
            badge: _getPantryCount(context),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantryScreen())),
          )),
          const SizedBox(width: 10),
          Expanded(child: _ActionCard(
            icon: Icons.scale_outlined,
            label: S.weightEstimation,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodWeightDemoScreen())),
          )),
        ],
      ),
    );
  }

  int? _getPantryCount(BuildContext context) {
    final pantry = Provider.of<PantryProvider>(context, listen: false);
    return pantry.itemCount > 0 ? pantry.itemCount : null;
  }

  void _handlePhotoRecognition(BuildContext context) async {
    final mediaService = MediaService();
    final imageBytes = await mediaService.pickFromGallery();
    if (imageBytes != null && context.mounted) {
      HapticFeedback.lightImpact();
      final gp = Provider.of<GlobalProvider>(context, listen: false);
      await gp.identifyAndGenerateRecipes(imageBytes: imageBytes);
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
      }
    }
  }
}

/// 单个功能卡片
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? badge;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.outline.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.chipBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// 今日热门区域
class _TrendingSection extends StatelessWidget {
  final AppLocalizations S;
  const _TrendingSection({required this.S});

  static const _recipes = [
    _RecipeData('番茄炒蛋', '350 Kcal', '15 min',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop'),
    _RecipeData('红烧肉', '580 Kcal', '40 min',
        'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&h=300&fit=crop'),
    _RecipeData('宫保鸡丁', '420 Kcal', '25 min',
        'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=400&h=300&fit=crop'),
    _RecipeData('清蒸鲈鱼', '380 Kcal', '30 min',
        'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=300&fit=crop'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.todayTrending,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Manrope',
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  S.viewAll,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: _recipes.length,
            itemBuilder: (context, index) {
              return _RecipeCard(recipe: _recipes[index]);
            },
          ),
        ),
      ],
    );
  }
}

/// 食谱数据
class _RecipeData {
  final String name;
  final String calories;
  final String time;
  final String imageUrl;
  const _RecipeData(this.name, this.calories, this.time, this.imageUrl);
}

/// 食谱卡片
class _RecipeCard extends StatelessWidget {
  final _RecipeData recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outline.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              recipe.imageUrl,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 110,
                color: AppTheme.surfaceContainer,
                child: Icon(
                  Icons.restaurant,
                  size: 32,
                  color: AppTheme.textHint.withOpacity(0.5),
                ),
              ),
            ),
          ),
          // 信息
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      size: 12,
                      color: AppTheme.textSecondary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      recipe.calories,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary.withOpacity(0.8),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.access_time_outlined,
                      size: 12,
                      color: AppTheme.textSecondary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      recipe.time,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary.withOpacity(0.8),
                        fontFamily: 'Inter',
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
}