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

  // ── 辅助色（来自Figma设计系统）────────────────
  /// 绿色 — secondary
  static const Color secondary = Color(0xFF4A6640);
  /// 浅绿 — secondary container
  static const Color secondaryContainer = Color(0xFFC8E9B9);
  /// 浅绿底色
  static const Color secondaryLight = Color(0xFFCBECBC);
  /// 浅橙桃 — primary fixed
  static const Color primaryFixed = Color(0xFFFFDDB6);
  /// 浅橙桃暗色
  static const Color primaryFixedDim = Color(0xFFFFB95B);
  /// 三底色
  static const Color tertiary = Color(0xFF665E4C);
  /// 三底色容器
  static const Color tertiaryContainer = Color(0xFFB6AC98);

  // ── 表面色（来自Figma设计系统）────────────────
  /// 最暗表面
  static const Color surfaceDim = Color(0xFFDBDAD6);
  /// 最高容器
  static const Color surfaceHighest = Color(0xFFE4E2DE);
  /// 低容器
  static const Color surfaceLowest = Color(0xFFFFFFFF);

  // ── 文字功能色 ───────────────────────────────
  /// 次级文字
  static const Color textGreen = Color(0xFF4E6A44);

  // ── AR 扫描专用 ───────────────────────────────
  static const Color scanOverlay = Color(0x80000000);
  static const Color detectionBox = Color(0xFFE3A043);
  static const Color detectionLabel = Color(0xFF845400);

  // ── 圆角 ──────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 32.0;
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
  final double height;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null || isLoading
              ? null
              : AppTheme.primaryGradient,
          color: (onPressed == null || isLoading) ? AppTheme.outline : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          boxShadow: (onPressed == null || isLoading) ? [] : AppTheme.buttonShadow,
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

/// Figma风格顶部导航栏
class FigmaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final Widget? leading;
  final Widget? trailing;
  final bool centerTitle;
  final double elevation;

  const FigmaAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.leading,
    this.trailing,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.9),
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
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppTheme.primary, size: 20),
                    onPressed: () => Navigator.pop(context),
                  )
                else if (leading != null)
                  leading!
                else
                  const SizedBox(width: 48),
                if (centerTitle)
                  const Spacer(),
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      fontFamily: 'Manrope',
                    ),
                  ),
                if (centerTitle)
                  const Spacer(),
                if (trailing != null)
                  trailing!
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 分段标签组件（Figma风格）
class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.textHint,
          letterSpacing: 1.5,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

/// 偏好标签组件
class PrefLabel extends StatelessWidget {
  final String text;

  const PrefLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 1.5,
        fontFamily: 'Inter',
      ),
    );
  }
}

/// Figma风格ListTile设置行
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Widget? trailing;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppTheme.textSecondary, size: 22),
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
            trailing ??
                const Icon(Icons.arrow_forward_ios,
                    color: AppTheme.textHint, size: 14),
          ],
        ),
      ),
    );
  }
}
