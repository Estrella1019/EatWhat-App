import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import '../services/media_service.dart';

/// 档案编辑界面
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

  final List<String> _relationshipOptions = ['自己', '家人', '朋友', '其他'];
  final List<String> _genderOptions = ['男', '女'];

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.profile?.nickname);
    _nameController = TextEditingController(text: widget.profile?.name);
    _avatarUrl = widget.profile?.avatarUrl;
    _relationship = widget.profile?.relationship ?? '自己';
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
      // 这里应该上传图片到服务器，暂时使用占位图
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
    );
    if (picked != null) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  void _save() {
    if (_nicknameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入昵称')),
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
        title: const Text('删除档案'),
        content: const Text('确定要删除这个档案吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.deleteProfile(widget.profile!.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.profile == null ? '添加档案' : '编辑档案'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (widget.profile != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 头像
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                    child: _avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 昵称
          _buildTextField(
            controller: _nicknameController,
            label: '昵称',
            hint: '请输入昵称',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // 关系
          _buildDropdownField(
            label: '关系',
            value: _relationship,
            items: _relationshipOptions,
            icon: Icons.people_outline,
            onChanged: (value) {
              setState(() {
                _relationship = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // 生日
          _buildDateField(
            label: '生日',
            value: _birthday,
            icon: Icons.cake_outlined,
            onTap: _selectBirthday,
          ),
          const SizedBox(height: 16),

          // 性别
          _buildDropdownField(
            label: '性别',
            value: _gender,
            items: _genderOptions,
            icon: Icons.wc_outlined,
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // 过敏源
          _buildAllergensSection(),

          const SizedBox(height: 32),

          // 保存按钮
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.profile == null ? '添加档案' : '保存修改',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          child: Text(
            value != null
                ? '${value.year}年${value.month}月${value.day}日'
                : '请选择生日',
            style: TextStyle(
              color: value != null ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllergensSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              const Icon(Icons.warning_amber_outlined),
              const SizedBox(width: 8),
              const Text(
                '过敏源',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addAllergen,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('添加'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_allergens.isEmpty)
            Text(
              '暂无过敏源',
              style: TextStyle(color: Colors.grey[600]),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allergens.map((allergen) {
                return Chip(
                  label: Text(allergen),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _allergens.remove(allergen);
                    });
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  void _addAllergen() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('添加过敏源'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '请输入过敏源名称',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    if (!_allergens.contains(controller.text)) {
                      _allergens.add(controller.text);
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }
}
