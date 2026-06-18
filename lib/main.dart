import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'app_providers.dart';
import 'data/local/prefs_storage.dart';
import 'data/repositories/dish_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await PrefsStorage.create();
  final dishes = await DishRepository(prefs).load();
  final profile = await ProfileRepository(prefs).load();
  final settings = await SettingsRepository(prefs).load();

  runApp(
    ProviderScope(
      overrides: [
        prefsStorageProvider.overrideWithValue(prefs),
        initialDishesProvider.overrideWithValue(dishes),
        initialProfileProvider.overrideWithValue(profile),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const MenuPlayApp(),
    ),
  );
}
