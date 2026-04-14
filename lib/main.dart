import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'config/theme.dart';
import 'providers/user_provider.dart';
import 'providers/global_provider.dart';
import 'providers/pantry_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/storage_service.dart';
import 'services/pantry_service.dart';
import 'screens/main_scaffold.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  final storage = await StorageService.getInstance();
  final pantryService = await PantryService.getInstance();

  // 检查登录态
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getString('auth_token') != null;

  runApp(MyApp(
    storage: storage,
    pantryService: pantryService,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storage;
  final PantryService pantryService;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.storage,
    required this.pantryService,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 用户状态管理
        ChangeNotifierProvider(
          create: (_) => UserProvider(storage),
        ),
        // 虚拟冰箱状态管理
        ChangeNotifierProvider(
          create: (_) => PantryProvider(pantryService),
        ),
        // 全局状态管理（依赖UserProvider）
        ChangeNotifierProxyProvider<UserProvider, GlobalProvider>(
          create: (context) => GlobalProvider(
            Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, userProvider, previous) =>
              previous ?? GlobalProvider(userProvider),
        ),
      ],
      child: MyMaterialApp(isLoggedIn: isLoggedIn),
    );
  }
}

class MyMaterialApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyMaterialApp({super.key, required this.isLoggedIn});

  @override
  State<MyMaterialApp> createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        print('=== MaterialApp 重建 ===');
        print('用户语言设置: ${userProvider.user.locale}');

        // 根据用户设置的语言偏好确定locale
        Locale? locale;
        if (userProvider.user.locale != null) {
          locale = Locale(userProvider.user.locale!);
          print('设置的 Locale: $locale');
        } else {
          print('使用系统语言');
        }

        // 使用 locale 作为 key，确保语言切换时 MaterialApp 重建
        return MaterialApp(
          key: ValueKey(userProvider.user.locale ?? 'system'),
          title: '吃啥APP',
          theme: AppTheme.getTheme(),
          home: widget.isLoggedIn ? const MainScaffold() : const LoginScreen(),
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // 强制使用指定的 locale
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            print('localeResolutionCallback 被调用');
            print('设备语言: $deviceLocale');
            print('用户选择: $locale');

            // 如果用户设置了语言，强制使用用户设置
            if (locale != null) {
              print('使用用户设置的语言: $locale');
              return locale;
            }

            // 否则使用设备语言
            if (deviceLocale != null) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == deviceLocale.languageCode) {
                  print('使用设备语言: $supportedLocale');
                  return supportedLocale;
                }
              }
            }

            // 默认使用简体中文
            print('使用默认语言: zh');
            return const Locale('zh');
          },
        );
      },
    );
  }
}
