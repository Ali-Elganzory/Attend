import 'package:flutter/material.dart';

class StudentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;
    Paint paint = Paint();

    Path path = Path();

    path.moveTo(0, sh);
    path.lineTo(0, 0.3 * sh);
    path.quadraticBezierTo(0.5 * sw, 0, sw, 0.3 * sh);
    path.lineTo(sw, sh);
    path.close();

    var rect = Offset.zero & size;
    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(112, 252, 255, 1),
        Color.fromRGBO(123, 112, 255, 1)
      ],
    ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
