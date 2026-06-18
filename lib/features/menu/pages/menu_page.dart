import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/menu_provider.dart';
import '../widgets/add_dish_sheet.dart';
import '../widgets/dish_tile.dart';
import '../widgets/empty_menu_view.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishes = ref.watch(dishListProvider);
    final selectedCount = ref.watch(selectedDishesProvider).length;
    final notifier = ref.read(dishListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('菜单'),
        actions: [
          if (dishes.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'all') notifier.selectAll();
                if (v == 'none') notifier.unselectAll();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'all', child: Text('全选')),
                PopupMenuItem(value: 'none', child: Text('全不选')),
              ],
            ),
        ],
        bottom: dishes.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(24),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '已勾选 $selectedCount / ${dishes.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
      ),
      body: dishes.isEmpty
          ? const EmptyMenuView()
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: dishes.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) => DishTile(dish: dishes[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddDishSheet.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
