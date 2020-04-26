import 'package:flutter/foundation.dart';

import './person.dart';
import './date.dart';

class InstructorStudent extends Person {
  String _collegeId;
  Date _lastDateAttended;
  List<String> _sessions;

  String get collegeId => this._collegeId;

  set collegeId(String collegeId) {
    this._collegeId = collegeId;
  }

  Date get lastDateAttended => this._lastDateAttended;

  set lastDateAttended(Date lastDateAttended) {
    this._lastDateAttended = lastDateAttended;
  }

  List<String> get sessions => this._sessions;

  set sessions(List<String> sessions) {
    this._sessions = sessions;
  }

  InstructorStudent({
    @required String name,
    @required String collegeId,
    @required Date lastDateAttended,
    @required List<String> sessions,
  }) {
    this.name = name;
    this._collegeId = collegeId;
    this._lastDateAttended = lastDateAttended;
    this._sessions = sessions;
  }

  factory InstructorStudent.fromMap(Map<String, dynamic> student) {
    return InstructorStudent(
      name: student['name'],
      collegeId: student['collegeId'],
      lastDateAttended: Date.fromMap(student['lastDateAttended']) ??
          Date(day: 4, month: 1, year: 2000),
      sessions: student['sessions']
          .map<String>((session) => session.toString())
          .toList(),
    );
  }
}
