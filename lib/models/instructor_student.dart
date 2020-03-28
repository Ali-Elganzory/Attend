import 'package:flutter/foundation.dart';

import './person.dart';
import './date.dart';

class InstructorStudent extends Person {
  String _id;
  List<Date> _sessions;

  String get id => this._id;

  set id(String id) {
    this._id = id;
  }

  List<Date> get sessions => this._sessions;

  set sessions(List<Date> sessions) {
    this._sessions = sessions;
  }

  InstructorStudent({@required String id, @required List<Date> sessions}) {
    this._id = id;
    this._sessions = sessions;
  }

  factory InstructorStudent.fromMap(Map<String, dynamic> student) {
    return InstructorStudent(
        id: student['collegeId'],
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
