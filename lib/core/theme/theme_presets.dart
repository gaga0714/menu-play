import 'package:flutter/material.dart';

class ThemePreset {
  final String name;
  final Color seedColor;

  const ThemePreset({required this.name, required this.seedColor});
}

class ThemePresets {
  ThemePresets._();

  static const List<ThemePreset> presets = [
    ThemePreset(name: '靛蓝', seedColor: Color(0xFF3F51B5)),
    ThemePreset(name: '青绿', seedColor: Color(0xFF009688)),
    ThemePreset(name: '粉红', seedColor: Color(0xFFE91E63)),
    ThemePreset(name: '橙色', seedColor: Color(0xFFFF9800)),
    ThemePreset(name: '草绿', seedColor: Color(0xFF4CAF50)),
    ThemePreset(name: '砖红', seedColor: Color(0xFFE53935)),
    ThemePreset(name: '紫罗兰', seedColor: Color(0xFF9C27B0)),
    ThemePreset(name: '石板', seedColor: Color(0xFF607D8B)),
  ];

  static const int defaultIndex = 0;

  static ThemePreset get(int index) {
    if (index < 0 || index >= presets.length) {
      return presets[defaultIndex];
    }
    return presets[index];
  }
}
