import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/dish.dart';
import '../../../data/repositories/dish_repository.dart';

class DishListNotifier extends StateNotifier<List<Dish>> {
  final DishRepository _repo;

  DishListNotifier(this._repo, List<Dish> initial) : super(initial);

  Future<void> add(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = [...state, Dish.create(name: trimmed)];
    await _repo.save(state);
  }

  Future<void> remove(String id) async {
    state = state.where((d) => d.id != id).toList();
    await _repo.save(state);
  }

  Future<void> rename(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(name: trimmed) else d,
    ];
    await _repo.save(state);
  }

  Future<void> toggleSelected(String id) async {
    state = [
      for (final d in state)
        if (d.id == id) d.copyWith(selected: !d.selected) else d,
    ];
    await _repo.save(state);
  }

  Future<void> selectAll() async {
    state = [for (final d in state) d.copyWith(selected: true)];
    await _repo.save(state);
  }

  Future<void> unselectAll() async {
    state = [for (final d in state) d.copyWith(selected: false)];
    await _repo.save(state);
  }

  Future<void> clearAll() async {
    state = [];
    await _repo.save(state);
  }
}

final dishListProvider =
    StateNotifierProvider<DishListNotifier, List<Dish>>((ref) {
  return DishListNotifier(
    ref.watch(dishRepositoryProvider),
    ref.watch(initialDishesProvider),
  );
});

final selectedDishesProvider = Provider<List<Dish>>((ref) {
  return ref.watch(dishListProvider).where((d) => d.selected).toList();
});

final canSpinProvider = Provider<bool>((ref) {
  return ref.watch(selectedDishesProvider).length >=
      AppConstants.minSelectedDishes;
});
