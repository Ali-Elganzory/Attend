import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student.dart';
import '../models/date.dart';

class StudentClassrooms extends Student with ChangeNotifier {
  String _userId;
  List<dynamic> _classroomsReferences;

  bool _classroomsLoading = false;
  bool _joinClassroomLoading = false;

  Firestore _firestore = Firestore.instance;

  Future<void> getUserIdAndNameAndEmailAndClassroomsReferences() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _userId = extractedUserData['userId'];

    DocumentSnapshot student =
        await _firestore.collection('students').document(_userId).get();
    this.name = student['fullName'];
    this.email = student['email'];
    this.collegeId = student['collegeId'];
    this._classroomsReferences = student['classrooms'];
  }

  bool get classroomsLoading => this._classroomsLoading;

  set classroomsLoading(bool b) {
    this._classroomsLoading = b;
    notifyListeners();
  }

  bool get joinClassroomLoading => this._joinClassroomLoading;

  set joinClassroomLoading(bool b) {
    this._joinClassroomLoading = b;
    notifyListeners();
  }

  Future<void> fetchClassrooms() async {
    classroomsLoading = true;

    for (var classroomReference in _classroomsReferences) {
      Map<String, dynamic> classroom = (await _firestore
              .collection('classrooms')
              .document(classroomReference)
              .get())
          .data;

      List<dynamic> sessions = (await _firestore
              .collection('classrooms')
              .document(classroomReference)
              .collection('students')
              .document(_userId)
              .get())
          .data['sessions'];

      classroom.putIfAbsent('sessions', () => sessions);

      super.addClassroom(classroom);
    }

    classroomsLoading = false;
  }

  Future<void> joinClassroom({
    @required String classroomCode,
  }) async {
    joinClassroomLoading = true;

    await _firestore
        .collection('classrooms')
        .document(classroomCode)
        .collection('students')
        .document(_userId)
        .setData({
      'name': this.name,
      'collegeId': this.collegeId,
      'sessions': [],
    });

    await _firestore.collection('students').document(_userId).updateData({
      'classrooms': FieldValue.arrayUnion([classroomCode])
    });

    await this.getUserIdAndNameAndEmailAndClassroomsReferences();
    await this.fetchClassrooms();

    joinClassroomLoading = false;
  }

  Future<void> leaveClassroom({
    @required String classroomCode,
  }) async {
    joinClassroomLoading = true;

    await _firestore
        .collection('classrooms')
        .document(classroomCode)
        .collection('students')
        .document(_userId)
        .delete();

    await _firestore.collection('students').document(_userId).updateData({
      'classrooms': FieldValue.arrayRemove([classroomCode])
    });

    await this.getUserIdAndNameAndEmailAndClassroomsReferences();
    this.classrooms = [];
    await this.fetchClassrooms();

    joinClassroomLoading = false;
  }

  Future<void> attend(String classroomCode) async {
    DateTime now = DateTime.now();

    await _firestore
        .collection('classrooms')
        .document(classroomCode)
        .collection('students')
        .document(_userId)
        .updateData(
      {
        'classrooms': FieldValue.arrayUnion(
            [Date(day: now.day, month: now.month, year: now.year)])
      },
    );
  }
}
