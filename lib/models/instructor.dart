import './person.dart';
import './instructor_classroom.dart';

class Instructor extends Person {
  String _title;
  List<InstructorClassroom> _classrooms;

  String get title => this._title;

  set title(String title) {
    this._title = title;
  }

  List<InstructorClassroom> get classrooms => this._classrooms;

  set classrooms(List<InstructorClassroom> classrooms) {
    this._classrooms = classrooms;
  }
}
