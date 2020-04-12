import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/student_classrooms.dart';

import '../../models/student_classroom.dart';
import '../../models/date.dart';

import './attendance_table.dart';
import './loawer_part_painter.dart';

class StudentClassroomDetailsScreen extends StatelessWidget {
  static const String routName = '/studentClassroomDetails';

  const StudentClassroomDetailsScreen({@required this.classroom});

  final StudentClassroom classroom;

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final Date now = Date.fromDateTime(date);

    bool enableAttend() {
      int startTimeHour = int.tryParse(classroom.startTime.split(':')[0]) ?? 0;
      int startTimeMinute =
          int.tryParse(classroom.startTime.split(':')[1]) ?? 0;
      int endTimeHour = int.tryParse(classroom.endTime.split(':')[0]) ?? 0;
      int endTimeMinute = int.tryParse(classroom.endTime.split(':')[1]) ?? 0;

      print(
          "${date.hour} ${startTimeHour} \n ${date.minute}  ${startTimeMinute} \n ${date.hour}  ${endTimeHour} \n ${date.minute}  ${endTimeMinute}");

      print(date.hour >= startTimeHour &&
          date.minute >= startTimeMinute &&
          date.hour <= endTimeHour &&
          date.minute <= endTimeMinute);

      return (date.hour >= startTimeHour &&
          date.minute >= startTimeMinute &&
          date.hour <= endTimeHour &&
          date.minute <= endTimeMinute);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.5,
        iconTheme: IconThemeData(
          color: Color(0xCC000000),
        ),
        title: Text(
          '${classroom.name}',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Color(0xCC000000),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AttendanceTable(
              classroom: classroom,
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: LowerPartPainter(),
              child: Center(
                child: FlatButton(
                  onPressed:
                      classroom.lastDateAttended.before(now) && enableAttend()
                          ? () {}
                          : null,
                  child: Text('Attend'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
