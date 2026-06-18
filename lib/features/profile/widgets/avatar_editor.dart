import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../providers/profile_provider.dart';

class AvatarEditor extends ConsumerWidget {
  const AvatarEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final theme = Theme.of(context);

    Widget avatar;
    if (profile.avatarPath != null && !kIsWeb) {
      avatar = CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(File(profile.avatarPath!)),
      );
    } else {
      avatar = CircleAvatar(
        radius: 40,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.person,
          size: 40,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      );
    }

    return Row(
      children: [
        avatar,
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('头像', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                kIsWeb
                    ? 'Web 端暂不支持本地头像，请使用桌面或手机端'
                    : '点击右侧按钮更换头像',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        if (!kIsWeb) ...[
          IconButton(
            tooltip: '更换头像',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _pickAvatar(context, ref),
          ),
          if (profile.avatarPath != null)
            IconButton(
              tooltip: '清除头像',
              icon: const Icon(Icons.close),
              onPressed: () =>
                  ref.read(profileProvider.notifier).clearAvatar(),
            ),
        ],
      ],
    );
  }

  Future<void> _pickAvatar(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final picked = result.files.first;
    if (picked.path == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final destPath = p.join(
      dir.path,
      'avatar${p.extension(picked.path!)}',
    );
    final source = File(picked.path!);
    final dest = File(destPath);
    await dest.create(recursive: true);
    await source.copy(destPath);

    await ref.read(profileProvider.notifier).setAvatarPath(destPath);
  }
}
