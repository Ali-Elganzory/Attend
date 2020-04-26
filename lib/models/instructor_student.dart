import 'package:flutter/foundation.dart';

import './person.dart';
import './date.dart';

class InstructorStudent extends Person {
  String _collegeId;
  List<String> _sessions;

  String get collegeId => this._collegeId;

  set collegeId(String collegeId) {
    this._collegeId = collegeId;
  }

  List<String> get sessions => this._sessions;

  set sessions(List<String> sessions) {
    this._sessions = sessions;
  }

  InstructorStudent({
    @required String name,
    @required String collegeId,
    @required List<String> sessions,
  }) {
    this.name = name;
    this._collegeId = collegeId;
    this._sessions = sessions;
  }

  factory InstructorStudent.fromMap(Map<String, dynamic> student) {
    return InstructorStudent(
      name: student['name'],
      collegeId: student['collegeId'],
      sessions: student['sessions']
          .map<String>((session) => session.toString())
          .toList(),
    );
  }
}
