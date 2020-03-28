import 'package:flutter/foundation.dart';

class Classroom {
  String _name;
  int _weekDay;
  String _startTime;
  String _endTime;

  String get name => this._name;
  int get day => this._weekDay;
  String get startTime => this._startTime;
  String get endTime => this._endTime;

  set name(String name) {
    this._name = name;
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
    @required String name,
    @required int weekDay,
    @required String startTime,
    @required String endTime,
  }) {
    this._name = name;
    this._weekDay = weekDay;
    this._startTime = startTime;
    this._endTime = endTime;
  }
}
