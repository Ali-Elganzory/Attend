import './person.dart';
import './instructor_classroom.dart';

class Instructor extends Person {
  String _title;
  String _email;
  List<InstructorClassroom> _classrooms = [];

  String get title => this._title;

  set title(String title) {
    this._title = title;
  }

  String get email => this._email;

  set email(String email) {
    this._email = email;
  }

  List<InstructorClassroom> get classrooms => this._classrooms;

  set classrooms(List<InstructorClassroom> classrooms) {
    this._classrooms = classrooms;
  }

  void addClassroom(Map<String, dynamic> classroom) {
    _classrooms.add(InstructorClassroom.fromMap(classroom));
  }
}
