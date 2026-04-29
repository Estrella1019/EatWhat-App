import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import '../services/media_service.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';

/// 档案编辑界面 — Figma Harvest Warm 设计稿
class ProfileEditScreen extends StatefulWidget {
  final User? profile;

  const ProfileEditScreen({super.key, this.profile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nicknameController;
  late TextEditingController _nameController;
  String? _avatarUrl;
  String? _relationship;
  DateTime? _birthday;
  String? _gender;
  List<String> _allergens = [];

  // Keep internal values in English (consistent with storage)
  static const _relationshipValues = ['Self', 'Spouse', 'Child', 'Friend'];
  static const _genderValues = ['Male', 'Female', 'Non-binary'];

  String _getLocalizedRelationship(AppLocalizations S, String? value) {
    if (value == null) return S.self;
    final index = _relationshipValues.indexOf(value);
    switch (index) {
      case 0: return S.self;
      case 1: return S.spouse;
      case 2: return S.child;
      case 3: return S.friend;
      default: return S.self;
    }
  }

  String _getLocalizedGender(AppLocalizations S, String? value) {
    if (value == null) return S.male;
    final index = _genderValues.indexOf(value);
    switch (index) {
      case 0: return S.male;
      case 1: return S.female;
      case 2: return S.nonBinary;
      default: return S.male;
    }
  }

  String _getInternalRelationship(AppLocalizations S, String displayValue) {
    if (displayValue == S.self) return 'Self';
    if (displayValue == S.spouse) return 'Spouse';
    if (displayValue == S.child) return 'Child';
    if (displayValue == S.friend) return 'Friend';
    return 'Self';
  }

  String _getInternalGender(AppLocalizations S, String displayValue) {
    if (displayValue == S.male) return 'Male';
    if (displayValue == S.female) return 'Female';
    if (displayValue == S.nonBinary) return 'Non-binary';
    return 'Male';
  }

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.profile?.nickname);
    _nameController = TextEditingController(text: widget.profile?.name);
    _avatarUrl = widget.profile?.avatarUrl;
    _relationship = widget.profile?.relationship ?? 'Self';
    _birthday = widget.profile?.birthday;
    _gender = widget.profile?.gender;
    _allergens = List.from(widget.profile?.allergens ?? []);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final mediaService = MediaService();
    final imageBytes = await mediaService.pickFromGallery();
    if (imageBytes != null) {
      setState(() {
        _avatarUrl = 'https://i.pravatar.cc/300?img=${DateTime.now().millisecondsSinceEpoch % 70}';
      });
    }
  }

