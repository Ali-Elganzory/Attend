import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/student_classrooms.dart';

import '../../models/student_classroom.dart';
import '../../models/date.dart';

import '../../components/general_app_drawer.dart';
import '../../components/custom_dialog.dart';

import './attendance_table.dart';
import './student_painter.dart';

class StudentClassroomDetailsScreen extends StatefulWidget {
  static const String routName = '/studentClassroomDetails';

  const StudentClassroomDetailsScreen({@required this.classroom});

  final StudentClassroom classroom;

  @override
  _StudentClassroomDetailsScreenState createState() =>
      _StudentClassroomDetailsScreenState();
}

class _StudentClassroomDetailsScreenState
    extends State<StudentClassroomDetailsScreen> {
  GlobalKey<FormState> _formKey;

  String attendanceCode;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final Date now = Date.fromDateTime(date);

    bool enableAttend() {
      int startTimeHour =
          int.tryParse(widget.classroom.startTime.split(':')[0]) ?? 0;
      int startTimeMinute =
          int.tryParse(widget.classroom.startTime.split(':')[1]) ?? 0;
      int endTimeHour =
          int.tryParse(widget.classroom.endTime.split(':')[0]) ?? 0;
      int endTimeMinute =
          int.tryParse(widget.classroom.endTime.split(':')[1]) ?? 0;

      /* print(
          "${date.hour} ${startTimeHour} \n ${date.minute}  ${startTimeMinute} \n ${date.hour}  ${endTimeHour} \n ${date.minute}  ${endTimeMinute}");
      */

      return (date.hour >= startTimeHour ||
              (date.hour == startTimeHour && date.minute >= startTimeMinute)) &&
          (date.hour <= endTimeHour ||
              (date.hour == endTimeHour && date.minute <= endTimeMinute));
    }

    Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width;

    return Scaffold(
      drawer: GeneralAppDrawer(
        userType: "student",
      ),
      appBar: AppBar(
        elevation: 1.5,
        title: Text(
          '${widget.classroom.name}',
        ),
        actions: <Widget>[
          Center(
            child: Text(
              widget.classroom.lastDateAttended.before(now) && enableAttend()
                  ? "On"
                  : "Off",
            ),
          ),
          Container(
            height: 15,
            width: 15,
            margin: EdgeInsets.only(right: 30, left: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.classroom.lastDateAttended.before(now) &&
                      enableAttend()
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 50,
            child: AttendanceTable(
              classroom: widget.classroom,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 0.50 * sh,
            child: CustomPaint(
              painter: StudentPainter(),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 180.0,
                      width: 180.0,
                      margin: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        onPressed: widget.classroom.lastDateAttended
                                    .before(now) &&
                                enableAttend()
                            ? () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  try {
                                    await Provider.of<StudentClassrooms>(
                                            context,
                                            listen: false)
                                        .attend(
                                            classroomCode: widget.classroom.id,
                                            attendanceCode: attendanceCode);
                                  } catch (error) {
                                    showErrorDialog(context, error.toString());
                                  }
                                }
                              }
                            : null,
                        child: Text(
                          'Attend',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          enabled:
                              widget.classroom.lastDateAttended.before(now) &&
                                  enableAttend(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(163, 160, 185, 1),
                          ),
                          decoration: inputDecoration.copyWith(
                              hintText: "Attendance code"),
                          keyboardType: TextInputType.number,
                          validator: (code) {
                            if (code == "") return "Please, enter a code";
                            return code.length <= 3
                                ? "code >= 4 characters"
                                : null;
                          },
                          onSaved: (code) {
                            attendanceCode = code;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final inputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.only(
    top: 2.5,
    bottom: 2.5,
    left: 2.0,
    right: 2.0,
  ),
  filled: true,
  fillColor: Colors.white,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
  hintStyle: TextStyle(
    fontSize: 16,
    color: Colors.black45,
  ),
);
