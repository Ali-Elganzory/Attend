import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/instructor.dart';
import '../models/date.dart';

class InstructorClassrooms extends Instructor with ChangeNotifier {
  String _userId;
  String _photo;

  bool _classroomsLoading = false;
  bool _createClassroomLoading = false;
  bool _updateAttendanceConstraintsLoading = false;

  String get photo {
    return this._photo;
  }

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
    this._photo = instructor['photo'];
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

  bool get updateAttendanceConstraintsLoading =>
      this._updateAttendanceConstraintsLoading;

  set updateAttendanceConstraintsLoading(bool b) {
    this._updateAttendanceConstraintsLoading = b;
    notifyListeners();
  }

  Future<void> fetchClassrooms() async {
    classroomsLoading = true;

    QuerySnapshot classrooms = await _firestore
        .collection('classrooms')
        .where('owner', isEqualTo: _userId)
        .getDocuments();

    this.classrooms = [];

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

      Map<String, dynamic> data = classroom.data;
      data.putIfAbsent('id', () => classroom.documentID);
      data.putIfAbsent('students', () => students);

      // print('${data['students']}');
      // print('${data['id']}');

      super.addClassroom(
        data,
      );
    }

    classroomsLoading = false;
  }

  Future<String> createClassroom({
    @required String name,
    @required int weekDay,
    @required String startTime,
    @required String endTime,
  }) async {
    createClassroomLoading = true;

    DocumentReference classroom =
        await _firestore.collection('classrooms').add({
      'createdAt': Date.fromDateTime(DateTime.now()).toMap(),
      'owner': _userId,
      'instructorName': this.name,
      'instructorEmail': email,
      'name': name,
      'weekDay': weekDay,
      'startTime': startTime,
      'endTime': endTime,
    });

    await this.fetchClassrooms();

    createClassroomLoading = false;

    return classroom.documentID;
  }

  Future<void> updateAttendanceConstraints({
    @required String classroomId,
    @required String attendanceCode,
    @required int numOfStudents,
  }) async {
    final bool firstUpdate = (await _firestore
            .collection('classrooms')
            .document(classroomId)
            .collection('attendance constraints')
            .document(Date.fromDateTime(DateTime.now()).toString())
            .get())
        .exists;

    await _firestore
        .collection('classrooms')
        .document(classroomId)
        .collection('attendance constraints')
        .document(Date.fromDateTime(DateTime.now()).toString())
        .setData(
      {
        'attendanceCode': attendanceCode,
        'numOfStudents': numOfStudents,
        if (!firstUpdate) 'attended': 0
      },
      merge: true,
    );
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

    // now update the image in order's document with that same ID
    DocumentReference db =
        Firestore.instance.collection('instructors').document(this._userId);
    await db.updateData({'photo': url});
    this._photo = url;

    notifyListeners();
  }
}
