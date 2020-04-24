import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/student_classrooms.dart';

import '../components/custom_dialog.dart';

import '../utils/validators/classroom_code_validator.dart';

class JoinClassroomScreen extends StatefulWidget {
  static const routeName = '/joinClassroom';

  @override
  _JoinClassroomScreenState createState() => _JoinClassroomScreenState();
}

class _JoinClassroomScreenState extends State<JoinClassroomScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _classroomCodeKey =
      GlobalKey<FormFieldState>();

  String _classroomCode;

  bool _enableJoin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xAA000000),
        elevation: 1.5,
        title: Text('Join class'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Selector<StudentClassrooms, bool>(
            selector: (_, student) => student.joinClassroomLoading,
            builder: (_, joinClassroomLoading, __) => joinClassroomLoading
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
                    onPressed: this._enableJoin
                        ? () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              StudentClassrooms staticStudent =
                                  Provider.of<StudentClassrooms>(context,
                                      listen: false);

                              staticStudent.joinClassroomLoading = true;

                              try {
                                await staticStudent.joinClassroom(
                                  classroomCode: _classroomCode,
                                );

                                Navigator.pop(context);
                              } catch (error) {
                                showErrorDialog(context, error.toString());
                              }

                              staticStudent.joinClassroomLoading = false;
                            }
                          }
                        : null,
                    child: Text(
                      'JOIN',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'You can get the class code from your instructor.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                key: _classroomCodeKey,
                decoration: classInputDecoration,
                onChanged: (code) {
                  if (code.trim().isNotEmpty) {
                    this._enableJoin = true;
                    setState(() {});
                  } else {
                    this._enableJoin = false;
                    setState(() {});
                  }
                },
                validator: validateClassroomCode,
                onSaved: (code) {
                  this._classroomCode = code;
                },
              ),
              const SizedBox(height: 20.0),
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
  labelText: 'Class code (required)',
  labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 12.0,
    vertical: 16.0,
  ),
);
