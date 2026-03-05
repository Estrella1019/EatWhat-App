# 吃啥 APP — 前端应用 / EatWhat APP — Frontend Application

> Flutter + YOLO-World 食材识别 + Qwen 大模型菜谱推荐 + 用户认证系统
> Flutter + YOLO-World Ingredient Recognition + Qwen LLM Recipe Generation + User Authentication

---

## 目录 / Table of Contents

- [项目简介 / Overview](#项目简介--overview)
- [小组分工 / Team Structure](#小组分工--team-structure)
- [核心功能 / Core Features](#核心功能--core-features)
- [技术栈 / Tech Stack](#技术栈--tech-stack)
- [项目结构 / Project Structure](#项目结构--project-structure)
- [快速开始 / Quick Start](#快速开始--quick-start)
- [后端对接 / Backend Integration](#后端对接--backend-integration)
- [团队分工 / Team Structure](#团队分工--team-structure)

---

## 项目简介 / Overview

**中文**
用户通过拍照上传食材图片，前端调用后端 YOLO-World 模型识别食材，再将识别结果传给本地 Qwen 大模型生成个性化菜谱（支持人数、忌口、过敏原、口味偏好）。用户可注册/登录，收藏菜谱，管理个人过敏原和多用户档案。

**English**
Users upload photos of their ingredients. The app calls the backend YOLO-World model to detect ingredients, then passes the results to a local Qwen LLM to generate personalized recipes. Users can register/login, save favorites, manage allergens, and create multiple user profiles for family members.

---
## 👥 小组分工 (Team Members & Roles)

| 姓名 (Name) | 角色 (Role) | 主要职责 (Responsibilities) |
| :--- | :--- | :--- |
| **Tao Yufei** | **项目经理 (PM)** / 后端 | 需求分析、进度把控、FastAPI 架构搭建、数据库设计 |
| **Pan Jiaying** | **前端负责人 (Frontend Lead)** | Flutter 移动端 UI 开发、状态管理 (Provider)、前后端 API 对接 |
| **Jin Xinyi** | UI 设计 / 测试 | Figma 原型设计、用户体验优化、QA 测试与文档编写 |
| **Liu Xingzhe** | AI 算法工程师 | YOLOv8 食材识别模型训练、Ollama/LLM 服务部署 |
| **Cheng Yuxiang** | 后端开发 / 运维 | 编写 API 接口、Docker 环境配置、服务器部署 |

---
## 核心功能 / Core Features

### 1. 智能食材识别 / Smart Ingredient Recognition
- 📸 拍照识别 + AR 实时扫描 / Photo recognition + AR real-time scanning
- 🎯 支持 50+ 常见食材 / Supports 50+ common ingredients
- ⚖️ 重量估算 / Weight estimation
- 🔄 与后端 YOLO-World 模型对接 / Integrated with backend YOLO-World

### 2. 个性化菜谱生成 / Personalized Recipe Generation
- 🤖 基于 Qwen 大模型生成菜谱 / Powered by Qwen LLM
- 👥 支持多人就餐场景 / Multi-person dining support
- 🚫 过敏原自动过滤 / Automatic allergen filtering
- 🎨 口味偏好定制 / Taste preference customization
- 🔄 备用菜即时替换 / Instant candidate dish swapping

### 3. 用户认证系统 / User Authentication
- 🔐 注册/登录功能 / Register/Login functionality
- 🎫 JWT token 自动管理 / Automatic JWT token management
- ⭐ 收藏菜谱 / Save favorite recipes
- 🏥 过敏原管理 / Allergen management
- 👤 多用户档案 / Multiple user profiles

### 4. 虚拟冰箱 / Virtual Pantry
- 📦 食材库存管理 / Ingredient inventory management
- ⏰ 过期提醒 / Expiration reminders
- 📊 分类展示 / Categorized display

### 5. 国际化支持 / Internationalization
- 🌍 简体中文 / Simplified Chinese
- 🌎 English
- 🔄 动态语言切换 / Dynamic language switching


---
## 🛠 技术栈

### 前端 (Flutter)
- **框架**: Flutter (跨平台移动应用框架)
- **状态管理**: Provider
- **数据持久化**: SharedPreferences
- **网络请求**: Dio
- **核心依赖**: Image Picker, Flutter Localizations

### 后端 (Python + FastAPI)
- **Web 框架**: FastAPI
- **CV 模型**: YOLOv8s-World (ultralytics) - 零样本食材识别
- **大语言模型**: Qwen3:14b (via Ollama) - 菜谱生成
- **数据库**: PostgreSQL + SQLAlchemy
- **认证鉴权**: JWT (python-jose + passlib)
  
---

## 项目结构 / Project Structure

```
lib/
├── main.dart                    # 应用入口 / App entry point
├── config/
│   └── theme.dart              # 主题配置 / Theme configuration
├── l10n/                       # 国际化文件 / Localization files
│   ├── app_localizations.dart
│   ├── app_zh.arb             # 简体中文
│   └── app_en.arb             # English
├── models/
│   ├── user.dart              # 用户模型 / User model
│   ├── recipe.dart            # 菜谱模型 / Recipe model
│   ├── ingredient.dart        # 食材模型 / Ingredient model
│   ├── auth.dart              # 认证模型 / Auth models
│   ├── favorite.dart          # 收藏模型 / Favorite models
│   └── pantry.dart            # 冰箱模型 / Pantry model
├── providers/
│   ├── user_provider.dart     # 用户状态管理 / User state
│   ├── global_provider.dart   # 全局状态管理 / Global state
│   └── pantry_provider.dart   # 冰箱状态管理 / Pantry state
├── services/
│   ├── api_service.dart       # API 服务 / API service
│   ├── auth_service.dart      # 认证服务 / Auth service
│   ├── storage_service.dart   # 本地存储 / Local storage
│   ├── media_service.dart     # 媒体服务 / Media service
│   └── pantry_service.dart    # 冰箱服务 / Pantry service
├── screens/
│   ├── home_screen.dart       # 主页 / Home
│   ├── login_screen.dart      # 登录 / Login
│   ├── register_screen.dart   # 注册 / Register
│   ├── profile_screen.dart    # 个人资料 / Profile
│   ├── pantry_screen.dart     # 虚拟冰箱 / Pantry
│   ├── result_screen.dart     # 结果页 / Results
│   ├── recipe_detail_screen.dart  # 菜谱详情 / Recipe detail
│   └── favorites_screen.dart  # 收藏列表 / Favorites
└── widgets/
    └── recipe_card.dart       # 菜谱卡片 / Recipe card
```

---

## 快速开始 / Quick Start

### 前置条件 / Prerequisites

1. **Flutter SDK 3.0+**
2. **后端服务已启动** / Backend service running
   - 参考后端仓库：https://github.com/noasse/eating
   - 确保后端运行在 `http://localhost:8000`

### 安装依赖 / Install Dependencies

```bash
flutter pub get
```

### 生成国际化文件 / Generate Localization Files

```bash
flutter gen-l10n
```

### 配置后端地址 / Configure Backend URL

修改 `lib/services/api_service.dart` 和 `lib/services/auth_service.dart` 中的 `baseUrl`：

```dart
// 模拟器测试 / Simulator testing
static const String _baseUrl = 'http://localhost:8000';

// 真机测试 / Physical device testing
static const String _baseUrl = 'http://192.168.x.x:8000';  // 替换为你的电脑IP
```

### 启动应用 / Start Application

```bash
flutter run
```

---

## 后端对接 / Backend Integration

### API 接口 / API Endpoints

所有接口统一返回格式 / Unified response format:

```json
{
  "code": 200,
  "message": "success",
  "data": { ... }
}
```

需要登录的接口须在 Header 中携带 / Protected endpoints require:
```
Authorization: Bearer <access_token>
```

---

### 认证接口 / Authentication

#### 注册 / Register
**`POST /api/auth/register`**

```dart
await AuthService.getInstance().register(
  username: "张三",
  email: "zhangsan@example.com",
  password: "your_password",
);
```

#### 登录 / Login
**`POST /api/auth/login`**

```dart
await AuthService.getInstance().login(
  username: "张三",
  password: "your_password",
);
```

---

### 食材识别 / Ingredient Recognition

**`POST /api/ingredients/recognize`**

```dart
final result = await ApiService.getInstance().identifyIngredients(
  imageBytes: imageBytes,
);
```

**响应示例 / Response Example:**
```json
{
  "code": 200,
  "data": {
    "detected_ingredients": [
      {
        "name": { "zh": "番茄/西红柿", "en": "Tomato" },
        "category": "vegetables",
        "confidence": 0.748,
        "bbox": [440.5, 344.6, 552.9, 449.4]
      }
    ]
  }
}
```

---

### 菜谱生成 / Recipe Generation

**`POST /api/recipes/generate`**

> ⚠️ 本接口调用本地大模型，响应时间约 30–120 秒。
> ⚠️ This endpoint calls a local LLM. Response time is ~30–120 seconds.

```dart
final result = await ApiService.getInstance().generateRecipes(
  ingredients: ["番茄", "鸡蛋", "土豆"],
  allergens: ["花生"],
  servings: 2,
  preferences: ["快手", "下饭"],
);
```

**响应包含主菜单 + 2道备用菜 / Response includes main dishes + 2 candidates:**
```json
{
  "code": 200,
  "data": {
    "recipes": [...],      // 主菜单
    "candidates": [...]    // 备用菜（前端即时替换，无需再次调用接口）
  }
}
```

---

### 收藏管理 / Favorites Management

#### 获取收藏列表 / Get Favorites
**`GET /api/users/favorites`**

```dart
final favorites = await AuthService.getInstance().getFavorites();
```

#### 添加收藏 / Add Favorite
**`POST /api/users/favorites`**

```dart
await AuthService.getInstance().addFavorite(
  recipeName: "番茄炒蛋",
  recipeData: recipe.toJson(),
);
```

#### 删除收藏 / Delete Favorite
**`DELETE /api/users/favorites/{id}`**

```dart
await AuthService.getInstance().deleteFavorite(favoriteId);
```

---

### 过敏原管理 / Allergen Management

#### 获取过敏原 / Get Allergens
**`GET /api/users/allergens`**

```dart
final allergens = await AuthService.getInstance().getAllergens();
```

#### 添加过敏原 / Add Allergen
**`POST /api/users/allergens`**

```dart
await AuthService.getInstance().addAllergen("花生");
```

#### 删除过敏原 / Delete Allergen
**`DELETE /api/users/allergens/{id}`**

```dart
await AuthService.getInstance().deleteAllergen(allergenId);
```

---


---

## 开发进度 / Development Progress

- [x] 基础框架搭建 / Basic framework
- [x] 国际化支持 / Internationalization
- [x] 食材识别功能 / Ingredient recognition
- [x] 菜谱生成功能 / Recipe generation
- [x] 用户认证系统 / User authentication
- [x] 收藏功能 / Favorites
- [x] 过敏原管理 / Allergen management
- [x] 虚拟冰箱 / Virtual pantry
- [x] 多用户档案 / Multiple profiles
- [x] 前后端完整对接 / Full backend integration

---

## 相关链接 / Related Links

- **后端仓库 / Backend Repository**: https://github.com/noasse/eating
- **API 文档 / API Documentation**: http://localhost:8000/docs (启动后端后访问)

---

## 许可证 / License

MIT License

---

## 联系方式 / Contact

如有问题或建议，请提交 Issue 或 Pull Request。
For questions or suggestions, please submit an Issue or Pull Request.
