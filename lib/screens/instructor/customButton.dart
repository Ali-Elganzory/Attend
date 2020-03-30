import 'package:flutter/cupertino.dart';

class CustomButton extends CustomPainter{
final double width;
final double height;
CustomButton({this.width,this.height});
@override 

void paint(Canvas canvas,Size size){
  final paint=Paint();
  Rect rect=Rect.fromLTWH(0, 50, 300, 200);
   paint.color=Color.fromRGBO(255, 102, 102, 1);
   canvas.drawPath(getTrianglePath(this.width/2, this.height,rect), paint);
   print(size.width);
   print('Hello');
}
Path getTrianglePath(double x, double y,Rect rect) {
    return Path()
      
      ..arcTo(Rect.fromLTWH(-2*x, y/2.5, 3.9*x, y), 0, -3.15, true)
      
      ;
  }
@override
bool shouldRepaint(CustomPainter oldDelegate)=>true;
      
}