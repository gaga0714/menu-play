import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pointer_styles.dart';
import '../../../core/theme/wheel_color_schemes.dart';
import '../../wheel/widgets/pointer.dart';
import '../providers/settings_provider.dart';

class WheelStylePage extends ConsumerWidget {
  const WheelStylePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('转盘样式')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('扇区配色', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          RadioGroup<int>(
            groupValue: settings.wheelSchemeIndex,
            onChanged: (v) {
              if (v != null) {
                ref.read(settingsProvider.notifier).setWheelSchemeIndex(v);
              }
            },
            child: Column(
              children: [
                for (var i = 0; i < WheelColorSchemes.schemes.length; i++)
                  RadioListTile<int>(
                    value: i,
                    title: Text(WheelColorSchemes.schemes[i].name),
                    subtitle: _ColorPreview(
                        scheme: WheelColorSchemes.schemes[i]),
                  ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('指针样式', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          RadioGroup<int>(
            groupValue: settings.pointerStyleIndex,
            onChanged: (v) {
              if (v != null) {
                ref.read(settingsProvider.notifier).setPointerStyleIndex(v);
              }
            },
            child: Column(
              children: [
                for (var i = 0; i < PointerStyles.styles.length; i++)
                  RadioListTile<int>(
                    value: i,
                    title: Text(PointerStyles.styles[i].name),
                    secondary: WheelPointer(
                      shape: PointerStyles.styles[i].shape,
                      size: 28,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorPreview extends StatelessWidget {
  final WheelColorScheme scheme;
  const _ColorPreview({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          for (final c in scheme.colors)
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(color: c, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
