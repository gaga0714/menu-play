import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/section_tile.dart';
import '../../menu/providers/menu_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/avatar_editor.dart';
import '../widgets/nickname_editor.dart';
import 'about_page.dart';
import 'sound_settings_page.dart';
import 'theme_settings_page.dart';
import 'wheel_style_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListView(
        children: [
          if (!kIsWeb)
            const Padding(
              padding: EdgeInsets.all(16),
              child: AvatarEditor(),
            ),
          const NicknameTile(),
          const Divider(),
          _SectionHeader(text: '个性化'),
          SectionTile(
            leading: Icons.palette_outlined,
            title: '主题',
            onTap: () => _push(context, const ThemeSettingsPage()),
          ),
          SectionTile(
            leading: Icons.casino_outlined,
            title: '转盘样式',
            subtitle: '扇区配色 · 指针',
            onTap: () => _push(context, const WheelStylePage()),
          ),
          SectionTile(
            leading: Icons.volume_up_outlined,
            title: '音效',
            onTap: () => _push(context, const SoundSettingsPage()),
          ),
          const Divider(),
          _SectionHeader(text: '规则'),
          const SectionTile(
            leading: Icons.tune,
            title: '转盘规则设置',
            subtitle: '即将推出',
            // 占位，禁用点击
          ),
          const Divider(),
          _SectionHeader(text: '数据'),
          SectionTile(
            leading: Icons.delete_sweep_outlined,
            title: '清空所有数据',
            subtitle: '菜品、设置、个人资料一并重置',
            onTap: () => _confirmWipe(context, ref),
          ),
          const Divider(),
          _SectionHeader(text: '其他'),
          SectionTile(
            leading: Icons.widgets_outlined,
            title: '添加到桌面小组件',
            subtitle: '即将推出',
            // 占位
          ),
          SectionTile(
            leading: Icons.info_outline,
            title: '关于',
            onTap: () => _push(context, const AboutPage()),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _confirmWipe(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: '清空所有数据？',
      message: '这将永久删除全部菜品、重置个人资料和设置。此操作不可撤销。',
      confirmText: '清空',
      danger: true,
    );
    if (!ok) return;
    await ref.read(dishListProvider.notifier).clearAll();
    await ref.read(profileProvider.notifier).reset();
    await ref.read(settingsProvider.notifier).reset();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已清空所有数据')),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
