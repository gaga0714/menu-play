import 'package:flutter/material.dart';

import '../../../data/models/dish.dart';

class WheelResultDialog extends StatelessWidget {
  final Dish winner;
  final int hiddenCount;
  final VoidCallback onSpinAgain;

  const WheelResultDialog({
    super.key,
    required this.winner,
    required this.hiddenCount,
    required this.onSpinAgain,
  });

  static Future<void> show(
    BuildContext context, {
    required Dish winner,
    required int hiddenCount,
    required VoidCallback onSpinAgain,
  }) {
    return showDialog(
      context: context,
      builder: (_) => WheelResultDialog(
        winner: winner,
        hiddenCount: hiddenCount,
        onSpinAgain: onSpinAgain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('今天就吃这个！'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.celebration, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            winner.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onSpinAgain();
          },
          child: const Text('再转一次'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('就吃这个'),
        ),
      ],
    );
  }
}
