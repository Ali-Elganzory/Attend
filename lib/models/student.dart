import './person.dart';
import './student_classroom.dart';

class Student extends Person {
  String _id;
  String _email;
  String _collegeId;
  List<StudentClassroom> _classrooms = [];

  String get id => this._id;

  set id(String id) {
    this._id = id;
  }

  String get email => this._email;

  set email(String email) {
    this._email = email;
  }

  String get collegeId => this._collegeId;

  set collegeId(String collegeId) {
    this._collegeId = collegeId;
  }

  List<StudentClassroom> get classrooms => this._classrooms;

  set classrooms(List<StudentClassroom> classrooms) {
    this._classrooms = classrooms;
  }

  void addClassroom(Map<String, dynamic> classroom) {
    _classrooms.add(StudentClassroom.fromMap(classroom));
  }
}
