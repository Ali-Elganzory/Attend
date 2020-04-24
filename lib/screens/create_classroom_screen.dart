import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/instructor_classrooms.dart';

import '../components/custom_dialog.dart';

import '../utils/constants/week_day.dart';
import '../utils/validators/classroom_name_validator.dart';
import '../utils/validators/hours_validator.dart';
import '../utils/validators/minutes_validator.dart';

class CreateClassroomScreen extends StatefulWidget {
  static const routeName = '/createClassroom';

  CreateClassroomScreen({Key key}) : super(key: key);

  @override
  _CreateClassroomScreenState createState() => _CreateClassroomScreenState();
}

class _CreateClassroomScreenState extends State<CreateClassroomScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _startHourKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _startMinuteKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _endHourKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _endMinuteKey = GlobalKey<FormFieldState>();

  String _weekDay = 'Saturday';
  String _name;
  String _startHour;
  String _startMinute;
  String _endHour;
  String _endMinute;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _startMinuteController = TextEditingController();
  final TextEditingController _endHourController = TextEditingController();
  final TextEditingController _endMinuteController = TextEditingController();

  bool _enableCreate = false;

  @override
  void initState() {
    super.initState();

    _startHourController.text = '0';
    _startMinuteController.text = '0';
    _endHourController.text = '0';
    _endMinuteController.text = '0';
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _startHourController.dispose();
    _startMinuteController.dispose();
    _endHourController.dispose();
    _endMinuteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xAA000000),
        elevation: 1.5,
        title: Text('Create class'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Selector<InstructorClassrooms, bool>(
            selector: (_, instructor) => instructor.createClassroomLoading,
            builder: (_, createClassroomLoading, __) => createClassroomLoading
                ? AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : FlatButton(
                    textColor: Colors.white,
                    disabledColor: Colors.transparent,
                    disabledTextColor: Colors.grey,
                    onPressed: this._enableCreate
                        ? () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              try {
                                String classCode =
                                    await Provider.of<InstructorClassrooms>(
                                            context,
                                            listen: false)
                                        .createClassroom(
                                  name: this._name,
                                  weekDay: weekDayIndex[this._weekDay],
                                  startTime:
                                      "${this._startHour}:${this._startMinute}",
                                  endTime:
                                      "${this._endHour}:${this._endMinute}",
                                );

                                Navigator.pop(context);

                                showDialog(
                                  context: context,
                                  builder: (ctx) => CustomDialog(
                                    title: "The classroom code:",
                                    description: classCode,
                                    positiveButtonText: null,
                                    negativeButtonText: "Okay",
                                  ),
                                );
                              } catch (error) {
                                Provider.of<InstructorClassrooms>(context,
                                        listen: false)
                                    .createClassroomLoading = false;
                                showErrorDialog(context, error.toString());
                              }
                            }
                          }
                        : null,
                    child: Text(
                      'CREATE',
                    ),
                  ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                key: _nameKey,
                decoration: classInputDecoration,
                onChanged: (name) {
                  if (name.trim().isNotEmpty) {
                    this._enableCreate = true;
                    setState(() {});
                  } else {
                    this._enableCreate = false;
                    setState(() {});
                  }
                },
                validator: validateClassroomName,
                onSaved: (name) {
                  this._name = name;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10.0),
                  Text(
                    'Week day: ',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButton(
                      isExpanded: true,
                      value: _weekDay,
                      items: weekDay
                          .map(
                            (day) => DropdownMenuItem(
                              value: day,
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (day) {
                        _weekDay = day;
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Session start: ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      key: _startHourKey,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: hoursInputDecoration,
                      validator: validateHours,
                      onSaved: (hour) {
                        this._startHour = hour;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      key: _startMinuteKey,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: minutesInputDecoration,
                      validator: validateMinutes,
                      onSaved: (minute) {
                        this._startMinute = minute;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Session end: ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      key: _endHourKey,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: hoursInputDecoration,
                      validator: validateHours,
                      onSaved: (hour) {
                        this._endHour = hour;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      key: _endMinuteKey,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: minutesInputDecoration,
                      validator: validateMinutes,
                      onSaved: (minute) {
                        this._endMinute = minute;
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration classInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 8.0,
    ),
  ),
  labelText: 'Class name (required)',
  labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 16.0,
  ),
);

InputDecoration hoursInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 8.0,
    ),
  ),
  labelText: 'hh',
  labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 16.0,
  ),
);

InputDecoration minutesInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
      width: 8.0,
    ),
  ),
  labelText: 'mm',
  labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 16.0,
  ),
);
