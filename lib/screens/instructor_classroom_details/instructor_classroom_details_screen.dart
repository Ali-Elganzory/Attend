import 'package:flutter/material.dart';

import '../../models/instructor_classroom.dart';

import './instructor_painter.dart';

class InstructorClassroomDetailsScreen extends StatelessWidget {
  static String routName = '/InstructorClassroomDetails';

  InstructorClassroomDetailsScreen({@required this.classroom});

  final InstructorClassroom classroom;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.6 * sh,
            child: Container(),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            height: 0.5 * sh,
            child: CustomPaint(
              painter: InstructorPainter(),
            ),
          ),
        ],
      ),
    );
  }
}