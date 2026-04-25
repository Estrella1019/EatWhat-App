import 'package:flutter/material.dart';
import '../models/favorite.dart';
import '../services/auth_service.dart';
import '../config/theme.dart';
import 'recipe_detail_screen.dart';

/// 收藏列表界面 — Figma Harvest Warm 设计稿
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _authService = AuthService.getInstance();
  List<Favorite> _favorites = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final favorites = await _authService.getFavorites();
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteFavorite(int favoriteId) async {
    final S = AppLocalizations.of(context)!;

    try {
      await _authService.deleteFavorite(favoriteId);
      await _loadFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_favoritesRemovedText(S)),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_deleteFailedText(S)}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── 顶部导航栏 (Figma风格) ──
          _buildNavBar(context),
          // ── Editorial Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURATED HARVEST',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppTheme.secondary,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _favoritesPageTitle(S),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Manrope',
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _favoritesSubtitle(S),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Content ──
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _errorMessage != null
                    ? _buildErrorState()
                    : _favorites.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadFavorites,
                            color: AppTheme.primary,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: _favorites.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return _buildFavoriteCard(_favorites[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  String _favoritesSubtitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '收藏你最喜欢的菜谱，方便随时回来看。';
    }
    return 'A personal collection of your most cherished culinary discoveries.';
  }

  String _favoritesRemovedText(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '已取消收藏';
    }
    return 'Removed from favorites';
  }

  String _deleteFailedText(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '删除失败';
    }
    return 'Failed to delete';
  }

  String _favoritesPageTitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '我的收藏';
    }
    return 'Your Favorites';
  }

  String _removeFavoriteTitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '移除收藏';
    }
    return 'Remove Favorite';
  }

  String _removeFavoriteMessage(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '确定要把这道菜从收藏中移除吗？';
    }
    return 'Are you sure you want to remove this recipe from favorites?';
  }

  String _removeText(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '移除';
    }
    return 'Remove';
  }

  String _emptyFavoritesTitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '还没有收藏';
    }
    return 'No favorites yet';
  }

  String _emptyFavoritesSubtitle(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '去收藏你喜欢的菜谱吧';
    }
    return 'Start saving recipes you love';
  }

  String _retryText(AppLocalizations S) {
    if (S.localeName.startsWith('zh')) {
      return '重试';
    }
    return 'Retry';
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
                  icon: const Icon(Icons.settings_outlined,
                      color: AppTheme.primary, size: 22),
                  onPressed: () {
                    // TODO: 设置页面
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Favorite favorite) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: favorite.recipeData),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B1C1A).withOpacity(0.04),
                blurRadius: 32,
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  color: AppTheme.surfaceContainer,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  child: favorite.recipeData.imageUrl.isNotEmpty
                      ? Image.network(
                          favorite.recipeData.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.restaurant,
                            color: AppTheme.primary,
                          ),
                        )
                      : const Icon(Icons.restaurant, color: AppTheme.primary),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.recipeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        fontFamily: 'Manrope',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(favorite.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),

              // Delete button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: const Icon(Icons.delete, color: AppTheme.error),
                  onPressed: () => _showDeleteDialog(favorite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Favorite favorite) {
    final S = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text(
          _removeFavoriteTitle(S),
          style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        ),
        content: Text(
          _removeFavoriteMessage(S),
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.cancel, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFavorite(favorite.id);
            },
            child: Text(
              _removeText(S),
              style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final S = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: AppTheme.outline.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            _emptyFavoritesTitle(S),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _emptyFavoritesSubtitle(S),
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final S = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
          const SizedBox(height: 16),
          Text(_errorMessage!, style: const TextStyle(color: AppTheme.error)),
          const SizedBox(height: 16),
          GradientButton(
            label: _retryText(S),
            onPressed: _loadFavorites,
            width: 120,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
