import 'dart:math';

class RandomPicker {
  RandomPicker._();

  static final Random _rng = Random();

  /// 从 list 中随机抽取 n 个不重复元素。n >= list.length 时返回 list 的洗牌副本。
  static List<T> sample<T>(List<T> list, int n) {
    if (n >= list.length) {
      final copy = List<T>.of(list);
      copy.shuffle(_rng);
      return copy;
    }
    final copy = List<T>.of(list);
    copy.shuffle(_rng);
    return copy.sublist(0, n);
  }

  /// 返回 [0, max) 区间内的随机整数。
  static int nextInt(int max) => _rng.nextInt(max);

  /// 返回 [min, max) 区间内的随机 double。
  static double nextDoubleInRange(double min, double max) =>
      min + _rng.nextDouble() * (max - min);
}
