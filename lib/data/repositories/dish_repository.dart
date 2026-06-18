import '../../core/constants/storage_keys.dart';
import '../local/prefs_storage.dart';
import '../models/dish.dart';

class DishRepository {
  final PrefsStorage _storage;

  DishRepository(this._storage);

  Future<List<Dish>> load() async {
    final list = _storage.readJsonArray(StorageKeys.dishes);
    if (list == null) return [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(Dish.fromJson)
        .toList();
  }

  Future<void> save(List<Dish> dishes) async {
    await _storage.writeJson(
      StorageKeys.dishes,
      dishes.map((d) => d.toJson()).toList(),
    );
  }
}
