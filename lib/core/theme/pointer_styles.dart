enum PointerShape { triangle, arrow, drop }

class PointerStyle {
  final String name;
  final PointerShape shape;

  const PointerStyle({required this.name, required this.shape});
}

class PointerStyles {
  PointerStyles._();

  static const List<PointerStyle> styles = [
    PointerStyle(name: '三角', shape: PointerShape.triangle),
    PointerStyle(name: '箭头', shape: PointerShape.arrow),
    PointerStyle(name: '水滴', shape: PointerShape.drop),
  ];

  static const int defaultIndex = 0;

  static PointerStyle get(int index) {
    if (index < 0 || index >= styles.length) {
      return styles[defaultIndex];
    }
    return styles[index];
  }
}
