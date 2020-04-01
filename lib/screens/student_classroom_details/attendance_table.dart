import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

import '../../models/student_classroom.dart';
import '../../models/date.dart';

class AttendanceTable extends StatefulWidget {
  AttendanceTable({Key key, @required this.classroom}) : super(key: key);

  final StudentClassroom classroom;

  @override
  _AttendanceTableState createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  StudentClassroom classroom;

  List<int> offDays = [DateTime.friday];

  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    classroom = widget.classroom;
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    super.dispose();

    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    return TableCalendar(
      calendarController: _calendarController,
      startDay: classroom.createdAt.toDateTime(),
      endDay: today,
      startingDayOfWeek: StartingDayOfWeek.saturday,
      weekendDays: offDays,
      availableGestures: AvailableGestures.horizontalSwipe,
      formatAnimation: FormatAnimation.slide,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        unavailableDayBuilder: (_, date, __) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
        weekendDayBuilder: (_, date, __) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
        todayDayBuilder: (_, date, __) {
          if (!offDays.contains(date.weekday))
            return Container(
              margin: EdgeInsets.all(5),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0XFFe3e3e3),
                    blurRadius: 5,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            );
          else
            return Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
        },
        dayBuilder: (_, date, __) {
          if (date.weekday == classroom.weekDay) {
            return Container(
              margin: EdgeInsets.all(5),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0XFFe3e3e3),
                    blurRadius: 5,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            );
          }
        },
        markersBuilder: (_, date, __, holidays) {
          final children = <Widget>[];

          return children;
        },
      ),
    );
  }
}
