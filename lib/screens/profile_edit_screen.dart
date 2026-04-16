import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import '../services/media_service.dart';
import '../config/theme.dart';

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

  final List<String> _relationshipOptions = ['Self', 'Spouse', 'Child', 'Friend'];
  final List<String> _genderOptions = ['Male', 'Female', 'Non-binary'];

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
    if (_nicknameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a nickname'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: const Text(
          'Delete Profile',
          style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to delete this profile?',
          style: TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.deleteProfile(widget.profile!.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── 顶部导航栏 (Figma风格) ──
          _buildNavBar(context),
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
                      const Text(
                        'PROFILE IDENTITY',
                        style: TextStyle(
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
                _buildFieldLabel('Nickname'),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _nicknameController,
                  hint: 'Artisan Chef',
                  isTitle: true,
                ),
                const SizedBox(height: 20),

                // Relationship & Gender
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Relationship'),
                          const SizedBox(height: 6),
                          _buildDropdown(
                            value: _relationship,
                            items: _relationshipOptions,
                            onChanged: (v) => setState(() => _relationship = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Gender'),
                          const SizedBox(height: 6),
                          _buildDropdown(
                            value: _gender,
                            items: _genderOptions,
                            onChanged: (v) => setState(() => _gender = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Birthday
                _buildFieldLabel('Birthday'),
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
                              ? _formatBirthday(_birthday!)
                              : 'Select birthday',
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
                    const Text(
                      'Food Allergies',
                      style: TextStyle(
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 18, color: AppTheme.primary),
                            SizedBox(width: 4),
                            Text(
                              'Add',
                              style: TextStyle(
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
                    'No allergies added yet',
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
                      'Tapping an allergy chip will remove it from your profile.',
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
                  label: 'Save Changes',
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
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  widget.profile == null ? 'Add Profile' : 'Edit Profile',
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

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
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
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.expand_more, color: AppTheme.textHint),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
            fontFamily: 'Inter',
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _formatBirthday(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _addAllergen() {
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
            const Text(
              'Add Allergy',
              style: TextStyle(
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
                decoration: const InputDecoration(
                  hintText: 'e.g. Gluten, Soy...',
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
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
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
                      child: const Text('Add Item', style: TextStyle(fontWeight: FontWeight.w700)),
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
