import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'profile_edit_screen.dart';

/// 档案管理界面（参考测测APP）
class ProfilesManagementScreen extends StatelessWidget {
  const ProfilesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('个人档案'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final profiles = userProvider.profiles;
          final currentProfile = userProvider.currentProfile;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == profiles.length) {
                // 添加新档案按钮
                return _buildAddProfileCard(context);
              }

              final profile = profiles[index];
              final isSelected = currentProfile?.id == profile.id;

              return _buildProfileCard(
                context,
                profile,
                isSelected,
                userProvider,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    User profile,
    bool isSelected,
    UserProvider userProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            userProvider.setCurrentProfile(profile);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已切换到 ${profile.nickname ?? profile.name}')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 头像
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Text(
                          (profile.nickname ?? profile.name).substring(0, 1),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // 信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            profile.nickname ?? profile.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (profile.relationship != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                profile.relationship!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (profile.birthday != null) ...[
                            Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${profile.birthday!.month}月${profile.birthday!.day}日',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (profile.gender != null) ...[
                            Icon(
                              profile.gender == '男' ? Icons.male : Icons.female,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              profile.gender!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (profile.allergens.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '过敏源: ${profile.allergens.join(', ')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // 编辑按钮
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditScreen(profile: profile),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddProfileCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileEditScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  '添加新档案',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
