import 'package:flutter/material.dart';

class InstructorPainter extends CustomPainter {
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
    var rect=Offset.zero & size;
    paint.shader=LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
      Color.fromRGBO(204, 0, 102, 1),
      Color.fromRGBO(255, 0, 127, 1),
      Color.fromRGBO(204, 0, 102, 1),
      Color.fromRGBO(255, 51, 153, 1),
      Color.fromRGBO(204, 0, 102, 1)]
    ).createShader(rect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
