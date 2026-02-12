import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import 'profiles_management_screen.dart';

/// 个人档案页面
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  // 常见过敏原列表
  final List<String> _commonAllergens = [
    '花生',
    '海鲜',
    '牛奶',
    '鸡蛋',
    '大豆',
    '小麦',
    '坚果',
    '芝麻',
  ];

  // 口味偏好列表
  final List<String> _tasteOptions = [
    '清淡',
    '重口味',
    '微辣',
    '中辣',
    '特辣',
    '甜味',
    '酸味',
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
        title: Text(S.profileTitle),
        actions: [
          TextButton(
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                userProvider.updateUserName(_nameController.text.trim());
              }
              Navigator.pop(context);
            },
            child: Text(S.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 档案管理入口
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                      builder: (context) => const ProfilesManagementScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.people,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.manageProfiles,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              S.addFamilyFriends,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 用户名
          _buildSection(
            title: S.username,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: S.enterUsername,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 过敏原
          _buildSection(
            title: S.allergens,
            subtitle: S.selectOrAddAllergens,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 预设标签
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._commonAllergens.map((allergen) {
                      final isSelected = userProvider.user.allergens.contains(allergen);
                      return FilterChip(
                        label: Text(_getAllergenTranslation(S, allergen)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            userProvider.addAllergen(allergen);
                          } else {
                            userProvider.removeAllergen(allergen);
                          }
                        },
                        selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      );
                    }),
                    // 添加自定义过敏源按钮
                    ActionChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 16),
                          const SizedBox(width: 4),
                          Text(S.customAllergen),
                        ],
                      ),
                      onPressed: () => _showAddAllergenDialog(context, userProvider),
                    ),
                  ],
                ),
                // 显示已添加的自定义过敏源
                if (userProvider.user.allergens.any((a) => !_commonAllergens.contains(a))) ...[
                  const SizedBox(height: 12),
                  Text(
                    S.customAllergens,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: userProvider.user.allergens
                        .where((a) => !_commonAllergens.contains(a))
                        .map((allergen) {
                      return Chip(
                        label: Text(allergen),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          userProvider.removeAllergen(allergen);
                        },
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 口味偏好
          _buildSection(
            title: S.tastePreferences,
            subtitle: S.multipleChoice,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tasteOptions.map((taste) {
                final isSelected = userProvider.user.preferences.contains(taste);
                return FilterChip(
                  label: Text(_getTasteTranslation(S, taste)),
                  selected: isSelected,
                  onSelected: (selected) {
                    List<String> newPreferences = [...userProvider.user.preferences];
                    if (selected) {
                      newPreferences.add(taste);
                    } else {
                      newPreferences.remove(taste);
                    }
                    userProvider.updatePreferences(newPreferences);
                  },
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // 就餐人数
          _buildSection(
            title: S.defaultServings,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: userProvider.user.defaultServings > 1
                      ? () => userProvider.updateServings(
                            userProvider.user.defaultServings - 1,
                          )
                      : null,
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${userProvider.user.defaultServings}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: userProvider.user.defaultServings < 10
                      ? () => userProvider.updateServings(
                            userProvider.user.defaultServings + 1,
                          )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  S.people,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 语言设置
          _buildSection(
            title: S.languageSettings,
            child: Column(
              children: [
                _buildLanguageOption(
                  context,
                  userProvider,
                  S.followSystem,
                  null,
                ),
                const SizedBox(height: 8),
                _buildLanguageOption(
                  context,
                  userProvider,
                  S.simplifiedChinese,
                  'zh',
                ),
                const SizedBox(height: 8),
                _buildLanguageOption(
                  context,
                  userProvider,
                  S.traditionalChinese,
                  'zh_Hant',
                ),
                const SizedBox(height: 8),
                _buildLanguageOption(
                  context,
                  userProvider,
                  S.english,
                  'en',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建区块
  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  /// 显示添加自定义过敏源对话框
  void _showAddAllergenDialog(BuildContext context, UserProvider userProvider) {
    final controller = TextEditingController();
    final S = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.addCustomAllergen),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: S.enterAllergenName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                userProvider.addAllergen(controller.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.allergenAdded(controller.text.trim()))),
                );
              }
            },
            child: Text(S.add),
          ),
        ],
      ),
    );
  }

  /// 构建语言选项
  Widget _buildLanguageOption(
    BuildContext context,
    UserProvider userProvider,
    String label,
    String? localeCode,
  ) {
    final isSelected = userProvider.user.locale == localeCode;
    final S = AppLocalizations.of(context);

    return InkWell(
      onTap: () async {
        print('点击语言选项: $localeCode');
        print('当前语言: ${userProvider.user.locale}');

        await userProvider.updateLocale(localeCode);

        print('语言已更新为: ${userProvider.user.locale}');

        if (context.mounted && S != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.languageSwitched),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取过敏原翻译
  String _getAllergenTranslation(AppLocalizations S, String allergen) {
    switch (allergen) {
      case '花生':
        return S.peanut;
      case '海鲜':
        return S.seafood;
      case '牛奶':
        return S.milk;
      case '鸡蛋':
        return S.egg;
      case '大豆':
        return S.soybean;
      case '小麦':
        return S.wheat;
      case '坚果':
        return S.nuts;
      case '芝麻':
        return S.sesame;
      default:
        return allergen;
    }
  }

  /// 获取口味翻译
  String _getTasteTranslation(AppLocalizations S, String taste) {
    switch (taste) {
      case '清淡':
        return S.mild;
      case '重口味':
        return S.heavy;
      case '微辣':
        return S.mildlySpicy;
      case '中辣':
        return S.mediumSpicy;
      case '特辣':
        return S.verySpicy;
      case '甜味':
        return S.sweet;
      case '酸味':
        return S.sour;
      default:
        return taste;
    }
  }
}
