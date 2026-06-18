import 'package:flutter/material.dart';

import '../../../core/theme/pointer_styles.dart';

class WheelPointer extends StatelessWidget {
  final PointerShape shape;
  final double size;
  final Color color;

  const WheelPointer({
    super.key,
    required this.shape,
    this.size = 32,
    this.color = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.2,
      child: CustomPaint(
        painter: _PointerPainter(shape: shape, color: color),
      ),
    );
  }
}

class _PointerPainter extends CustomPainter {
  final PointerShape shape;
  final Color color;

  _PointerPainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    switch (shape) {
      case PointerShape.triangle:
        path
          ..moveTo(size.width / 2, size.height)
          ..lineTo(0, 0)
          ..lineTo(size.width, 0)
          ..close();
      case PointerShape.arrow:
        final midY = size.height * 0.4;
        path
          ..moveTo(size.width / 2, size.height)
          ..lineTo(0, midY)
          ..lineTo(size.width * 0.3, midY)
          ..lineTo(size.width * 0.3, 0)
          ..lineTo(size.width * 0.7, 0)
          ..lineTo(size.width * 0.7, midY)
          ..lineTo(size.width, midY)
          ..close();
      case PointerShape.drop:
        path
          ..moveTo(size.width / 2, size.height)
          ..quadraticBezierTo(size.width, size.height * 0.5,
              size.width / 2, 0)
          ..quadraticBezierTo(0, size.height * 0.5,
              size.width / 2, size.height)
          ..close();
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _PointerPainter old) {
    return old.shape != shape || old.color != color;
  }
}