  Future<void> _selectBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _birthday = picked);
    }
  }

  void _save() {
    final S = AppLocalizations.of(context)!;
    if (_nicknameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.enterNickname),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profile = User(
      id: widget.profile?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.isEmpty ? _nicknameController.text : _nameController.text,
      nickname: _nicknameController.text,
      avatarUrl: _avatarUrl,
      relationship: _relationship,
      birthday: _birthday,
      gender: _gender,
      allergens: _allergens,
      preferences: widget.profile?.preferences ?? [],
      defaultServings: widget.profile?.defaultServings ?? 2,
    );

    if (widget.profile == null) {
      userProvider.addProfile(profile);
    } else {
      userProvider.updateProfile(profile.id, profile);
    }

    Navigator.pop(context);
  }

  void _delete() {
    final S = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Text(
          S.deleteProfile,
          style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        ),
        content: Text(
          S.deleteProfileConfirm,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.cancel, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.deleteProfile(widget.profile!.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              S.delete,
              style: const TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getRelationshipOptions(AppLocalizations S) {
    return [
      S.self,
      S.spouse,
      S.child,
      S.friend,
    ];
  }

  List<String> _getGenderOptions(AppLocalizations S) {
    return [
      S.male,
      S.female,
      S.nonBinary,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final S = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── 顶部导航栏 (Figma风格) ──
          _buildNavBar(context, S),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 16),

                // ── Avatar Section ──
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          children: [
                            Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1B1C1A).withOpacity(0.12),
                                    blurRadius: 32,
                                    spreadRadius: -4,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 64,
                                backgroundColor: AppTheme.surfaceContainer,
                                backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                                child: _avatarUrl == null
                                    ? const Icon(Icons.person, size: 56, color: AppTheme.primary)
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryContainer,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.background, width: 4),
                                  boxShadow: AppTheme.buttonShadow,
                                ),
                                child: const Icon(
                                  Icons.camera_enhance,
                                  size: 20,
                                  color: Color(0xFF5D3900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.profileIdentity,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.secondary,
                          letterSpacing: 2,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Form Fields ──
                // Nickname
                _buildFieldLabel(S.nickname),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _nicknameController,
                  hint: S.nicknamePlaceholder,
                  isTitle: true,
                ),
                const SizedBox(height: 20),

                // Relationship & Gender (use localized display values)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(S.relationship),
                          const SizedBox(height: 6),
                          _buildLocalizedDropdown(
                            displayValue: _getLocalizedRelationship(S, _relationship),
                            allOptions: [S.self, S.spouse, S.child, S.friend],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _relationship = _getInternalRelationship(S, v));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(S.gender),
                          const SizedBox(height: 6),
                          _buildLocalizedDropdown(
                            displayValue: _getLocalizedGender(S, _gender),
                            allOptions: [S.male, S.female, S.nonBinary],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _gender = _getInternalGender(S, v));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Birthday
                _buildFieldLabel(S.birthday),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _selectBirthday,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLow,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _birthday != null
                              ? _formatBirthday(_birthday!, S)
                              : S.selectBirthday,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: _birthday != null ? AppTheme.textPrimary : AppTheme.textHint,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: AppTheme.primary, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Allergy Section ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.foodAllergies,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        fontFamily: 'Manrope',
                      ),
                    ),
                    GestureDetector(
                      onTap: _addAllergen,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 18, color: AppTheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              S.add,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_allergens.isEmpty)
                  Text(
                    S.noAllergiesYet,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textHint,
                      fontFamily: 'Inter',
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allergens.map((allergen) {
                      return _AllergenChip(
                        label: allergen,
                        onRemove: () => setState(() => _allergens.remove(allergen)),
                      );
                    }).toList(),
                  ),
                if (_allergens.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      S.tapToRemoveAllergy,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textHint,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                const SizedBox(height: 48),

                // ── Save Button ──
                GradientButton(
                  label: S.saveChanges,
                  onPressed: _save,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, AppLocalizations S) {
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
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  widget.profile == null ? S.addProfile : S.editProfile,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    fontFamily: 'Manrope',
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                if (widget.profile != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppTheme.error, size: 22),
                    onPressed: _delete,
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppTheme.textSecondary,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool isTitle = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: isTitle ? 18 : 15,
          fontWeight: isTitle ? FontWeight.w600 : FontWeight.w500,
          color: AppTheme.textPrimary,
          fontFamily: isTitle ? 'Manrope' : 'Inter',
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.outline.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildLocalizedDropdown({
    required String displayValue,
    required List<String> allOptions,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: displayValue,
          isExpanded: true,
          icon: const Icon(Icons.expand_more, color: AppTheme.textHint),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
            fontFamily: 'Inter',
          ),
          items: allOptions.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _formatBirthday(DateTime date, AppLocalizations S) {
    // 根据语言返回不同格式
    if (S.localeName.startsWith('zh')) {
      final months = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'];
      return '${date.year}年${date.month}月${date.day}日';
    } else {
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  void _addAllergen() {
    final S = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
          32, 32, 32,
          MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        decoration: const BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: AppTheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              S.addAllergy,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Manrope',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLow,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: S.enterAllergenExample,
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.surfaceContainer,
                        foregroundColor: AppTheme.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                      ),
                      child: Text(S.cancel, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          setState(() {
                            if (!_allergens.contains(controller.text.trim())) {
                              _allergens.add(controller.text.trim());
                            }
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        ),
                      ),
                      child: Text(S.addItem, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 过敏原标签组件
class _AllergenChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _AllergenChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemove,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textGreen,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.close, size: 14, color: AppTheme.textGreen),
          ],
        ),
      ),
    );
  }
}