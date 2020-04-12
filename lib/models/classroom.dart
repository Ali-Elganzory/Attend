import 'package:flutter/foundation.dart';

import './date.dart';

class Classroom {
  String _id;
  String _name;
  Date _createdAt;
  int _weekDay;
  String _startTime;
  String _endTime;

  String get id => this._id;
  String get name => this._name;
  Date get createdAt => this._createdAt;
  int get weekDay => this._weekDay;
  String get startTime => this._startTime;
  String get endTime => this._endTime;

  set id(String id) {
    this._id = id;
  }

  set name(String name) {
    this._name = name;
  }

  set createdAt(Date createdAt) {
    this._createdAt = createdAt;
  }

  set weekDay(int weekDay) {
    this._weekDay = weekDay;
  }

  set day(int day) {
    this._weekDay = day;
  }

  set startTime(String startTime) {
    this._startTime = startTime;
  }

  set endTime(String endTime) {
    this._endTime = endTime;
  }

  Classroom({
    @required String id,
    @required String name,
    @required Date createdAt,
    @required int weekDay,
    @required String startTime,
    @required String endTime,
  }) {
    this._id = id;
    this._name = name;
    this._createdAt = createdAt;
    this._weekDay = weekDay;
    this._startTime = startTime;
    this._endTime = endTime;
  }
}
