import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import '../config/theme.dart';
import 'profile_edit_screen.dart';

/// 档案管理界面 — Figma Harvest Warm 设计稿
class ProfilesManagementScreen extends StatelessWidget {
  const ProfilesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── 顶部导航栏 (Figma风格) ──
          _buildNavBar(context),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final profiles = userProvider.profiles;
                final currentProfile = userProvider.currentProfile;

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 16),

                    // ── Section Header ──
                    const Text(
                      'Family Circle',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        fontFamily: 'Manrope',
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage dietary preferences and allergies for each member.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Profile Cards ──
                    ...profiles.map((profile) {
                      final isSelected = currentProfile?.id == profile.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ProfileCard(
                          profile: profile,
                          isSelected: isSelected,
                          onTap: () {
                            userProvider.setCurrentProfile(profile);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Switched to ${profile.nickname ?? profile.name}'),
                                backgroundColor: AppTheme.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                ),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEditScreen(profile: profile),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    // ── Add New Profile Button ──
                    _AddProfileCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
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
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.primary, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Profiles Management',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    fontFamily: 'Manrope',
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma风格档案卡片
class _ProfileCard extends StatelessWidget {
  final User profile;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _ProfileCard({
    required this.profile,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppTheme.surfaceLow,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: isSelected
              ? Border.all(color: AppTheme.primaryContainer, width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.08),
                    blurRadius: 16,
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: AppTheme.primaryContainer, width: 2)
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.surfaceContainer,
                    backgroundImage: profile.avatarUrl != null
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl == null
                        ? Text(
                            (profile.nickname ?? profile.name).isNotEmpty
                                ? (profile.nickname ?? profile.name).substring(0, 1).toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                              fontFamily: 'Manrope',
                            ),
                          )
                        : null,
                  ),
                ),
                if (isSelected)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check_circle, size: 14, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          profile.nickname ?? profile.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            fontFamily: 'Manrope',
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (profile.relationship != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary.withOpacity(0.1)
                                : AppTheme.secondaryContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            profile.relationship!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppTheme.primary : AppTheme.secondary,
                              letterSpacing: 0.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildSubtitle(profile),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (profile.allergens.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: profile.allergens.take(3).map((allergen) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.surfaceContainer
                                : AppTheme.surfaceContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.eco, size: 12, color: AppTheme.secondary),
                              const SizedBox(width: 4),
                              Text(
                                allergen,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Edit button
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.textSecondary, size: 20),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(User profile) {
    final parts = <String>[];
    if (profile.gender != null) parts.add(profile.gender!);
    if (profile.birthday != null) {
      final age = DateTime.now().year - profile.birthday!.year;
      parts.add('$age yrs');
    }
    return parts.isEmpty ? 'No details' : parts.join(' \u2022 ');
  }
}

/// 添加新档案按钮
class _AddProfileCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddProfileCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLow.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.outline.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_circle, size: 30, color: AppTheme.primary),
            ),
            const SizedBox(height: 12),
            const Text(
              '+ Add New Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                letterSpacing: 0.5,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
