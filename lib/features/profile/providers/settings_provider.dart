import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_providers.dart';
import '../../../core/theme/theme_presets.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/repositories/settings_repository.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  SettingsNotifier(this._repo, AppSettings initial) : super(initial);

  Future<void> setThemeColorIndex(int index) async {
    state = state.copyWith(themeColorIndex: index);
    await _repo.save(state);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repo.save(state);
  }

  Future<void> setWheelSchemeIndex(int index) async {
    state = state.copyWith(wheelSchemeIndex: index);
    await _repo.save(state);
  }

  Future<void> setPointerStyleIndex(int index) async {
    state = state.copyWith(pointerStyleIndex: index);
    await _repo.save(state);
  }

  Future<void> setSpinSoundEnabled(bool value) async {
    state = state.copyWith(spinSoundEnabled: value);
    await _repo.save(state);
  }

  Future<void> setWinSoundEnabled(bool value) async {
    state = state.copyWith(winSoundEnabled: value);
    await _repo.save(state);
  }

  Future<void> reset() async {
    state = AppSettings.defaults;
    await _repo.save(state);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(
    ref.watch(settingsRepositoryProvider),
    ref.watch(initialSettingsProvider),
  );
});

ThemeData _buildTheme(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    ),
  );
}

final appLightThemeProvider = Provider<ThemeData>((ref) {
  final s = ref.watch(settingsProvider);
  final preset = ThemePresets.get(s.themeColorIndex);
  return _buildTheme(preset.seedColor, Brightness.light);
});

final appDarkThemeProvider = Provider<ThemeData>((ref) {
  final s = ref.watch(settingsProvider);
  final preset = ThemePresets.get(s.themeColorIndex);
  return _buildTheme(preset.seedColor, Brightness.dark);
});

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});
