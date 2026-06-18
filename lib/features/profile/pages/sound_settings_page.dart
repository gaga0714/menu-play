import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class SoundSettingsPage extends ConsumerWidget {
  const SoundSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('音效')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('旋转音效'),
            subtitle: const Text('点击「开始旋转」时播放'),
            value: settings.spinSoundEnabled,
            onChanged: (v) =>
                ref.read(settingsProvider.notifier).setSpinSoundEnabled(v),
          ),
          SwitchListTile(
            title: const Text('中奖音效'),
            subtitle: const Text('转盘停止时播放'),
            value: settings.winSoundEnabled,
            onChanged: (v) =>
                ref.read(settingsProvider.notifier).setWinSoundEnabled(v),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '当前版本使用系统提示音 + 触觉反馈。',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
