import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game_game/theme/theme.dart';

class X extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const X(this.size, this.strokeWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CustomPaint(painter: _XPainter(strokeWidth)),
    );
  }
}

class _XPainter extends CustomPainter {
  final double strokeWidth;

  _XPainter(this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MyTheme.red
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw two crossing lines with smooth animation
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
