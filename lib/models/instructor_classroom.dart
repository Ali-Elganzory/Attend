import './classroom.dart';
import './student.dart';

class InstructorClassroom extends Classroom {
  List<Student> _students;

  List<Student> get students => this._students;

  set students(List<Student> students) {
    this._students = students;
  }
}
