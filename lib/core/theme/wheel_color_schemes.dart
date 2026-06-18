import 'package:flutter/material.dart';

class WheelColorScheme {
  final String name;
  final List<Color> colors;

  const WheelColorScheme({required this.name, required this.colors});

  Color colorAt(int index) => colors[index % colors.length];
}

class WheelColorSchemes {
  WheelColorSchemes._();

  static const List<WheelColorScheme> schemes = [
    WheelColorScheme(
      name: '鲜艳',
      colors: [
        Color(0xFFFF6B6B),
        Color(0xFFFFD93D),
        Color(0xFF6BCB77),
        Color(0xFF4D96FF),
        Color(0xFFFF9F45),
        Color(0xFFA084DC),
        Color(0xFF26C6DA),
        Color(0xFFFF8FAB),
      ],
    ),
    WheelColorScheme(
      name: '马卡龙',
      colors: [
        Color(0xFFFFB5B5),
        Color(0xFFFFE5B4),
        Color(0xFFB5EAD7),
        Color(0xFFC7CEEA),
        Color(0xFFFFDAC1),
        Color(0xFFE2F0CB),
        Color(0xFFB5D8EB),
        Color(0xFFF7C6C7),
      ],
    ),
    WheelColorScheme(
      name: '莫兰迪',
      colors: [
        Color(0xFFB4A7A7),
        Color(0xFFC8B6A6),
        Color(0xFFA4B0A4),
        Color(0xFF8E9AAF),
        Color(0xFFCBC0AC),
        Color(0xFFB0A7C0),
        Color(0xFFA1B3B0),
        Color(0xFFD4A5A5),
      ],
    ),
    WheelColorScheme(
      name: '单色蓝',
      colors: [
        Color(0xFF1976D2),
        Color(0xFF42A5F5),
        Color(0xFF64B5F6),
        Color(0xFF90CAF9),
        Color(0xFFBBDEFB),
        Color(0xFF82B1FF),
        Color(0xFF448AFF),
        Color(0xFF2962FF),
      ],
    ),
  ];

  static const int defaultIndex = 0;

  static WheelColorScheme get(int index) {
    if (index < 0 || index >= schemes.length) {
      return schemes[defaultIndex];
    }
    return schemes[index];
  }
}
