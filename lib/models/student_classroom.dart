import './classroom.dart';
import './date.dart';

class StudentClassroom extends Classroom {
  String _instructor;
  List<Date> _sessions;

  String get instructor => this._instructor;

  set instructor(String instructor) {
    this._instructor = instructor;
  }

  List<Date> get sessions => this._sessions;

  set sessions(List<Date> sessions) {
    this._sessions = sessions;
  }
}
