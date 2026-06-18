import 'dart:math';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/random_picker.dart';
import '../../../data/models/dish.dart';

class SpinPlan {
  final List<Dish> displayed;
  final int winnerIdx;
  final Dish winner;
  final double startAngle;
  final double endAngle;
  final int hiddenCount;

  const SpinPlan({
    required this.displayed,
    required this.winnerIdx,
    required this.winner,
    required this.startAngle,
    required this.endAngle,
    required this.hiddenCount,
  });
}

class WheelController {
  WheelController._();

  /// 根据候选菜品和当前转盘角度，计算一次旋转计划。
  ///
  /// 算法：
  /// 1. 候选数 > 8 时随机抽 8 个上转盘
  /// 2. 从转盘上的菜品中随机选 winner
  /// 3. 计算让 winner 扇区中心对准 12 点钟方向所需的角度（含随机抖动）
  /// 4. 加上 5~8 圈旋转，得到最终角度
  static SpinPlan plan({
    required List<Dish> allCandidates,
    required double currentAngle,
  }) {
    assert(allCandidates.isNotEmpty, 'candidates must not be empty');

    final n = allCandidates.length > AppConstants.wheelMaxSlices
        ? AppConstants.wheelMaxSlices
        : allCandidates.length;
    final displayed = RandomPicker.sample(allCandidates, n);

    final winnerIdx = RandomPicker.nextInt(displayed.length);
    final winner = displayed[winnerIdx];

    final sliceAngle = 2 * pi / displayed.length;
    final jitterRange = sliceAngle * 0.35;
    final jitter = RandomPicker.nextDoubleInRange(-jitterRange, jitterRange);

    // 让 winnerIdx 扇区中心对准 12 点（即转盘整体相对于初始位置旋转的目标角度）
    final target = -winnerIdx * sliceAngle + jitter;

    final turns = RandomPicker.nextDoubleInRange(
      AppConstants.spinMinTurns,
      AppConstants.spinMaxTurns,
    );

    final normalizedCurrent = currentAngle % (2 * pi);
    var delta = (target - normalizedCurrent) % (2 * pi);
    if (delta <= 0) delta += 2 * pi;
    final endAngle = currentAngle + 2 * pi * turns.floorToDouble() + delta;

    return SpinPlan(
      displayed: displayed,
      winnerIdx: winnerIdx,
      winner: winner,
      startAngle: currentAngle,
      endAngle: endAngle,
      hiddenCount: allCandidates.length - displayed.length,
    );
  }
}
