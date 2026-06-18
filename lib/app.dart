import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/profile/providers/settings_provider.dart';
import 'routing/main_scaffold.dart';

class MenuPlayApp extends ConsumerWidget {
  const MenuPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightTheme = ref.watch(appLightThemeProvider);
    final darkTheme = ref.watch(appDarkThemeProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: '吃啥',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const MainScaffold(),
    );
  }
}
