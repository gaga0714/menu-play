import 'package:flutter/material.dart';

import '../../core/theme/pointer_styles.dart';
import '../../core/theme/theme_presets.dart';
import '../../core/theme/wheel_color_schemes.dart';

class AppSettings {
  final int themeColorIndex;
  final ThemeMode themeMode;
  final int wheelSchemeIndex;
  final int pointerStyleIndex;
  final bool spinSoundEnabled;
  final bool winSoundEnabled;

  const AppSettings({
    required this.themeColorIndex,
    required this.themeMode,
    required this.wheelSchemeIndex,
    required this.pointerStyleIndex,
    required this.spinSoundEnabled,
    required this.winSoundEnabled,
  });

  static const AppSettings defaults = AppSettings(
    themeColorIndex: ThemePresets.defaultIndex,
    themeMode: ThemeMode.system,
    wheelSchemeIndex: WheelColorSchemes.defaultIndex,
    pointerStyleIndex: PointerStyles.defaultIndex,
    spinSoundEnabled: true,
    winSoundEnabled: true,
  );

  AppSettings copyWith({
    int? themeColorIndex,
    ThemeMode? themeMode,
    int? wheelSchemeIndex,
    int? pointerStyleIndex,
    bool? spinSoundEnabled,
    bool? winSoundEnabled,
  }) {
    return AppSettings(
      themeColorIndex: themeColorIndex ?? this.themeColorIndex,
      themeMode: themeMode ?? this.themeMode,
      wheelSchemeIndex: wheelSchemeIndex ?? this.wheelSchemeIndex,
      pointerStyleIndex: pointerStyleIndex ?? this.pointerStyleIndex,
      spinSoundEnabled: spinSoundEnabled ?? this.spinSoundEnabled,
      winSoundEnabled: winSoundEnabled ?? this.winSoundEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeColorIndex': themeColorIndex,
        'themeMode': themeMode.index,
        'wheelSchemeIndex': wheelSchemeIndex,
        'pointerStyleIndex': pointerStyleIndex,
        'spinSoundEnabled': spinSoundEnabled,
        'winSoundEnabled': winSoundEnabled,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final modeIndex = json['themeMode'] as int? ?? ThemeMode.system.index;
    return AppSettings(
      themeColorIndex: json['themeColorIndex'] as int? ?? defaults.themeColorIndex,
      themeMode: ThemeMode.values[modeIndex.clamp(0, ThemeMode.values.length - 1)],
      wheelSchemeIndex: json['wheelSchemeIndex'] as int? ?? defaults.wheelSchemeIndex,
      pointerStyleIndex: json['pointerStyleIndex'] as int? ?? defaults.pointerStyleIndex,
      spinSoundEnabled: json['spinSoundEnabled'] as bool? ?? defaults.spinSoundEnabled,
      winSoundEnabled: json['winSoundEnabled'] as bool? ?? defaults.winSoundEnabled,
    );
  }
}
