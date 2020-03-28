import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/instructor.dart';

class InstructorClassrooms extends Instructor with ChangeNotifier {
  String _userId;

  Firestore _firestore = Firestore.instance;

  Future<bool> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _userId = extractedUserData['userId'];

    if (_userId != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> fetchClassrooms() {
    _firestore
        .collection('classrooms')
        .where('owner', isEqualTo: _userId)
        .snapshots()
        .listen((event) {
      event.documents.forEach((classroom) {
        super.addClassroom(classroom.data);
      });

      notifyListeners();
    });
  }

  Future<String> addOnlineClassroom({
    @required String name,
    @required int weekDay,
    @required String startTime,
    @required String endTime,
  }) {
    _firestore.collection('classrooms').add({
      'owner': _userId,
      'instructor': 'nnnnnnn',
      'name': name,
      'weekDay': weekDay,
      'startTime': startTime,
      'endTime': endTime,
      'students': [],
    });
  }
}
