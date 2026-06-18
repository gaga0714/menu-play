import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/pointer_styles.dart';
import '../../../core/theme/wheel_color_schemes.dart';
import '../../../data/models/dish.dart';
import '../../menu/providers/menu_provider.dart';
import '../../profile/providers/settings_provider.dart';
import '../controllers/wheel_controller.dart';
import '../widgets/pointer.dart';
import '../widgets/result_dialog.dart';
import '../widgets/spin_wheel.dart';

class WheelPage extends ConsumerStatefulWidget {
  const WheelPage({super.key});

  @override
  ConsumerState<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends ConsumerState<WheelPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  Animation<double> _animation = const AlwaysStoppedAnimation(0);

  List<Dish> _displayed = [];
  int _hiddenCount = 0;
  double _currentAngle = 0;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppConstants.spinDuration,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onSpin() async {
    if (_isSpinning) return;

    final candidates = ref.read(selectedDishesProvider);
    if (candidates.length < AppConstants.minSelectedDishes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('至少勾选 ${AppConstants.minSelectedDishes} 个菜品'),
        ),
      );
      return;
    }

    final settings = ref.read(settingsProvider);
    if (settings.spinSoundEnabled) {
      SystemSound.play(SystemSoundType.click);
      HapticFeedback.lightImpact();
    }

    final plan = WheelController.plan(
      allCandidates: candidates,
      currentAngle: _currentAngle,
    );

    setState(() {
      _displayed = plan.displayed;
      _hiddenCount = plan.hiddenCount;
      _isSpinning = true;
    });

    _animation = Tween<double>(
      begin: plan.startAngle,
      end: plan.endAngle,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutQuart),
    );
    _animController.reset();

    try {
      await _animController.forward().orCancel;
    } on TickerCanceled {
      return;
    }

    if (!mounted) return;
    setState(() {
      _currentAngle = plan.endAngle;
      _isSpinning = false;
    });

    if (settings.winSoundEnabled) {
      SystemSound.play(SystemSoundType.alert);
      HapticFeedback.heavyImpact();
    }

    if (!mounted) return;
    await WheelResultDialog.show(
      context,
      winner: plan.winner,
      hiddenCount: plan.hiddenCount,
      onSpinAgain: _onSpin,
    );
  }

  List<Dish> _previewDishes(List<Dish> selected) {
    if (selected.length <= AppConstants.wheelMaxSlices) return selected;
    return selected.sublist(0, AppConstants.wheelMaxSlices);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final scheme = WheelColorSchemes.get(settings.wheelSchemeIndex);
    final pointerStyle = PointerStyles.get(settings.pointerStyleIndex);

    final selected = ref.watch(selectedDishesProvider);
    final canSpin = ref.watch(canSpinProvider);

    final dishesForWheel = _displayed.isNotEmpty
        ? _displayed
        : _previewDishes(selected);

    return Scaffold(
      appBar: AppBar(title: const Text('转盘')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: dishesForWheel.isEmpty
                      ? _EmptyHint(canSpin: canSpin, selectedCount: selected.length)
                      : Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (_, _) => SpinWheel(
                                  dishes: dishesForWheel,
                                  rotation: _animation.value,
                                  scheme: scheme,
                                ),
                              ),
                            ),
                            WheelPointer(
                              shape: pointerStyle.shape,
                              color: Theme.of(context).colorScheme.error,
                              size: 36,
                            ),
                          ],
                        ),
                ),
              ),
              if (_hiddenCount > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '由于转盘大小限制，还有 $_hiddenCount 个菜品未显示',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.icon(
                icon: Icon(_isSpinning ? Icons.hourglass_top : Icons.casino),
                onPressed: (canSpin && !_isSpinning) ? _onSpin : null,
                label: Text(_isSpinning ? '旋转中…' : '开始旋转'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final bool canSpin;
  final int selectedCount;

  const _EmptyHint({required this.canSpin, required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline;
    final text = selectedCount == 0
        ? '去「菜单」添加并勾选菜品'
        : '至少勾选 ${AppConstants.minSelectedDishes} 个菜品才能转';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu_book_outlined, size: 72, color: color),
        const SizedBox(height: 16),
        Text(text, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
