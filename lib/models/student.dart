import 'package:cloud_firestore/cloud_firestore.dart';

import './person.dart';
import './student_classroom.dart';
import './date.dart';

class Student extends Person {
  String _id;
  String _email;
  String _collegeId;
  List<Stream<StudentClassroom>> _classrooms = [];

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

  List<Stream<StudentClassroom>> get classrooms => this._classrooms;

  set classrooms(List<Stream<StudentClassroom>> classrooms) {
    this._classrooms = classrooms;
  }

  void addClassroom(Stream<DocumentSnapshot> classroom, List<String> sessions,
      Date lastDateAttended) {
    _classrooms.add(
      classroom.map(
        (DocumentSnapshot classroomDocument) {
          Map<String, dynamic> classroom = classroomDocument.data;

          print(classroom);

          return StudentClassroom(
            id: classroomDocument.documentID ?? "",
            name: classroom['name'] ?? "",
            createdAt: classroom['createdAt'] == null
                ? Date.fromDateTime(DateTime.now())
                : Date.fromMap(classroom['createdAt']),
            weekDay: classroom['weekDay'] ?? 0,
            startTime: classroom['startTime'] ?? "00:00",
            endTime: classroom['endTime'] ?? "00:00",
            instructorName: classroom['instructorName'] ?? "",
            instructorEmail: classroom['instructorEmail'] ?? "",
            lastDateAttended:
                lastDateAttended ?? Date(day: 4, month: 1, year: 2000),
            sessions: sessions ?? [],
          );
        },
      ),
    );
  }
}
