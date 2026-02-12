/// 用户数据模型
class User {
  final String id;
  final String name;
  final String? avatarUrl; // 头像URL
  final String? nickname; // 昵称
  final String? relationship; // 关系（自己、家人、朋友等）
  final DateTime? birthday; // 生日
  final String? gender; // 性别
  final List<String> allergens; // 过敏原
  final List<String> preferences; // 口味偏好
  final int defaultServings; // 默认就餐人数
  final String? locale; // 语言偏好 (null=跟随系统, 'zh'=简体中文, 'zh_Hant'=繁体中文, 'en'=英文)

  User({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.nickname,
    this.relationship,
    this.birthday,
    this.gender,
    this.allergens = const [],
    this.preferences = const [],
    this.defaultServings = 2,
    this.locale,
  });

  /// 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '用户',
      avatarUrl: json['avatar_url']?.toString(),
      nickname: json['nickname']?.toString(),
      relationship: json['relationship']?.toString(),
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'].toString())
          : null,
      gender: json['gender']?.toString(),
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preferences: (json['preferences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      defaultServings: json['default_servings'] as int? ?? 2,
      locale: json['locale']?.toString(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'nickname': nickname,
      'relationship': relationship,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'allergens': allergens,
      'preferences': preferences,
      'default_servings': defaultServings,
      'locale': locale,
    };
  }

  /// 创建副本
  User copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? nickname,
    String? relationship,
    DateTime? birthday,
    String? gender,
    List<String>? allergens,
    List<String>? preferences,
    int? defaultServings,
    String? locale,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nickname: nickname ?? this.nickname,
      relationship: relationship ?? this.relationship,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      allergens: allergens ?? this.allergens,
      preferences: preferences ?? this.preferences,
      defaultServings: defaultServings ?? this.defaultServings,
      locale: locale ?? this.locale,
    );
  }
}
