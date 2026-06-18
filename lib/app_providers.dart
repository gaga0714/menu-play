import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/local/prefs_storage.dart';
import 'data/models/app_settings.dart';
import 'data/models/dish.dart';
import 'data/models/user_profile.dart';
import 'data/repositories/dish_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/settings_repository.dart';

/// 由 main() 在启动时 override 注入。
final prefsStorageProvider = Provider<PrefsStorage>((ref) {
  throw UnimplementedError('prefsStorageProvider must be overridden in main()');
});

final dishRepositoryProvider = Provider<DishRepository>(
  (ref) => DishRepository(ref.watch(prefsStorageProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(prefsStorageProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(prefsStorageProvider)),
);

/// 启动时从 repository 预加载，由 main() 注入。
final initialDishesProvider = Provider<List<Dish>>((ref) {
  throw UnimplementedError('initialDishesProvider must be overridden in main()');
});

final initialProfileProvider = Provider<UserProfile>((ref) {
  throw UnimplementedError('initialProfileProvider must be overridden in main()');
});

final initialSettingsProvider = Provider<AppSettings>((ref) {
  throw UnimplementedError('initialSettingsProvider must be overridden in main()');
});
