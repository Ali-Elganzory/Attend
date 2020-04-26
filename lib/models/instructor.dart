import 'package:cloud_firestore/cloud_firestore.dart';

import './person.dart';
import './instructor_classroom.dart';
import './instructor_student.dart';
import './date.dart';

class Instructor extends Person {
  String _title;
  String _email;
  List<Stream<InstructorClassroom>> _classrooms = [];

  String get title => this._title;

  set title(String title) {
    this._title = title;
  }

  String get email => this._email;

  set email(String email) {
    this._email = email;
  }

  List<Stream<InstructorClassroom>> get classrooms => this._classrooms;

  set classrooms(List<Stream<InstructorClassroom>> classrooms) {
    this._classrooms = classrooms;
  }

  void addClassroom(Stream<DocumentSnapshot> classroom,
      Stream<List<InstructorStudent>> students) {
    _classrooms.add(
      classroom.map(
        (DocumentSnapshot classroomDocument) {
          Map<String, dynamic> classroom = classroomDocument.data;

          // print(classroom);

          return InstructorClassroom(
            id: classroomDocument.documentID ?? "",
            name: classroom['name'] ?? "",
            createdAt: classroom['createdAt'] == null
                ? Date.fromDateTime(DateTime.now())
                : Date.fromMap(classroom['createdAt']),
            weekDay: classroom['weekDay'] ?? 0,
            startTime: classroom['startTime'] ?? "00:00",
            endTime: classroom['endTime'] ?? "00:00",
            students: students,
          );
        },
      ),
    );
  }
}
