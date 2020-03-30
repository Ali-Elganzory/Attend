import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/instructor.dart';

class InstructorClassrooms extends Instructor with ChangeNotifier {
  String _userId;

  bool _classroomsLoading = false;
  bool _createClassroomLoading = false;

  Firestore _firestore = Firestore.instance;

  Future<void> getUserIdAndNameAndEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _userId = extractedUserData['userId'];

    DocumentSnapshot instructor =
        await _firestore.collection('instructors').document(_userId).get();
    this.name = instructor['fullName'];
    this.email = instructor['email'];
  }

  bool get classroomsLoading => this._classroomsLoading;

  set classroomsLoading(bool b) {
    this._classroomsLoading = b;
    notifyListeners();
  }

  bool get createClassroomLoading => this._createClassroomLoading;

  set createClassroomLoading(bool b) {
    this._createClassroomLoading = b;
    notifyListeners();
  }

  Future<void> fetchClassrooms() async {
    classroomsLoading = true;

    QuerySnapshot classrooms = await _firestore
        .collection('classrooms')
        .where('owner', isEqualTo: _userId)
        .getDocuments();

    for (var classroom in classrooms.documents) {
      Map<String, dynamic> students = {};
      (await _firestore
              .collection('classrooms')
              .document(classroom.documentID)
              .collection('students')
              .getDocuments())
          .documents
          .forEach((studentDocument) {
        students.putIfAbsent(
            studentDocument.documentID, () => studentDocument.data);
      });

      classroom.data.putIfAbsent('students', () => students);

      super.addClassroom(classroom.data);
    }

    classroomsLoading = false;
  }

  Future<void> createClassroom({
    @required String name,
    @required int weekDay,
    @required String startTime,
    @required String endTime,
  }) async {
    createClassroomLoading = true;

    DocumentReference classroom =
        await _firestore.collection('classrooms').add({
      'owner': _userId,
      'instructorName': 'nnnnnnn',
      'instructorEmail': email,
      'name': name,
      'weekDay': weekDay,
      'startTime': startTime,
      'endTime': endTime,
    });

    this.classrooms = [];
    await this.fetchClassrooms();

    createClassroomLoading = false;
  }
}