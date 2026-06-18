import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/dish.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../providers/menu_provider.dart';

class DishTile extends ConsumerWidget {
  final Dish dish;

  const DishTile({super.key, required this.dish});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Checkbox(
        value: dish.selected,
        onChanged: (_) =>
            ref.read(dishListProvider.notifier).toggleSelected(dish.id),
      ),
      title: Text(dish.name),
      onTap: () => ref.read(dishListProvider.notifier).toggleSelected(dish.id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: '编辑',
            onPressed: () => _editName(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: '删除',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: dish.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('编辑菜名'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: AppConstants.maxDishNameLength,
            inputFormatters: [
              LengthLimitingTextInputFormatter(AppConstants.maxDishNameLength),
            ],
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onSubmitted: (v) => Navigator.of(ctx).pop(v),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (newName != null && newName.trim().isNotEmpty && newName != dish.name) {
      await ref.read(dishListProvider.notifier).rename(dish.id, newName);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: '删除菜品',
      message: '确定要删除「${dish.name}」吗？',
      confirmText: '删除',
      danger: true,
    );
    if (ok) {
      await ref.read(dishListProvider.notifier).remove(dish.id);
    }
  }
}
