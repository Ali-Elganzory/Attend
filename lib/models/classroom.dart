class Classroom {
  String _name;
  String _day;
  String _startTime;
  String _endTime;

  String get name => this._name;
  String get day => this._day;
  String get startTime => this._startTime;
  String get endTime => this._endTime;

  set name(String name) {
    this._name = name;
  }

  set day(String day) {
    this._day = day;
  }

  set startTime(String startTime) {
    this._startTime = startTime;
  }

  set endTime(String endTime) {
    this._endTime = endTime;
  }
}
