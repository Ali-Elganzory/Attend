import 'package:flutter/foundation.dart';

import './classroom.dart';
import './instructor_student.dart';

class InstructorClassroom extends Classroom {
  List<InstructorStudent> _students;

  List<InstructorStudent> get students => this._students;

  set students(List<InstructorStudent> students) {
    this._students = students;
  }

  InstructorClassroom(
      {@required String name,
      @required int weekDay,
      @required String startTime,
      @required String endTime,
      List<InstructorStudent> students})
      : super(
            name: name,
            weekDay: weekDay,
            startTime: startTime,
            endTime: endTime) {
    this._students = students;
  }

  factory InstructorClassroom.fromMap(Map<String, dynamic> classroom) {
    return InstructorClassroom(
      name: classroom['name'],
      weekDay: classroom['weekDay'],
      startTime: classroom['startTime'],
      endTime: classroom['endTime'],
      students: (classroom['students'].values as List<Map<String, dynamic>>)
          .map((student) {
        return InstructorStudent.fromMap(student);
      }).toList(),
    );
  }
}
