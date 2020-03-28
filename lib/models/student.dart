import './person.dart';
import './student_classroom.dart';

class Student extends Person {
  String _id;
  List<StudentClassroom> _classrooms;

  String get id => this._id;

  set id(String id) {
    this._id = id;
  }

  List<StudentClassroom> get classrooms => this._classrooms;

  set classrooms(List<StudentClassroom> classrooms) {
    this._classrooms = classrooms;
  }
}
