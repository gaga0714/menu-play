import '../../core/constants/storage_keys.dart';
import '../local/prefs_storage.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  final PrefsStorage _storage;

  SettingsRepository(this._storage);

  Future<AppSettings> load() async {
    final json = _storage.readJsonObject(StorageKeys.settings);
    if (json == null) return AppSettings.defaults;
    return AppSettings.fromJson(json);
  }

  Future<void> save(AppSettings settings) async {
    await _storage.writeJson(StorageKeys.settings, settings.toJson());
  }
}
