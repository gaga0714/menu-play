import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../providers/profile_provider.dart';

class NicknameTile extends ConsumerWidget {
  const NicknameTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return ListTile(
      leading: const Icon(Icons.badge_outlined),
      title: const Text('昵称'),
      subtitle: Text(profile.nickname),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => _edit(context, ref, profile.nickname),
    );
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, String current) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('修改昵称'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: AppConstants.maxNicknameLength,
            inputFormatters: [
              LengthLimitingTextInputFormatter(AppConstants.maxNicknameLength),
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
    if (result != null && result.trim().isNotEmpty && result != current) {
      await ref.read(profileProvider.notifier).updateNickname(result);
    }
  }
}
