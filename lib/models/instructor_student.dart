import 'package:flutter/foundation.dart';

import './person.dart';
import './date.dart';

class InstructorStudent extends Person {
  String _collegeId;
  List<Date> _sessions;

  String get collegeId => this._collegeId;

  set collegeId(String collegeId) {
    this._collegeId = collegeId;
  }

  List<Date> get sessions => this._sessions;

  set sessions(List<Date> sessions) {
    this._sessions = sessions;
  }

  InstructorStudent(
      {@required String collegeId, @required List<Date> sessions}) {
    this._collegeId = collegeId;
    this._sessions = sessions;
  }

  factory InstructorStudent.fromMap(Map<String, dynamic> student) {
    return InstructorStudent(
        collegeId: student['collegeId'],
        sessions: (student['sessions'].values as List<Map<String, dynamic>>)
            .map((session) {
          return Date(
            day: session['day'],
            month: session['month'],
            year: session['year'],
          );
        }).toList());
  }
}
