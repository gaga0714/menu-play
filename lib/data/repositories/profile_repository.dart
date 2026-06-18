import '../../core/constants/storage_keys.dart';
import '../local/prefs_storage.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  final PrefsStorage _storage;

  ProfileRepository(this._storage);

  Future<UserProfile> load() async {
    final json = _storage.readJsonObject(StorageKeys.profile);
    if (json == null) return UserProfile.defaults;
    return UserProfile.fromJson(json);
  }

  Future<void> save(UserProfile profile) async {
    await _storage.writeJson(StorageKeys.profile, profile.toJson());
  }
}
