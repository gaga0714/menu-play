# 吃啥 (menu-play)

一个用转盘决定吃什么的 Flutter 小工具。

线上网址：http://gaga0714.top:10005/

## 功能

- **转盘**：从菜单中随机抽取，点击开始后自动停止并指向结果。受转盘大小限制时会提示「部分菜品未显示」。
- **菜单**：增删改菜品，勾选本轮参与转盘的菜品。
- **推荐**：占位（v1 暂未实现）。
- **我的**：昵称、头像、应用主题色、转盘风格、音效设置，以及账号登出/注销。

## 技术栈

- Flutter（Dart SDK `^3.12.2`）
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) — 状态管理
- [shared_preferences](https://pub.dev/packages/shared_preferences) — 本地存储
- [file_picker](https://pub.dev/packages/file_picker) + [path_provider](https://pub.dev/packages/path_provider) — 头像选择与本地落盘
- [uuid](https://pub.dev/packages/uuid) — 菜品 id

## 目录结构

```
lib/
  main.dart              入口
  app.dart               根 Widget
  app_providers.dart     全局 Provider
  routing/               底部导航脚手架
  core/                  常量、主题、工具
  data/                  Model / Repository / 本地存储
  features/
    wheel/               转盘
    menu/                菜单
    recommend/           推荐（占位）
    profile/             我的
  shared/                通用组件
```

## 运行

```bash
flutter pub get
flutter run            # 默认设备
flutter run -d chrome  # Web
```

## 构建

```bash
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
flutter build macos    # macOS
```

## 相关文档

- [需求.md](./需求.md) — 功能需求
- [实现方案.md](./实现方案.md) — 技术方案
