/// 注册请求
class RegisterRequest {
  final String username;
  final String email;
  final String password;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}

/// 登录请求
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

/// 认证响应（登录/注册成功后返回）
class AuthResponse {
  final String accessToken;
  final String tokenType;
  final String username;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'bearer',
      username: json['username']?.toString() ?? '',
    );
  }
}

/// 用户信息（从后端获取）
class UserInfo {
  final int id;
  final String username;
  final String email;

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}
