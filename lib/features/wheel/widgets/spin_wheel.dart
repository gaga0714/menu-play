import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/wheel_color_schemes.dart';
import '../../../data/models/dish.dart';

class SpinWheel extends StatelessWidget {
  final List<Dish> dishes;
  final double rotation;
  final WheelColorScheme scheme;

  const SpinWheel({
    super.key,
    required this.dishes,
    required this.rotation,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _WheelPainter(
          dishes: dishes,
          rotation: rotation,
          scheme: scheme,
          borderColor: Theme.of(context).colorScheme.surface,
          textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<Dish> dishes;
  final double rotation;
  final WheelColorScheme scheme;
  final Color borderColor;
  final TextStyle textStyle;

  _WheelPainter({
    required this.dishes,
    required this.rotation,
    required this.scheme,
    required this.borderColor,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dishes.isEmpty) return;

    final radius = size.shortestSide / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    final n = dishes.length;
    final sliceAngle = 2 * pi / n;
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = borderColor;

    for (int i = 0; i < n; i++) {
      // 第 0 个扇区中心对准 12 点（-π/2）
      final startAngle = -pi / 2 + i * sliceAngle - sliceAngle / 2;
      fillPaint.color = scheme.colorAt(i);
      canvas.drawArc(rect, startAngle, sliceAngle, true, fillPaint);
      canvas.drawArc(rect, startAngle, sliceAngle, true, borderPaint);
    }

    // 外圈
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = borderColor,
    );

    // 文字（径向：头朝外圆）
    for (int i = 0; i < n; i++) {
      final centerAngle = -pi / 2 + i * sliceAngle;
      final tx = center.dx + radius * 0.62 * cos(centerAngle);
      final ty = center.dy + radius * 0.62 * sin(centerAngle);

      final tp = TextPainter(
        text: TextSpan(text: dishes[i].name, style: textStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
        ellipsis: '…',
      );
      tp.layout(maxWidth: radius * 0.6);

      canvas.save();
      canvas.translate(tx, ty);
      canvas.rotate(centerAngle + pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    canvas.restore();

    // 中心装饰（不随转盘旋转）
    canvas.drawCircle(
      center,
      radius * 0.08,
      Paint()..color = borderColor,
    );
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) {
    return old.rotation != rotation ||
        old.dishes != dishes ||
        old.scheme != scheme ||
        old.borderColor != borderColor;
  }
}
