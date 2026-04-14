import 'package:flutter/material.dart';

/// 应用主题配置 — 暖橙食欲调 (Harvest Warm)
class AppTheme {
  // ── 主色调（暖橙金）──────────────────────────────
  /// 深琥珀橙 — 用于按钮、标题、AppBar文字
  static const Color primary = Color(0xFF845400);
  /// 亮橙金 — 用于按钮渐变高亮端、chip选中
  static const Color primaryContainer = Color(0xFFE3A043);
  /// 浅橙桃 — 用于chip背景、tag背景
  static const Color chipBackground = Color(0xFFFFE0B2);
  /// 深橙 — 用于chip文字
  static const Color chipText = Color(0xFF6D3800);

  // ── 背景 & 表面 ────────────────────────────────
  /// 奶油暖白 — scaffold背景
  static const Color background = Color(0xFFFBF9F5);
  /// 浅暖米 — section背景
  static const Color surfaceLow = Color(0xFFF5F3EF);
  /// 中暖米 — 卡片容器
  static const Color surfaceContainer = Color(0xFFEFEEEA);
  /// 纯白 — 卡片/输入框
  static const Color cardColor = Color(0xFFFFFFFF);

  // ── 文字 ──────────────────────────────────────
  /// 深暖棕 — 主文字
  static const Color textPrimary = Color(0xFF1B1C1A);
  /// 中棕 — 次级文字
  static const Color textSecondary = Color(0xFF514537);
  /// 浅棕 — placeholder / hint
  static const Color textHint = Color(0xFF837565);
  static const Color textWhite = Colors.white;

  // ── 功能色 ────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  /// 分割线 / 边框
  static const Color outline = Color(0xFFD6C4B1);

  // ── AR 扫描专用 ───────────────────────────────
  static const Color scanOverlay = Color(0x80000000);
  static const Color detectionBox = Color(0xFFE3A043);
  static const Color detectionLabel = Color(0xFF845400);

  // ── 圆角 ──────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // ── 阴影 ──────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF1B1C1A).withOpacity(0.06),
          blurRadius: 32,
          spreadRadius: -4,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: primary.withOpacity(0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  // ── 渐变（主按钮）────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  // ── 登录页背景渐变 ────────────────────────────
  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFE0B2), Color(0xFFFBF9F5)],
  );

  /// 获取全局 ThemeData
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        onPrimary: textWhite,
        primaryContainer: primaryContainer,
        secondary: primaryContainer,
        surface: background,
        error: error,
      ),
      scaffoldBackgroundColor: background,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          fontFamily: 'Manrope',
        ),
      ),

      // 卡片
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        shadowColor: Colors.transparent,
      ),

      // 按钮（使用渐变需在各页面单独实现，这里设基础样式）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // 输入框
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: textHint,
          fontSize: 14,
          fontFamily: 'Inter',
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // 文字
      textTheme: const TextTheme(
        // 大标题 — Manrope
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          fontFamily: 'Manrope',
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          fontFamily: 'Manrope',
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          fontFamily: 'Manrope',
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: 'Inter',
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: 'Inter',
        ),
        // 正文 — Inter
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
          fontFamily: 'Inter',
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
          fontFamily: 'Inter',
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: textHint,
          fontFamily: 'Inter',
        ),
        // Label
        labelMedium: TextStyle(
          fontSize: 11,
          color: textHint,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// 渐变按钮组件 — 全局复用
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? null
              : AppTheme.primaryGradient,
          color: onPressed == null ? AppTheme.outline : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          boxShadow: onPressed == null ? [] : AppTheme.buttonShadow,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
