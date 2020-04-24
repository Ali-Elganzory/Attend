import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/student.dart';
import '../models/date.dart';

class StudentClassrooms extends Student with ChangeNotifier {
  String _userId;
  String _photo;

  List<dynamic> _classroomsReferences;

  bool _classroomsLoading = false;
  bool _joinClassroomLoading = false;

  String get photo {
    return this._photo;
  }

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
    this._photo = student['photo'];
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

    this.classrooms = [];

    for (var classroomReference in _classroomsReferences) {
      DocumentSnapshot classroomDocument = await _firestore
          .collection('classrooms')
          .document(classroomReference)
          .get();

      if (!classroomDocument.exists) {
        continue;
      }

      Map<String, dynamic> classroom = classroomDocument.data;

      List<dynamic> sessions = (await _firestore
              .collection('classrooms')
              .document(classroomReference)
              .collection('students')
              .document(_userId)
              .get())
          .data['sessions'];

      classroom.putIfAbsent('id', () => classroomReference);
      classroom.putIfAbsent('sessions', () => sessions);

      super.addClassroom(classroom);
    }

    classroomsLoading = false;
  }

  Future<void> joinClassroom({
    @required String classroomCode,
  }) async {
    if (classrooms.any((classroom) => classroom.id == classroomCode)) {
      throw Exception("Already joined!");
    }

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
    await this.fetchClassrooms();

    joinClassroomLoading = false;
  }

  Future<void> attend(
      {@required String classroomCode, @required String attendanceCode}) async {
    DateTime now = DateTime.now();

    final attendanceConstraint = await _firestore
        .collection('classrooms')
        .document(classroomCode)
        .collection('attendance constraints')
        .document(Date.fromDateTime(DateTime.now()).toString())
        .get();

    if (!attendanceConstraint.exists) {
      throw Exception("no code");
    }

    if (attendanceCode != attendanceConstraint.data['attendanceCode']) {
      throw Exception("wrong code");
    }

    if (attendanceConstraint.data['attended'] >=
        attendanceConstraint.data['numOfStudents']) {
      throw Exception("expired code");
    }

    await _firestore
        .collection('classrooms')
        .document(classroomCode)
        .collection('attendance constraints')
        .document(Date.fromDateTime(DateTime.now()).toString())
        .updateData(
      {
        'attended': FieldValue.increment(1),
      },
    );

    await _firestore
        .collection('classrooms')
        .document(classroomCode)
        .collection('students')
        .document(_userId)
        .updateData(
      {
        'lastDateAttended': Date.fromDateTime(now).toMap(),
        'sessions': FieldValue.arrayUnion([Date.fromDateTime(now).toString()])
      },
    );

    classrooms
        .firstWhere((classroom) => classroom.id == classroomCode)
        .sessions
        .add(Date.fromDateTime(now).toString());
  }

  Future<void> uploadPhoto(File photo) async {
    //  use the obtained ID to name the photo to be uploaded
    StorageReference photoRef = FirebaseStorage.instance
        .ref()
        .child("profile_photos")
        .child(this._userId);
    StorageUploadTask uploadTask = photoRef.putFile(
        photo, StorageMetadata(customMetadata: {"ownerId": this._userId}));

    await uploadTask.onComplete;
    String url = (await photoRef.getDownloadURL()).toString();

    // now update the image in student's document with that same ID
    DocumentReference db =
        Firestore.instance.collection('students').document(this._userId);
    await db.updateData({'photo': url});
    this._photo = url;

    notifyListeners();
  }
}
