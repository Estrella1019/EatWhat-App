import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../config/theme.dart';
import 'profiles_management_screen.dart';
import 'profile_edit_screen.dart';
import 'login_screen.dart';

/// 个人档案页面 — Harvest Warm 设计风格
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _authService = AuthService.getInstance();
  bool _isSaving = false;

  final List<String> _commonAllergens = [
    '花生', '海鲜', '牛奶', '鸡蛋', '大豆', '小麦', '坚果', '芝麻',
  ];

  final List<String> _tasteOptions = [
    '清淡', '重口味', '微辣', '中辣', '特辣', '甜味', '酸味',
  ];

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.user.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave(UserProvider userProvider) async {
    setState(() => _isSaving = true);
    if (_nameController.text.trim().isNotEmpty) {
      userProvider.updateUserName(_nameController.text.trim());
    }
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final S = AppLocalizations.of(context);

    if (S == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  const Expanded(
                    child: Text(
                      'EATWHAT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: AppTheme.primary, size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 8),

                  // ── Avatar Card ───────────────────────
                  _buildAvatarCard(userProvider),
                  const SizedBox(height: 16),

                  // ── Stats Row ─────────────────────────
                  _buildStatsRow(),
                  const SizedBox(height: 24),

                  // ── User Settings Section ─────────────
                  _sectionLabel('USER SETTINGS'),
                  const SizedBox(height: 8),
                  _buildSettingsCard(context),
                  const SizedBox(height: 24),

                  // ── Preferences Section ───────────────
                  Row(
                    children: const [
                      Icon(Icons.tune, color: AppTheme.primary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLow,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        _prefLabel('USERNAME'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your username',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Allergy Filters
                        _prefLabel('ALLERGY FILTERS'),
                        const SizedBox(height: 10),
                        _buildAllergenChips(userProvider, S),
                        const SizedBox(height: 20),

                        // Taste Preferences
                        _prefLabel('TASTE PREFERENCES'),
                        const SizedBox(height: 10),
                        _buildTasteChips(userProvider, S),
                        const SizedBox(height: 20),

                        // Servings
                        _prefLabel('SERVINGS'),
                        const SizedBox(height: 10),
                        _buildServingsRow(userProvider),
                        const SizedBox(height: 20),

                        // Language
                        _prefLabel('LANGUAGE'),
                        const SizedBox(height: 10),
                        _buildLanguageToggle(userProvider),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Account Section ───────────────────
                  _sectionLabel('ACCOUNT'),
                  const SizedBox(height: 8),
                  _buildAccountCard(context, S),
                  const SizedBox(height: 24),

                  // ── Update Profile Button ─────────────
                  GradientButton(
                    label: 'Update Profile',
                    onPressed: () => _handleSave(userProvider),
                    isLoading: _isSaving,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Avatar Card ─────────────────────────────────────────
  Widget _buildAvatarCard(UserProvider userProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: AppTheme.buttonShadow,
                ),
                child: const Icon(Icons.person, size: 44, color: Colors.white),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            userProvider.user.name.isEmpty ? 'Your Name' : userProvider.user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'PREMIUM MEMBER',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
              letterSpacing: 1.5,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _statCard(Icons.favorite, '24', 'SAVED RECIPES')),
        const SizedBox(width: 12),
        Expanded(child: _statCard(Icons.restaurant, '12', 'COOKED THIS WEEK')),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textHint,
              letterSpacing: 0.8,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  // ── Settings Card ────────────────────────────────────────
  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _settingsRow(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
            ),
          ),
          Divider(height: 1, color: AppTheme.outline.withOpacity(0.4), indent: 52),
          _settingsRow(
            icon: Icons.people_outline,
            label: 'Profile Management',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilesManagementScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppTheme.textHint, size: 14),
          ],
        ),
      ),
    );
  }

  // ── Allergen Chips ───────────────────────────────────────
  Widget _buildAllergenChips(UserProvider userProvider, AppLocalizations S) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._commonAllergens.map((allergen) {
          final isSelected = userProvider.user.allergens.contains(allergen);
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                userProvider.removeAllergen(allergen);
              } else {
                userProvider.addAllergen(allergen);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.chipBackground : Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.outline,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(Icons.check,
                        size: 13, color: AppTheme.primary),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    _getAllergenTranslation(S, allergen),
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? AppTheme.chipText : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        // Custom button
        GestureDetector(
          onTap: () => _showAddAllergenDialog(context, userProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(
                  color: AppTheme.outline, style: BorderStyle.solid, width: 1),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 13, color: AppTheme.textSecondary),
                SizedBox(width: 4),
                Text(
                  'Custom',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
        // Custom allergens (deletable)
        ...userProvider.user.allergens
            .where((a) => !_commonAllergens.contains(a))
            .map((allergen) => GestureDetector(
                  onTap: () => userProvider.removeAllergen(allergen),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.chipBackground,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusFull),
                      border: Border.all(color: AppTheme.primary, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check,
                            size: 13, color: AppTheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          allergen,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.chipText,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.close,
                            size: 12, color: AppTheme.primary),
                      ],
                    ),
                  ),
                )),
      ],
    );
  }

  // ── Taste Chips ──────────────────────────────────────────
  Widget _buildTasteChips(UserProvider userProvider, AppLocalizations S) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _tasteOptions.map((taste) {
        final isSelected = userProvider.user.preferences.contains(taste);
        return GestureDetector(
          onTap: () {
            final prefs = [...userProvider.user.preferences];
            if (isSelected) {
              prefs.remove(taste);
            } else {
              prefs.add(taste);
            }
            userProvider.updatePreferences(prefs);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.chipBackground : Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.outline,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              _getTasteTranslation(S, taste),
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? AppTheme.chipText : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Servings Row ─────────────────────────────────────────
  Widget _buildServingsRow(UserProvider userProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            color: userProvider.user.defaultServings > 1
                ? AppTheme.primary
                : AppTheme.outline,
            onPressed: userProvider.user.defaultServings > 1
                ? () => userProvider
                    .updateServings(userProvider.user.defaultServings - 1)
                : null,
          ),
          Expanded(
            child: Center(
              child: Text(
                '${userProvider.user.defaultServings}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            color: userProvider.user.defaultServings < 10
                ? AppTheme.primary
                : AppTheme.outline,
            onPressed: userProvider.user.defaultServings < 10
                ? () => userProvider
                    .updateServings(userProvider.user.defaultServings + 1)
                : null,
          ),
        ],
      ),
    );
  }

  // ── Language Toggle ──────────────────────────────────────
  Widget _buildLanguageToggle(UserProvider userProvider) {
    final isEn = userProvider.user.locale == 'en';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Row(
        children: [
          _langOption('EN', !isEn == false, () async {
            await userProvider.updateLocale('en');
          }, isEn),
          _langOption('CN', isEn == false, () async {
            await userProvider.updateLocale('zh');
          }, !isEn),
        ],
      ),
    );
  }

  Widget _langOption(
      String label, bool _, VoidCallback onTap, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.primaryGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Account Card ─────────────────────────────────────────
  Widget _buildAccountCard(BuildContext context, AppLocalizations S) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          if (_authService.isLoggedIn) ...[
            _accountRow(
              icon: Icons.favorite_outline,
              iconColor: AppTheme.primary,
              label: 'My Favorites',
              onTap: () {},
            ),
            Divider(
                height: 1,
                color: AppTheme.outline.withOpacity(0.4),
                indent: 52),
            _accountRow(
              icon: Icons.logout,
              iconColor: AppTheme.error,
              label: 'Logout',
              labelColor: AppTheme.error,
              onTap: () => _handleLogout(context),
            ),
          ] else ...[
            _accountRow(
              icon: Icons.login,
              iconColor: AppTheme.primary,
              label: 'Login / Register',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _accountRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: labelColor ?? AppTheme.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            if (labelColor == null)
              const Icon(Icons.arrow_forward_ios,
                  color: AppTheme.textHint, size: 14),
          ],
        ),
      ),
    );
  }

  // ── Logout ───────────────────────────────────────────────
  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
        title: const Text('Confirm Logout',
            style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout',
                style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await _authService.logout();
      setState(() {});
    }
  }

  // ── Add Custom Allergen Dialog ───────────────────────────
  void _showAddAllergenDialog(BuildContext context, UserProvider userProvider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
        title: const Text('Add Custom Allergen',
            style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. sesame'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                userProvider.addAllergen(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add',
                style: TextStyle(
                    color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.textHint,
        letterSpacing: 1.2,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _prefLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
        fontFamily: 'Inter',
      ),
    );
  }

  String _getAllergenTranslation(AppLocalizations S, String allergen) {
    switch (allergen) {
      case '花生': return S.peanut;
      case '海鲜': return S.seafood;
      case '牛奶': return S.milk;
      case '鸡蛋': return S.egg;
      case '大豆': return S.soybean;
      case '小麦': return S.wheat;
      case '坚果': return S.nuts;
      case '芝麻': return S.sesame;
      default: return allergen;
    }
  }

  String _getTasteTranslation(AppLocalizations S, String taste) {
    switch (taste) {
      case '清淡': return S.mild;
      case '重口味': return S.heavy;
      case '微辣': return S.mildlySpicy;
      case '中辣': return S.mediumSpicy;
      case '特辣': return S.verySpicy;
      case '甜味': return S.sweet;
      case '酸味': return S.sour;
      default: return taste;
    }
  }
}
