import 'package:flutter/foundation.dart';

import '../utils/constants/month_name.dart';

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

  factory Date.fromMap(Map<String, dynamic> date) {
    return date == null
        ? Date(day: 4, month: 1, year: 2000)
        : Date(
            day: date['day'] ?? 0,
            month: date['month'] ?? 0,
            year: date['year'] ?? 2000,
          );
  }

  factory Date.fromDateTime(DateTime date) {
    return Date(
      day: date.day ?? 0,
      month: date.month ?? 0,
      year: date.year ?? 2000,
    );
  }

  int compare(Date date) {
    if (this._year < date.year)
      return -1;
    else if (this._year > date.year)
      return 1;
    else {
      if (this._month < date.month)
        return -1;
      else if (this._month > date.month)
        return 1;
      else {
        if (this._day < date.day)
          return -1;
        else if (this._day > date.day)
          return 1;
        else
          return 0;
      }
    }
  }

  bool before(Date date) {
    return compare(date) == -1;
  }

  bool same(Date date) {
    return compare(date) == 0;
  }

  bool after(Date date) {
    return compare(date) == 1;
  }

  int compareDateTime(DateTime date) {
    if (this._year < date.year)
      return -1;
    else if (this._year > date.year)
      return 1;
    else {
      if (this._month < date.month)
        return -1;
      else if (this._month > date.month)
        return 1;
      else {
        if (this._day < date.day)
          return -1;
        else if (this._day > date.day)
          return 1;
        else
          return 0;
      }
    }
  }

  bool beforeDateTime(DateTime date) {
    return compareDateTime(date) == -1;
  }

  bool sameDateTime(DateTime date) {
    return compareDateTime(date) == 0;
  }

  bool afterDateTime(DateTime date) {
    return compareDateTime(date) == 1;
  }

  DateTime toDateTime() {
    return DateTime(
      this._year ?? 2000,
      this._month ?? 0,
      this._day ?? 0,
    );
  }

  Map<String, int> toMap() {
    return {
      'day': this._day ?? 0,
      'month': this._month ?? 0,
      'year': this._year ?? 2000,
    };
  }

  String toString() {
    return "${this._day} - ${this._month} - ${this._year}";
  }

  String formated() {
    return "${this._day}, ${monthName[this._month - 1]}. ${this._year}";
  }
}
