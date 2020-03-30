import 'package:flutter/foundation.dart';

import './classroom.dart';
import './date.dart';

class StudentClassroom extends Classroom {
  String _instructorName;
  String _instructorEmail;
  List<Date> _sessions;

  String get instructorName => this._instructorName;

  set instructorName(String instructorName) {
    this._instructorName = instructorName;
  }

  String get instructorEmail => this._instructorEmail;

  set instructorEmail(String instructorEmail) {
    this._instructorEmail = instructorEmail;
  }

  List<Date> get sessions => this._sessions;

  set sessions(List<Date> sessions) {
    this._sessions = sessions;
  }

  StudentClassroom(
      {@required String name,
      @required int weekDay,
      @required String startTime,
      @required String endTime,
      @required String instructorName,
      @required String instructorEmail,
      List<Date> sessions})
      : super(
            name: name,
            weekDay: weekDay,
            startTime: startTime,
            endTime: endTime) {
    this._instructorName = instructorName;
    this._instructorEmail = instructorEmail;
    this._sessions = sessions;
  }

  factory StudentClassroom.fromMap(Map<String, dynamic> classroom) {
    print(classroom);
    return StudentClassroom(
      name: classroom['name'] ?? "",
      weekDay: classroom['weekDay'] ?? 0,
      startTime: classroom['startTime'] ?? "00:00",
      endTime: classroom['endTime'] ?? "00:00",
      instructorName: classroom['instructorName'] ?? "",
      instructorEmail: classroom['instructorEmail'] ?? "",
      sessions: (classroom['sessions'] == null
              ? []
              : classroom['sessions'] as List<dynamic>)
          .map((session) {
        return Date.fromMap(session);
      }).toList(),
    );
  }
}
