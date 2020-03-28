import 'package:flutter/foundation.dart';

import '../utils/month_name.dart';

class Date {
  int _day;
  int _month;
  int _year;

  int get day => this._day;
  int get month => this._month;
  int get year => this._year;

  set day(int day) {
    this._day = day;
  }

  set month(int month) {
    this._month = month;
  }

  set year(int year) {
    this._year = year;
  }

  Date({
    @required int day,
    @required int month,
    @required int year,
  }) {
    this._day = day;
    this._month = month;
    this._year = year;
  }

  String toString() {
    return "${this._day} - ${this._month} - ${this._year}";
  }

  String formated() {
    return "${this._day}, ${monthName[this._month - 1]}. ${this._year}";
  }
}
