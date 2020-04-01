import 'package:flutter/foundation.dart';

import './classroom.dart';
import './instructor_student.dart';
import './date.dart';

class InstructorClassroom extends Classroom {
  List<InstructorStudent> _students;

  List<InstructorStudent> get students => this._students;

  set students(List<InstructorStudent> students) {
    this._students = students;
  }

  InstructorClassroom({
    @required String name,
    @required Date createdAt,
    @required int weekDay,
    @required String startTime,
    @required String endTime,
    List<InstructorStudent> students,
  }) : super(
            name: name,
            createdAt: createdAt,
            weekDay: weekDay,
            startTime: startTime,
            endTime: endTime) {
    this._students = students;
  }

  factory InstructorClassroom.fromMap(Map<String, dynamic> classroom) {
    print(classroom['students']);
    return InstructorClassroom(
      name: classroom['name'] ?? "",
      createdAt: classroom['createdAt'] == null
          ? Date.fromMap(classroom['createdAt'])
          : Date.fromDateTime(DateTime.now()),
      weekDay: classroom['weekDay'] ?? 0,
      startTime: classroom['startTime'] ?? "00:00",
      endTime: classroom['endTime'] ?? "00:00",
      students: classroom['students'] == null
          ? {}.values
          : classroom['students'].values.map<InstructorStudent>((student) {
              return InstructorStudent.fromMap(student);
            }).toList(),
    );
  }
}
